//
//  MainViewController.h
//  XinApp
//
//  Created by Kingyee on 15/11/2.
//  Copyright © 2015年 ChenXinApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UITabBarController

- (void)performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler;

@end
