//
//  TiebaAdminViewController.m
//  XinApp
//
//  Created by Kingyee on 15/10/26.
//  Copyright © 2015年 ChenXinApp. All rights reserved.
//

#import "TiebaAdminViewController.h"
#import "TiebaHeader.h"

@interface TiebaAdminViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation TiebaAdminViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addTiebaAction)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"排序删除" style:UIBarButtonItemStylePlain target:self action:@selector(moveTiebaAction)];
    self.navigationItem.rightBarButtonItems = @[item1, item2];
    
    self.dataArray = [[NSMutableArray alloc] init];
    NSString *filePath = [self tiebaListFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
        [self.dataArray addObjectsFromArray:array];
    }
    else {
        [self.dataArray writeToFile:filePath atomically:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*)tiebaListFilePath
{
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [docDir stringByAppendingPathComponent:TiebaListFile];
    return filePath;
}

- (void)addTiebaAction
{
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"添加贴吧" message:@"请输入贴吧名" preferredStyle:UIAlertControllerStyleAlert];
    [alertCtrl addTextFieldWithConfigurationHandler:nil];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *tiebaName = alertCtrl.textFields[0].text;
        if (tiebaName.length > 0 && [self.dataArray indexOfObject:tiebaName] == NSNotFound) {
            [self.dataArray insertObject:tiebaName atIndex:0];
            [self.dataArray writeToFile:[self tiebaListFilePath] atomically:YES];
            [self.tableView reloadData];
        }
    }];
    [alertCtrl addAction:action1];
    [alertCtrl addAction:action2];
    
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

- (void)moveTiebaAction
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = self.dataArray[indexPath.row];
    
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
        [self.dataArray writeToFile:[self tiebaListFilePath] atomically:YES];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSString *fromTieba = self.dataArray[fromIndexPath.row];
    [self.dataArray removeObjectAtIndex:fromIndexPath.row];
    [self.dataArray insertObject:fromTieba atIndex:toIndexPath.row];
    [self.dataArray writeToFile:[self tiebaListFilePath] atomically:YES];
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
