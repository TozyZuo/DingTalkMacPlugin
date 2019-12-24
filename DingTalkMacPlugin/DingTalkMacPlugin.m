//
//  DingTalkMacPlugin.m
//  DingTalkMacPlugin
//
//  Created by TozyZuo on 2018/9/25.
//  Copyright (c) 2018年 TozyZuo. All rights reserved.
//

#import "DingTalkMacPlugin.h"
#import "DingTalkMacPluginHeader.h"
#import <CaptainHook/CaptainHook.h>
#import "CRNode.h"

NSRegularExpression *_shortCutRegularExpression;
//CHDeclareClass(SUUpdater)
//CHOptimizedMethod2(self, void, SUUpdater, showAlertText, id, arg1, informativeText, id, arg2)
//{
//
//}

CHDeclareClass(SUCodeSigningVerifier)
CHOptimizedClassMethod1(self, BOOL, SUCodeSigningVerifier, bundleAtURLIsCodeSigned, id, arg1)
{
    return YES;
}


CHDeclareClass(NSTableView)
CHOptimizedMethod0(self, void, NSTableView, reloadData)
{
    CHSuper0(NSTableView, reloadData);
}
CHOptimizedMethod2(self, void, NSTableView, reloadDataForRowIndexes, NSIndexSet *, rowIndexes, columnIndexes, NSIndexSet *, columnIndexes)
{
    CHSuper2(NSTableView, reloadDataForRowIndexes, rowIndexes, columnIndexes, columnIndexes);
}

CHDeclareClass(DTConversationListModel)
CHOptimizedMethod3(self, void, DTConversationListModel, conversationService, id, arg1, conversationDidUpdatedUnreadCountWithId, id, arg2, count, long long, count)
{
    CHSuper3(DTConversationListModel, conversationService, arg1, conversationDidUpdatedUnreadCountWithId, arg2, count, count);
}
CHOptimizedMethod3(self, void, DTConversationListModel, messageService, id, arg1, didUpdatedNewMessagesWithCid, id, arg2, newMessages, id, arg3)
{
    CHSuper3(DTConversationListModel, messageService, arg1, didUpdatedNewMessagesWithCid, arg2, newMessages, arg3);
}


CHDeclareClass(DTChatConversationListController)
CHOptimizedMethod2(self, void, DTChatConversationListController, resetUnreadCountInfo, int, arg1, conversation, id, arg2)
{
    CHSuper2(DTChatConversationListController, resetUnreadCountInfo, arg1, conversation, arg2);
}
CHOptimizedMethod4(self, void, DTChatConversationListController, conversationListModel, id, arg1, didUpdatedConversation, id, arg2, type, long long, type, index, long long, index)
{
    CHSuper4(DTChatConversationListController, conversationListModel, arg1, didUpdatedConversation, arg2, type, type, index, index);
}
CHOptimizedMethod6(self, void, DTChatConversationListController, handleSelectNewCid, id, arg1, mid, long long, arg2, keyword, id, arg3, createdAt, long long, arg4, extensionAction, long long, arg5, extensionInfo, id, arg6)
{
    CHSuper6(DTChatConversationListController, handleSelectNewCid, arg1, mid, arg2, keyword, arg3, createdAt, arg4, extensionAction, arg5, extensionInfo, arg6);
}


CHDeclareClass(DTConversationImp)
CHOptimizedMethod1(self, void, DTConversationImp, setLastMessage, id, arg1)
{
    CHSuper1(DTConversationImp, setLastMessage, arg1);
}


NSString *WordsToPinYin(NSString *words)
{
//    NSMutableString *py = NSMutableString.string;
//    for (int i = 0; i < words.length; i++) {
//        NSMutableString *str = [words substringWithRange:NSMakeRange(i, 1)].mutableCopy;
//        CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
//        CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
//        [py appendString:[str substringToIndex:1]];
//    }
//    return py;
    
    NSMutableString *str = words.mutableCopy;
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    [str replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, str.length)];
    return str;
}

NSString *WordsFirstLetterToPinYin(NSString *words)
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

CGFloat PriorityForFilterConditionAndString(NSString *conditionText, NSString *string)
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


NSMutableDictionary<NSString *, DTEmotionInfo *> *_shortCutMap;

//CHDeclareClass(DTEmotionViewController)
//CHOptimizedMethod0(self, void, DTEmotionViewController, reloadPackageData)
//{
//    CHSuper0(DTEmotionViewController, reloadPackageData);
//
//    if (!_shortCutMap) {
//        NSArray *defaultEmotions = [self valueForKey:@"defaultEmotions"];
//        NSArray *emotions;
//        for (id package in defaultEmotions) {
//            if ([[package valueForKey:@"name"] isEqualToString:@"默认表情"]) {
//                emotions = [package valueForKey:@"emotions"];
//            }
//        }
//        id package = [[NSClassFromString(@"DTEmotionService") valueForKey:@"sharedService"] valueForKey:@"defaultEmotionPackage"];
//        _shortCutMap = NSMutableDictionary.dictionary;
//        for (id emotion in emotions) {
//            NSString *name = [emotion valueForKey:@"name"];
//            NSString *py = WordsToPinYin(name);
//            NSString *key = [NSString stringWithFormat:@"/%@", py];
//            if ([_shortCutMap.allKeys containsObject:key]) {
//                NSLog(@"@@@ %@ %@ %@", key, _shortCutMap[key], name);
//            }
//            _shortCutMap[key] = name;
//        }
//    }
//}

CHDeclareClass(DTChatInputTextView)
CHOptimizedMethod2(self, void, DTChatInputTextView, handleEmojoForSelection, id, arg1, completionHandler, id, arg2)
{
    CHSuper2(DTChatInputTextView, handleEmojoForSelection, arg1, completionHandler, arg2);
    NSLog(@"%d", __LINE__);
}
CHOptimizedMethod2(self, void, DTChatInputTextView, handleEmojoSelectResult, id, arg1, completionHandler, id, arg2)
{
    CHSuper2(DTChatInputTextView, handleEmojoSelectResult, arg1, completionHandler, arg2);
    NSLog(@"%d", __LINE__);
}

CHOptimizedMethod4(self, void, DTChatInputTextView, handleEmotionCell, id, arg1, attrString, id, arg2, locValue, unsigned long long, arg3, endValue, unsigned long long *, arg4)
{
    CHSuper4(DTChatInputTextView, handleEmotionCell, arg1, attrString, arg2, locValue, arg3, endValue, arg4);
    NSLog(@"%d", __LINE__);
}
CHOptimizedMethod1(self, void, DTChatInputTextView, sendOrdinaryMessage, NSAttributedString *, arg1)
{
    NSMutableAttributedString *string = arg1.mutableCopy;
    if ([string.string containsString:@"/wulianku"]) {
        NSRange range = [string.string rangeOfString:@"/wulianku"];
        [string replaceCharactersInRange:range withString:@"[捂脸哭]"];
    }
    CHSuper1(DTChatInputTextView, sendOrdinaryMessage, string);
}

CHOptimizedMethod4(self, void, DTChatInputTextView, sendMessageByType, int, arg1, body, id, arg2, attrString, id, arg3, toConversationModel, id, arg4)
{
    CHSuper4(DTChatInputTextView, sendMessageByType, arg1, body, arg2, attrString, arg3, toConversationModel, arg4);
}

CHOptimizedMethod2(self, void, DTChatInputTextView, insertDefaultEmotion, id, arg1, emotionId, id, arg2)
{
    CHSuper2(DTChatInputTextView, insertDefaultEmotion, arg1, emotionId, arg2);
}

CHOptimizedMethod3(self, void, DTChatInputTextView, insertDefaultEmotion, id, arg1, emotionId, id, arg2, packageId, id, arg3)
{
    CHSuper3(DTChatInputTextView, insertDefaultEmotion, arg1, emotionId, arg2, packageId, arg3);
}

CHOptimizedMethod1(self, void, DTChatInputTextView, mouseDown, id, arg1)
{
    //    CHSuper1(DTChatInputTextView, mouseDown, arg1);
}

CHOptimizedMethod0(self, void, DTChatInputTextView, didChangeText)
{
    NSTextStorage *str = self.textStorage;
    NSArray<NSTextCheckingResult *> *results = [_shortCutRegularExpression matchesInString:str.string options:0 range:NSMakeRange(0, str.length)];

    if (results.count) {
        NSMutableArray *matchStrings = NSMutableArray.new;
        for (NSTextCheckingResult *result in results) {
            [matchStrings addObject:[str.string substringWithRange:result.range]];
        }
        TLog(@"Match %@", [matchStrings componentsJoinedByString:@" "]);
        
        NSRange range = results.firstObject.range;
        NSString *key = [str.string substringWithRange:range];
        NSMutableArray *keys = NSMutableArray.new;
        for (NSString *aKey in _shortCutMap.allKeys) {
            CGFloat priority = PriorityForFilterConditionAndString(key, aKey);
            if (priority == 1) {
                [keys removeAllObjects];
                [keys addObject:aKey];
                break;
            }
            if (priority > 0) {
                [keys addObject:aKey];
            }
        }
        NSLog(@"@@@ %@", keys);
//        DTEmotionInfo *emotion = _shortCutMap[key];
        if (keys.count == 1) {
            DTEmotionInfo *emotion = _shortCutMap[keys.firstObject];
            [str replaceCharactersInRange:range withString:@""];
            [self insertDefaultEmotion:emotion.name emotionId:emotion.emotionId packageId:emotion.packageId];
            return;
        }
    }
    CHSuper0(DTChatInputTextView, didChangeText);
}


CHDeclareClass(DTChatContentController)
CHOptimizedMethod0(self, void, DTChatContentController, closeEmojiPopoverWindow)
{
//    CHSuper0(DTChatContentController, closeEmojiPopoverWindow);
}

CHDeclareClass(NSPopover)
CHOptimizedMethod0(self, void, NSPopover, close)
{
    CHSuper0(NSPopover, close);
}


CHConstructor {
    CHLoadLateClass(DTChatInputTextView);
//    CHHook2(DTChatInputTextView, handleEmojoForSelection, completionHandler);
//    CHHook2(DTChatInputTextView, handleEmojoSelectResult, completionHandler);
//    CHHook4(DTChatInputTextView, handleEmotionCell, attrString, locValue, endValue);
//    CHHook1(DTChatInputTextView, sendOrdinaryMessage);
//    CHHook4(DTChatInputTextView, sendMessageByType, body, attrString, toConversationModel);
//    CHHook1(DTChatInputTextView, mouseDown);
//    CHHook2(DTChatInputTextView, insertDefaultEmotion, emotionId);
//    CHHook3(DTChatInputTextView, insertDefaultEmotion, emotionId, packageId);
    CHHook0(DTChatInputTextView, didChangeText);
    
//    CHLoadLateClass(NSPopover);
//    CHHook0(NSPopover, close);
//    CHLoadLateClass(DTChatContentController);
//    CHHook0(DTChatContentController, closeEmojiPopoverWindow);
    
//    CHLoadLateClass(DTEmotionViewController);
//    CHClassHook0(DTEmotionViewController, reloadPackageData);
    
//    CHLoadLateClass(SUUpdater);
//    CHHook2(SUUpdater, showAlertText, informativeText);
    CHLoadLateClass(SUCodeSigningVerifier);
    CHClassHook1(SUCodeSigningVerifier, bundleAtURLIsCodeSigned);
//    CHLoadLateClass(NSTableView);
//    CHHook0(NSTableView, reloadData);
//    CHHook2(NSTableView, reloadDataForRowIndexes, columnIndexes);

//    CHLoadLateClass(DTConversationListModel);
//    CHHook3(DTConversationListModel, conversationService, conversationDidUpdatedUnreadCountWithId, count);
//    CHHook3(DTConversationListModel, messageService, didUpdatedNewMessagesWithCid, newMessages);

//    CHLoadLateClass(DTChatConversationListController);
//    CHHook2(DTChatConversationListController, resetUnreadCountInfo, conversation);
//    CHHook4(DTChatConversationListController, conversationListModel, didUpdatedConversation, type, index);
//    CHHook6(DTChatConversationListController, handleSelectNewCid, mid, keyword, createdAt, extensionAction, extensionInfo);


//    CHLoadLateClass(DTConversationImp);
//    CHHook1(DTConversationImp, setLastMessage);
    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DTEmotionService *emotionService = [NSClassFromString(@"DTEmotionService") sharedService];
        NSArray *emotions = emotionService.defaultEmotions;
        
        if (emotions) {
            _shortCutMap = NSMutableDictionary.new;
            NSMutableArray *dupKeys = NSMutableArray.new;
            for (DTEmotionInfo *emotion in emotions) {
                NSString *name = emotion.name;
                NSString *py = WordsToPinYin(name);
                NSString *key = [NSString stringWithFormat:@"/%@", py];
                NSString *spy = WordsFirstLetterToPinYin(name);
                NSString *sKey = [NSString stringWithFormat:@"/%@", spy];
                if ([_shortCutMap.allKeys containsObject:key]) {
                    TLog(@"Duplicate key %@ %@ %@", key, _shortCutMap[key].name, name);
                }
                _shortCutMap[key] = emotion;
                if ([_shortCutMap.allKeys containsObject:sKey]) {
                    TLog(@"Duplicate short Key %@ %@ %@", sKey, _shortCutMap[sKey].name, name);
                    _shortCutMap[sKey] = emotion;
                    [dupKeys addObject:sKey];
                } else {
                    _shortCutMap[sKey] = emotion;
                }
            }
            [_shortCutMap removeObjectsForKeys:dupKeys];
            [dupKeys removeAllObjects];
            
            NSArray *allKeys = _shortCutMap.allKeys;
            NSMutableSet *set = NSMutableSet.new;
            for (NSString *key1 in allKeys) {
                for (NSString *key2 in allKeys) {
                    if ([key2 hasPrefix:key1] && ![key2 isEqualToString:key1] && _shortCutMap[key1] != _shortCutMap[key2])
                    {
                        [set addObject:key1];
                        TLog(@"Conflict short key key1 %@ %@ key2 %@ %@", key1, _shortCutMap[key1].name, key2, _shortCutMap[key2].name);
                    }
                }
            }
            
            [_shortCutMap removeObjectsForKeys:set.allObjects];
            TLog(@"Collection completed, %lu emotions", (unsigned long)_shortCutMap.count);
        }
        _shortCutRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"/[a-zA-Z\\d]+" options:0 error:nil];
    });
}
