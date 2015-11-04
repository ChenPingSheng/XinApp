//
//  ZhiHuThemesViewController.m
//  XinApp
//
//  Created by Kingyee on 15/10/26.
//  Copyright © 2015年 ChenXinApp. All rights reserved.
//

#import "ZhiHuThemesViewController.h"
#import "ZhiHuAPI.h"
#import "ZhiHuThemeDetailViewController.h"

@interface ZhiHuThemesViewController ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ZhiHuThemesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.tableFooterView = [UIView new];
    
    [self fetchThemes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchThemes
{
    [ZhiHuAPI fetchThemesWithSuccess:^(NSArray *themes) {
        self.dataArray = themes;
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
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    
    cell.textLabel.text = dict[@"name"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.dataArray[indexPath.row];
    ZhiHuThemeDetailViewController *vc = [[ZhiHuThemeDetailViewController alloc] init];
    vc.themeID = dict[@"id"];
    vc.title = dict[@"name"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
