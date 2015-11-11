//
//  ZhiHuViewController.h
//  XinApp
//
//  Created by Kingyee on 15/10/23.
//  Copyright © 2015年 ChenXinApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhiHuViewController : UIViewController

- (void)fetchLatestNewsWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler;

@end
