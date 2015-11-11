//
//  CXShortcutManager.m
//  XinApp
//
//  Created by Kingyee on 15/11/11.
//  Copyright © 2015年 ChenXinApp. All rights reserved.
//

#import "CXShortcutManager.h"
#import <UIKit/UIKit.h>
#import "CXWebsiteManager.h"

@implementation CXShortcutManager

+ (void)updateShortcuts {
    UIApplication *app = [UIApplication sharedApplication];
    
    NSArray *array = [CXWebsiteManager sharedWebsites];
    NSInteger count = array.count;
    if (count > 3) {
        count = 3;
    }
    
    NSMutableArray *shortcuts = [NSMutableArray array];
    
    //知乎日报
    UIMutableApplicationShortcutItem *shortcut = [[UIMutableApplicationShortcutItem alloc] initWithType:[NSString stringWithFormat:@"%d", 0] localizedTitle:@"知乎日报" localizedSubtitle:@"" icon:nil userInfo:nil];
    [shortcuts addObject:shortcut];
    
    for (int i = 0; i < count; i++) {
        NSDictionary *dict = array[i];
        UIMutableApplicationShortcutItem *shortcut = [[UIMutableApplicationShortcutItem alloc] initWithType:[NSString stringWithFormat:@"%d", i+1] localizedTitle:dict[@"Title"] localizedSubtitle:@"" icon:nil userInfo:nil];
        [shortcuts addObject:shortcut];
    }
    app.shortcutItems = shortcuts;
}

@end
