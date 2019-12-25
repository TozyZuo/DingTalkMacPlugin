//
//  Created by TozyZuo on 2018/3/29.
//  Copyright © 2018年 TozyZuo. All rights reserved.
//

#import "TZManager.h"

@interface TZConfigManager : TZManager

@property (nonatomic, assign) BOOL shortcutEnable;

- (SEL)selectorForPropertySEL:(SEL)propertySEL;

@end
