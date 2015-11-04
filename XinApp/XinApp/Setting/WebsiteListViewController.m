//
//  WebsiteListViewController.m
//  XinApp
//
//  Created by Kingyee on 15/11/4.
//  Copyright © 2015年 ChenXinApp. All rights reserved.
//

#import "WebsiteListViewController.h"
#import "XinAppDefine.h"
#import "UIImage+Text.h"
#import "NSString+Pinyin.h"
#import "CXWebsiteManager.h"

@interface WebsiteListViewController ()
{
    BOOL isChanged;
}

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation WebsiteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableFooterView = [UIView new];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addAction)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"排序删除" style:UIBarButtonItemStylePlain target:self action:@selector(moveAction)];
    self.navigationItem.rightBarButtonItems = @[item1, item2];
    
    self.dataArray = [CXWebsiteManager sharedWebsites];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (isChanged) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CXWebsiteListDidChangedNotification object:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addAction
{
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"添加网站" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertCtrl addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入网站标题";
    }];
    [alertCtrl addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入网站链接";
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *title = alertCtrl.textFields[0].text;
        NSString *url = alertCtrl.textFields[1].text;
        if (title.length > 0 && url.length > 0 &&
            ![CXWebsiteManager websiteExistsWithTitle:title url:url]) {
            [self.dataArray addObject:@{@"Title":title, @"URL":url}];
            [CXWebsiteManager addWebsiteWithTitle:title url:url fromExt:NO];
            [self.tableView reloadData];
            isChanged = YES;
        }
    }];
    [alertCtrl addAction:action1];
    [alertCtrl addAction:action2];
    
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

- (void)moveAction
{
    BOOL editing = self.tableView.editing;
    self.tableView.editing = !editing;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    // Configure the cell...
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.textLabel.text = dict[@"Title"];
    cell.detailTextLabel.text = dict[@"URL"];
    cell.imageView.image = [UIImage imageWithText:[dict[@"Title"] firstLetterOfPinyin] size:CGSizeMake(40, 40)];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [CXWebsiteManager saveWebsites:self.dataArray];
        isChanged = YES;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    id fromObject = self.dataArray[fromIndexPath.row];
    [self.dataArray removeObjectAtIndex:fromIndexPath.row];
    [self.dataArray insertObject:fromObject atIndex:toIndexPath.row];
    [CXWebsiteManager saveWebsites:self.dataArray];
    isChanged = YES;
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

@end
