//
//  TZEmotionShortCutManager.h
//  DingTalkMacPlugin
//
//  Created by TozyZuo on 2019/12/24.
//  Copyright © 2019 TozyZuo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TZEmotion <NSObject>
@property (readonly) NSString *name;
@end

@interface TZEmotionMatchingResult : NSObject
@property (readonly) NSRange range;
@property (readonly) id<TZEmotion> emotion;
@end

@interface TZEmotionShortcutManager : NSObject
@property (nonatomic, strong) NSArray<id<TZEmotion>> *emotions;
- (nullable TZEmotionMatchingResult *)matchString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
