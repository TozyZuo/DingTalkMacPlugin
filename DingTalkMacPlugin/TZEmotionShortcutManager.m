//
//  TZEmotionShortCutManager.m
//  DingTalkMacPlugin
//
//  Created by TozyZuo on 2019/12/24.
//  Copyright © 2019 TozyZuo. All rights reserved.
//

#import "TZEmotionShortcutManager.h"

#ifndef TLog
#define TLog(...) NSLog(__VA_ARGS__)
#endif

static NSString *WordsToPinYin(NSString *words)
{
    NSMutableString *str = words.mutableCopy;
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    [str replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, str.length)];
    return str;
}

static NSString *WordsFirstLetterToPinYin(NSString *words)
{
    NSMutableString *py = NSMutableString.string;
    for (int i = 0; i < words.length; i++) {
        NSMutableString *str = [words substringWithRange:NSMakeRange(i, 1)].mutableCopy;
        CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
        CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
        [py appendString:[str substringToIndex:1]];
    }
    return py;
}

static CGFloat PriorityForFilterConditionAndString(NSString *conditionText, NSString *string)
{
    if (!(string.length && conditionText.length)) {
        return -1;
    }
    
    NSInteger index = 0;
    
    for (int i = 0; i < conditionText.length; i++) {
        NSRange range = [string rangeOfString:[conditionText substringWithRange:NSMakeRange(i, 1)] options:NSCaseInsensitiveSearch range:NSMakeRange(index, string.length - index)];
        index = NSMaxRange(range);
        if (range.location == NSNotFound) {
            return -1;
        }
    }
    
    return conditionText.length/(CGFloat)string.length;
}

@interface TZEmotionMatchingResult ()
@property (readwrite) NSRange range;
@property (readwrite) NSArray<id<TZEmotion>> *emotions;
@end
@implementation TZEmotionMatchingResult
@end

@interface TZEmotionShortcutManager ()
@property (nonatomic) NSMutableDictionary<NSString *, id<TZEmotion>> *shortcutMap;
@property (nonatomic) NSMutableDictionary<NSString *, id<TZEmotion>> *map;
@property (nonatomic) NSRegularExpression *shortcutRegularExpression;
@end

@implementation TZEmotionShortcutManager

- (void)setEmotions:(NSArray<id<TZEmotion>> *)emotions
{
    if (emotions) {
        _shortcutMap = NSMutableDictionary.new;
        _map = NSMutableDictionary.new;
        NSMutableArray *dupKeys = NSMutableArray.new;
        for (id<TZEmotion> emotion in emotions) {
            NSString *name = emotion.name;
            NSString *py = WordsToPinYin(name).lowercaseString;
            NSString *key = [NSString stringWithFormat:@"/%@", py]; // 全拼
            NSString *spy = WordsFirstLetterToPinYin(name).lowercaseString;
            NSString *sKey = [NSString stringWithFormat:@"/%@", spy]; // 简写
            
            // 全拼key
            if ([_map.allKeys containsObject:key]) {
                TLog(@"Duplicate key in map %@ %@ %@", key, _map[key].name, name);
            }
            _map[key] = emotion;
            
            // 短拼(包含全拼)
            if ([_shortcutMap.allKeys containsObject:key]) {
                TLog(@"Duplicate key in shortcut map %@ %@ %@", key, _shortcutMap[key].name, name);
            }
            _shortcutMap[key] = emotion;
            
            // 移除重复的短拼
            if ([_shortcutMap.allKeys containsObject:sKey] && ![key isEqualToString:sKey]) {
                TLog(@"Duplicate short Key %@ %@ %@", sKey, _shortcutMap[sKey].name, name);
                _shortcutMap[sKey] = emotion;
                [dupKeys addObject:sKey];
            } else {
                _shortcutMap[sKey] = emotion;
            }
        }
        [_shortcutMap removeObjectsForKeys:dupKeys];
        [dupKeys removeAllObjects];
        
        NSArray *allKeys = _shortcutMap.allKeys;
        NSMutableSet *set = NSMutableSet.new;
        for (NSString *key1 in allKeys) {
            for (NSString *key2 in allKeys) {
                if ([key2 hasPrefix:key1] && ![key2 isEqualToString:key1] && _shortcutMap[key1] != _shortcutMap[key2])
                {
                    if ([_map.allKeys containsObject:key1]) {
                        [set addObject:key2];
                        TLog(@"Conflict short key key1 %@ %@ key2 %@ %@ remove key2 %@", key1, _shortcutMap[key1].name, key2, _shortcutMap[key2].name, key2);
                    } else {
                        [set addObject:key1];
                        TLog(@"Conflict short key key1 %@ %@ key2 %@ %@ remove key1 %@", key1, _shortcutMap[key1].name, key2, _shortcutMap[key2].name, key1);
                    }
                }
            }
        }
        
        [_shortcutMap removeObjectsForKeys:set.allObjects];
        TLog(@"Collection completed, %lu emotions, %lu shortcuts", (unsigned long)emotions.count, (unsigned long)_shortcutMap.count);
        // 移除重复key
        [_map removeObjectsForKeys:_shortcutMap.allKeys];
        
        _shortcutRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"/[a-zA-Z\\d]+" options:0 error:nil];
    }
}

- (NSArray<TZEmotionMatchingResult *> *)matchString:(NSString *)string
{
    return [self matchString:string range:NSMakeRange(0, string.length)];
}

- (NSArray<TZEmotionMatchingResult *> *)matchString:(NSString *)string range:(NSRange)range
{
    NSArray<NSTextCheckingResult *> *results = [_shortcutRegularExpression matchesInString:string options:0 range:range];
    
    if (results.count) {
        NSMutableArray *matchStrings = NSMutableArray.new;
        for (NSTextCheckingResult *result in results) {
            [matchStrings addObject:[string substringWithRange:result.range]];
        }
        TLog(@"Match %@", [matchStrings componentsJoinedByString:@" "]);
        
        NSMutableArray<TZEmotionMatchingResult *> *ret = NSMutableArray.new;
        for (int i = 0; i < results.count; i++) {
            NSString *key = matchStrings[i];
            NSMutableArray *keys = NSMutableArray.new;
            NSMutableArray<id<TZEmotion>> *emotions = NSMutableArray.new;
            for (NSString *aKey in _shortcutMap.allKeys) {
                CGFloat priority = PriorityForFilterConditionAndString(key, aKey);
                if (priority == 1) {
                    [keys removeAllObjects];
                    [keys addObject:aKey];
                    break;
                }
                if (priority > 0) {
                    // TODO 优先级排序
                    [keys addObject:aKey];
                }
            }
            
            if (keys.count) {
                TLog(@"%@ match keys in shortcut map: %@", key, keys);
                for (NSString *key in keys) {
                    [emotions addObject:_shortcutMap[key]];
                }
            } else {
                for (NSString *aKey in _map.allKeys) {
                    CGFloat priority = PriorityForFilterConditionAndString(key, aKey);
                    if (priority == 1) {
                        [keys removeAllObjects];
                        [keys addObject:aKey];
                        break;
                    }
                    if (priority > 0) {
                        // TODO 优先级排序
                        [keys addObject:aKey];
                    }
                }
                TLog(@"%@ match keys in map: %@", key, keys);
                for (NSString *key in keys) {
                    [emotions addObject:_map[key]];
                }
            }
            
            TZEmotionMatchingResult *result = [[TZEmotionMatchingResult alloc] init];
            result.range = results[i].range;
            result.emotions = emotions;
            [ret addObject:result];
        }
        
        return ret.count ? ret : nil;
    }
    
    return nil;
}

@end
