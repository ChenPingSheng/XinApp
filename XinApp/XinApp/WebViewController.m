//
//  WebViewController.m
//  XinApp
//
//  Created by Kingyee on 15/11/2.
//  Copyright © 2015年 ChenXinApp. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIScrollViewDelegate>
{
    CGPoint originContentOffset;
}

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    self.webView.scrollView.delegate = self;
    
//    [self createToolbarItems];
    
    NSURL *url = [NSURL URLWithString:self.urlString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)viewDidLayoutSubviews
{
    originContentOffset = self.webView.scrollView.contentOffset;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createToolbarItems
{
    if (!self.navigationController.toolbarHidden) {
        UIBarButtonItem *item1 = self.navigationController.toolbar.items[1];
        UIBarButtonItem *item2 = self.navigationController.toolbar.items[3];
        item1.enabled = [self.webView canGoBack];
        item2.enabled = [self.webView canGoForward];
        
        return;
    }
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedItem.width = 20;
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow-left"] style:UIBarButtonItemStylePlain target:self.webView action:@selector(goBack)];
    item1.enabled = [self.webView canGoBack];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow-right"] style:UIBarButtonItemStylePlain target:self.webView action:@selector(goForward)];
    item2.enabled = [self.webView canGoForward];
    
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow-up"] style:UIBarButtonItemStylePlain target:self action:@selector(goTopAction)];
    item3.enabled = NO;
    
    UIBarButtonItem *item4 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self.webView action:@selector(reload)];
    
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.items = @[fixedItem, item1, flexItem, item2, flexItem, item3, flexItem, item4, fixedItem];
}

- (void)setGoTopEnable:(BOOL)enabled {
    if (self.navigationController.toolbar.items.count != 9) {
        return;
    }
    UIBarButtonItem *item = self.navigationController.toolbar.items[5];
    item.enabled = enabled;
}

#pragma mark - Actions

- (void)goTopAction {
    self.webView.scrollView.contentOffset = originContentOffset;
}

#pragma mark - webview delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self createToolbarItems];
}

#pragma mark - scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint contentOffset = scrollView.contentOffset;
    if (contentOffset.y > originContentOffset.y) {
        [self setGoTopEnable:YES];
    }
    else {
        [self setGoTopEnable:NO];
    }
}

@end