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

@interface MainViewController ()

@property (nonatomic, strong) NSMutableArray *websites;

@end

@implementation MainViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBar.translucent = NO;
        
        self.websites = [[NSMutableArray alloc] init];
        [self.websites addObjectsFromArray:@[@{@"Title":@"微博",@"URL":@"http://m.weibo.cn"},
                                             @{@"Title":@"贴吧",@"URL":@"http://tieba.baidu.com"},
                                             @{@"Title":@"豆瓣",@"URL":@"http://m.douban.com"},
                                             @{@"Title":@"天涯",@"URL":@"http://m.tianya.cn"},
                                             @{@"Title":@"果壳",@"URL":@"http://m.guokr.com"}]];
        
        NSMutableArray *viewCtrls = [[NSMutableArray alloc] init];
        
        UIImage *image1 = [UIImage imageWithText:@"Z" size:CGSizeMake(24, 24)];
        ZhiHuViewController *zhihuVC = [[ZhiHuViewController alloc] init];
        UINavigationController *navCtrl1 = [[UINavigationController alloc] initWithRootViewController:zhihuVC];
        navCtrl1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"知乎日报" image:image1 selectedImage:nil];
        [viewCtrls addObject:navCtrl1];
        
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
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //无图模式
    CXURLCache *cache = [[CXURLCache alloc] init];
    [NSURLCache setSharedURLCache:cache];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
