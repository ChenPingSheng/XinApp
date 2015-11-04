//
//  ZhiHuThemeDetailViewController.m
//  XinApp
//
//  Created by Kingyee on 15/10/26.
//  Copyright © 2015年 ChenXinApp. All rights reserved.
//

#import "ZhiHuThemeDetailViewController.h"
#import "ZhiHuAPI.h"
#import "ZhiHuNewsDetailViewController.h"

@interface ZhiHuThemeDetailViewController ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ZhiHuThemeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.tableFooterView = [UIView new];
    
    [self fetchThemeDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchThemeDetail
{
    [ZhiHuAPI fetchThemeDetail:self.themeID success:^(NSArray *stories) {
        self.dataArray = stories;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.numberOfLines = 0;
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    
    cell.textLabel.text = dict[@"title"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.dataArray[indexPath.row];
    ZhiHuNewsDetailViewController *vc = [[ZhiHuNewsDetailViewController alloc] init];
    vc.newsID = dict[@"id"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
