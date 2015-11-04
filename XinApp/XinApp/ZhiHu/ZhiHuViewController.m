//
//  ZhiHuViewController.m
//  XinApp
//
//  Created by Kingyee on 15/10/23.
//  Copyright © 2015年 ChenXinApp. All rights reserved.
//

#import "ZhiHuViewController.h"
#import "ZhiHuAPI.h"
#import "ZhiHuNewsDetailViewController.h"
#import "ZhiHuThemesViewController.h"
#import <MJRefresh.h>

@interface ZhiHuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *latestArray;
@property (nonatomic, strong) NSMutableArray *beforeArray;
@property (nonatomic, strong) NSString *beforeDate;
@property (nonatomic, strong) NSString *latestDate;

@end

@implementation ZhiHuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"知乎日报";
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"主题" style:UIBarButtonItemStylePlain target:self action:@selector(showThemes)];
    
    self.beforeArray = [[NSMutableArray alloc] init];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fetchBeforeNews];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.latestDate) {
        [self fetchLatestNews];
    }
}

- (void)showThemes
{
    ZhiHuThemesViewController *vc = [[ZhiHuThemesViewController alloc] init];
    vc.title = @"主题";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)fetchLatestNews
{
    [ZhiHuAPI latestNewsWithSuccess:^(NSString *date, NSArray *stories, NSArray *topStories) {
        [SVProgressHUD dismiss];
        self.latestArray = stories;
        self.latestDate = date;
        self.beforeDate = date;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
    [SVProgressHUD show];
}

#define OneDay 24 * 60 * 60
- (void)setBeforeDateWithDate:(NSString*)date
{
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    dateFmt.dateFormat = @"yyyyMMdd";
    NSDate *beforeDate = [[dateFmt dateFromString:date] dateByAddingTimeInterval:-OneDay];
    _beforeDate = [dateFmt stringFromDate:beforeDate];
}

- (void)fetchBeforeNews
{
    if (!self.beforeDate) {
        return;
    }
    [ZhiHuAPI beforeNewsWithDate:self.beforeDate success:^(NSString *date, NSArray *stories) {
        [self setBeforeDateWithDate:date];
        [self.beforeArray addObjectsFromArray:stories];
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
}

#pragma mark - tableview datasource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.latestArray.count;
    }
    else {
        return self.beforeArray.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.numberOfLines = 0;
    
    NSDictionary *dict = nil;
    if (indexPath.section == 0) {
        dict = self.latestArray[indexPath.row];
    }
    else {
        dict = self.beforeArray[indexPath.row];
    }
    NSString *title = dict[@"title"];
    if ([dict[@"multipic"] intValue] == 1) {
        title = [title stringByAppendingString:@"(多图)"];
    }
    
    cell.textLabel.text = title;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = nil;
    if (indexPath.section == 0) {
        dict = self.latestArray[indexPath.row];
    }
    else {
        dict = self.beforeArray[indexPath.row];
    }
    
    ZhiHuNewsDetailViewController *vc = [[ZhiHuNewsDetailViewController alloc] init];
    vc.newsID = dict[@"id"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
