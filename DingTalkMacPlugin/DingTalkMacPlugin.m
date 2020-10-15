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
#import "TZEmotionShortcutManager.h"
#import "TZMenuManager.h"
#import "TZConfigManager.h"

static TZEmotionShortcutManager *_manager;

CHDeclareClass(DTChatInputTextView)

CHOptimizedMethod0(self, void, DTChatInputTextView, didChangeText)
{
    if (TZConfigManager.sharedManager.shortcutEnable) {
        NSUInteger maxLocation = self.selectedRange.location;
        
        TZEmotionMatchingResult *result = [_manager matchString:self.textStorage.string range:NSMakeRange(0, maxLocation)].lastObject;
        NSRange range = result.range;
        
        if (NSMaxRange(range) == self.selectedRange.location &&
            result.emotions.count == 1)
        {
            DTEmotionInfo *emotion = result.emotions.firstObject;
            
            [self.textStorage replaceCharactersInRange:range withString:@""];
#if 1
            DTEmotionCell *cell = [NSClassFromString(@"DTEmotionCell") emotionCellWithName:emotion.name emotionId:emotion.emotionId packageId:emotion.packageId];
            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
            textAttachment.attachmentCell = cell;
            NSAttributedString *emotionString = [NSAttributedString attributedStringWithAttachment:textAttachment];
            [self insertAttributedString:emotionString atRange:NSMakeRange(range.location, 0)];
#else
            [self insertDefaultEmotion:emotion.name emotionId:emotion.emotionId packageId:emotion.packageId];
#endif
            return;
        }
    }
    CHSuper0(DTChatInputTextView, didChangeText);
}


CHDeclareClass(AppDelegate)
CHOptimizedMethod1(self, void, AppDelegate, applicationDidFinishLaunching, id, arg1)
{
    CHSuper1(AppDelegate, applicationDidFinishLaunching, arg1);
    
    [TZMenuManager.sharedManager configMenus];
}

static void FetchEmotions()
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DTEmotionService *emotionService = [NSClassFromString(@"DTEmotionService") sharedService];
        NSArray *emotions = emotionService.defaultEmotions;
        
        if (emotions.count) {
            _manager = [[TZEmotionShortcutManager alloc] init];
            _manager.emotions = emotions;
            TZMenuManager.sharedManager.configMenuItem.enabled = YES;
        } else {
            static int times = 0;
            TLog(@"Fetch emotions failed. Retry %d times.", ++times);
            TZMenuManager.sharedManager.configMenuItem.enabled = NO;
            FetchEmotions();
        }
    });
}

CHConstructor {
    CHLoadLateClass(AppDelegate);
    CHHook1(AppDelegate, applicationDidFinishLaunching);
    
    CHLoadLateClass(DTChatInputTextView);
    CHHook0(DTChatInputTextView, didChangeText);

    FetchEmotions();
}
