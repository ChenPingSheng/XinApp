//
//  MainViewController.m
//  XinApp
//
//  Created by Kingyee on 15/11/2.
//  Copyright © 2015年 ChenXinApp. All rights reserved.
//

#import "MainViewController.h"
#import "ZhiHuViewController.h"
//#import "TiebaViewController.h"
#import "WebViewController.h"
#import "UIImage+Text.h"
#import "CXURLCache.h"
#import "NSString+Pinyin.h"
#import "SettingViewController.h"
#import "XinAppDefine.h"
#import "CXWebsiteManager.h"
#import "CXShortcutManager.h"

@interface MainViewController ()

@property (nonatomic, strong) NSMutableArray *websites;

@end

@implementation MainViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBar.translucent = NO;
        
        
        self.websites = [CXWebsiteManager sharedWebsites];
        
        [self loadViewControllers];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(websiteListDidChange) name:CXWebsiteListDidChangedNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //为了在非WiFi环境下停止加载图片，替换默认的URLCache
    CXURLCache *cache = [[CXURLCache alloc] init];
    [NSURLCache setSharedURLCache:cache];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadViewControllers {
    
    NSMutableArray *viewCtrls = [[NSMutableArray alloc] init];
    
    UIImage *image1 = [UIImage imageWithText:@"Z" size:CGSizeMake(24, 24)];
    ZhiHuViewController *zhihuVC = [[ZhiHuViewController alloc] init];
    UINavigationController *navCtrl1 = [[UINavigationController alloc] initWithRootViewController:zhihuVC];
    navCtrl1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"知乎日报" image:image1 selectedImage:nil];
    [viewCtrls addObject:navCtrl1];
    
    zhihuVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(showSetting)];
    
//        UIImage *image2 = [UIImage imageWithText:@"T" size:CGSizeMake(24, 24)];
//        TiebaViewController *tiebaVC = [[TiebaViewController alloc] init];
//        UINavigationController *navCtrl2 = [[UINavigationController alloc] initWithRootViewController:tiebaVC];
//        navCtrl2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"贴吧" image:image2 selectedImage:nil];
//        [viewCtrls addObject:navCtrl2];
    
    for (NSDictionary *dict in self.websites) {
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.title = dict[@"Title"];
        webVC.urlString = dict[@"URL"];
        UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:webVC];
        navCtrl.tabBarItem = [[UITabBarItem alloc] initWithTitle:dict[@"Title"] image:[UIImage imageWithText:[dict[@"Title"] firstLetterOfPinyin] size:CGSizeMake(24, 24)] selectedImage:nil];
        [viewCtrls addObject:navCtrl];
    }
    
    self.viewControllers = viewCtrls;
    [CXShortcutManager updateShortcuts];
}

- (void)reloadViewControllers {
    NSMutableArray *viewCtrls = [[NSMutableArray alloc] init];
    
    //知乎日报固定不动
    [viewCtrls addObject:self.viewControllers[0]];
    
    for (NSDictionary *dict in self.websites) {
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.title = dict[@"Title"];
        webVC.urlString = dict[@"URL"];
        UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:webVC];
        navCtrl.tabBarItem = [[UITabBarItem alloc] initWithTitle:dict[@"Title"] image:[UIImage imageWithText:[dict[@"Title"] firstLetterOfPinyin] size:CGSizeMake(24, 24)] selectedImage:nil];
        [viewCtrls addObject:navCtrl];
    }
    
    self.viewControllers = viewCtrls;
    [CXShortcutManager updateShortcuts];
}

- (void)websiteListDidChange {
    
    self.websites = [CXWebsiteManager sharedWebsites];
    
    [self reloadViewControllers];
}

- (void)showSetting {
    SettingViewController *vc = [[SettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.title = @"设置";
//    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(dismissViewCtrl)];
//    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self presentViewController:navCtrl animated:YES completion:nil];
    UINavigationController *navCtrl1 = self.viewControllers[0];
    [navCtrl1 pushViewController:vc animated:YES];
}

//- (void)dismissViewCtrl {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

#pragma mark - background fetch
- (void)performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    UIViewController *viewCtrl = [(UINavigationController*)self.viewControllers[0] topViewController];
    if ([viewCtrl isKindOfClass:[ZhiHuViewController class]]) {
        [(ZhiHuViewController*)viewCtrl fetchLatestNewsWithCompletionHandler:completionHandler];
    }
}

@end
