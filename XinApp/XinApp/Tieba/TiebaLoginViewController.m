//
//  TiebaLoginViewController.m
//  XinApp
//
//  Created by Kingyee on 15/11/2.
//  Copyright © 2015年 ChenXinApp. All rights reserved.
//

#import "TiebaLoginViewController.h"
#import "TiebaCookie.h"

@interface TiebaLoginViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURL *theURL;

@end

@implementation TiebaLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];

    NSString *urlString = [[NSString stringWithFormat:@"http://wappass.baidu.com/passport/?login&tn=bdIndex&regtype=1&tpl=tb&u=http://tieba.baidu.com"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    self.theURL = url;
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 登录成功后主要更新3个cookie：
 {name: PTOKEN, value: c6a3627c6e1f26d9421ecee038e40ffb}
 {name: STOKEN, value: 42cd100f2045618ec6d08293cc49770d3ee22fcc7a705d094238121a151bb128}
 {name: BDUSS, value: k53THJGY0ZtdG5tUGFxemRjSGJqWmJCY1VJMEN-d0c5ZnRQcTZzT25NLURabDVXQVFBQUFBJCQAAAAAAAAAAAEAAADFZ-sgt-fUwsqrvsbDzgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIPZNlaD2TZWS}
 */
#pragma mark - webview delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    [TiebaCookie fetchCookieWithURL:self.theURL];
}

@end
