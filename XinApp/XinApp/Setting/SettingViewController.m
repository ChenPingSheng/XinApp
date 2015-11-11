//
//  SettingViewController.m
//  XinApp
//
//  Created by Kingyee on 15/11/4.
//  Copyright © 2015年 ChenXinApp. All rights reserved.
//

#import "SettingViewController.h"
#import "XinAppDefine.h"
#import "WebsiteListViewController.h"
#import <SafariServices/SafariServices.h>

@interface SettingViewController () <SFSafariViewControllerDelegate>

@property (nonatomic, strong) UISwitch *noImageSwitch;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.noImageSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [self.noImageSwitch addTarget:self action:@selector(valueChangedAction:) forControlEvents:UIControlEventValueChanged];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (![ud objectForKey:CXNoWiFiNoImageKey]) {
        [ud setBool:YES forKey:CXNoWiFiNoImageKey];
        [ud synchronize];
        self.noImageSwitch.on = YES;
    }
    else {
        BOOL noWiFiNoImage = [ud boolForKey:CXNoWiFiNoImageKey];
        self.noImageSwitch.on = noWiFiNoImage;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)valueChangedAction:(UISwitch *)aSwitch {
    
    if (aSwitch == self.noImageSwitch) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setBool:aSwitch.isOn forKey:CXNoWiFiNoImageKey];
        [ud synchronize];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"网站列表";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.section == 1) {
        cell.textLabel.text = @"百度一下";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.section == 2) {
        cell.textLabel.text = @"非WiFi环境下不加载图片";
        cell.accessoryView = self.noImageSwitch;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        WebsiteListViewController *vc = [[WebsiteListViewController alloc] init];
        vc.title = @"网站列表";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 1) {
        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
        safariVC.delegate = self;
//        [self.navigationController presentViewController:safariVC animated:YES completion:nil];
        safariVC.title = @"百度一下";
        [self.navigationController pushViewController:safariVC animated:YES];
    }
}

#pragma mark - SFSafariViewControllerDelegate
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
