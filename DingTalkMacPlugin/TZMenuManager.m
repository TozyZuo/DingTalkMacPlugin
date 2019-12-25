//
//  Created by TozyZuo on 2018/9/11.
//  Copyright © 2018年 TozyZuo. All rights reserved.
//

#import "TZMenuManager.h"
#import "TZConfigManager.h"
#import <objc/runtime.h>

@interface TZMenuManager ()
<NSApplicationDelegate>
//@property (nonatomic, strong) NSMenuItem *shortcutItem;
@end

@implementation TZMenuManager

- (void)configMenus
{
    NSMenu *mainMenu = NSApp.mainMenu;
    
    TZConfigManager *config = TZConfigManager.sharedManager;
    
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"表情快捷输入" action:[config selectorForPropertySEL:@selector(shortcutEnable)] keyEquivalent:@""];
    item.target = config;
    item.state = config.shortcutEnable;

    NSMenu *newMenu = [[NSMenu alloc] initWithTitle:@"插件设置"];
    [newMenu addItem:item];
    NSMenuItem *newItem = [[NSMenuItem alloc] init];
    newItem.title = @"插件设置";
    newItem.submenu = newMenu;
    
    [mainMenu addItem:newItem];
}

@end
