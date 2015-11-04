//
//  SettingViewController.m
//  XinApp
//
//  Created by Kingyee on 15/11/4.
//  Copyright © 2015年 ChenXinApp. All rights reserved.
//

#import "SettingViewController.h"
#import "XinAppDefine.h"

@interface SettingViewController ()

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    
    cell.textLabel.text = @"非WiFi环境下不加载图片";
    cell.accessoryView = self.noImageSwitch;
    
    return cell;
}

@end
