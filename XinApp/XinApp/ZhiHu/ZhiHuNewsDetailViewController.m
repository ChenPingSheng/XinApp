//
//  ZhiHuNewsDetailViewController.m
//  XinApp
//
//  Created by Kingyee on 15/10/26.
//  Copyright © 2015年 ChenXinApp. All rights reserved.
//

#import "ZhiHuNewsDetailViewController.h"
#import "ZhiHuAPI.h"

@interface ZhiHuNewsDetailViewController ()

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSDictionary *newsDetail;

@end

@implementation ZhiHuNewsDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"知乎日报";
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.webView];
    
    [self fetchNewsDetail];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
}

- (void)fetchNewsDetail
{
    [ZhiHuAPI fetchNewsDetail:self.newsID success:^(NSDictionary *newsDetail) {
        self.newsDetail = newsDetail;
        [self loadDetail];
        [self fetchNewsExtra];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
}

- (void)loadDetail
{
    NSArray *cssArray = self.newsDetail[@"css"];
    NSMutableString *cssString = [[NSMutableString alloc] init];
    for (NSString *css in cssArray) {
        [cssString appendFormat:@"<link type=\"text/css\" rel=\"stylesheet\" href=\"%@\">", css];
    }
    NSString *htmlString = [NSString stringWithFormat:@"<html>"
                            "<head>%@</head>"
                            "<body>"
                            "<div>%@</div>"
                            "%@"
                            "</body>"
                            "</html>", cssString, self.newsDetail[@"title"], self.newsDetail[@"body"]];
    
    [self.webView loadHTMLString:htmlString baseURL:nil];
}

- (void)fetchNewsExtra
{
    [ZhiHuAPI fetchNewsExtra:self.newsID success:^(NSDictionary *newsExtra) {
        [self loadExtra:newsExtra];
    } failure:^(NSError *error) {
        
    }];
}

- (void)loadExtra:(NSDictionary *)newsExtra
{
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"点赞(%@)", newsExtra[@"popularity"]] style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"长评(%@)", newsExtra[@"long_comments"]] style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"短评(%@)", newsExtra[@"short_comments"]] style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.items = @[item1, flexItem, item2, flexItem, item3];
}

@end
