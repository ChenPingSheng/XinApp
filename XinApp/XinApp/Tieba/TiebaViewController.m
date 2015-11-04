//
//  TiebaViewController.m
//  XinApp
//
//  Created by Kingyee on 15/10/26.
//  Copyright © 2015年 ChenXinApp. All rights reserved.
//

#import "TiebaViewController.h"
#import "TiebaHeader.h"
#import "TiebaDetailViewController.h"
#import "TiebaAdminViewController.h"
#import "TiebaLoginViewController.h"

@interface TiebaViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation TiebaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"贴吧";
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(loginAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"管理" style:UIBarButtonItemStylePlain target:self action:@selector(adminAction)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginAction
{
    TiebaLoginViewController *vc = [[TiebaLoginViewController alloc] init];
    vc.title = @"登录";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)adminAction
{
    TiebaAdminViewController *vc = [[TiebaAdminViewController alloc] init];
    vc.title = @"管理";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadData
{
    [self.dataArray removeAllObjects];
    
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [docDir stringByAppendingPathComponent:TiebaListFile];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSArray *array = @[@"择天记",@"河北华夏幸福"];
        [array writeToFile:filePath atomically:YES];
        [self.dataArray addObjectsFromArray:array];
    }
    else {
        NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
        [self.dataArray addObjectsFromArray:array];
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TiebaDetailViewController *vc = [[TiebaDetailViewController alloc] init];
    vc.tiebaName = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
