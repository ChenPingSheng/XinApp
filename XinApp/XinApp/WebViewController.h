//
//  WebViewController.h
//  XinApp
//
//  Created by Kingyee on 15/11/2.
//  Copyright © 2015年 ChenXinApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *urlString;

@end
