//
//  XMGMeViewController.m
//  备课-百思不得姐
//
//  Created by MJ Lee on 15/6/15.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "XMGMeViewController.h"
#import "FCMeCell.h"
#import "FCMeFooterView.h"
#import "FCSetupViewController.h"

static NSString *const FCMinCellId = @"Min";
@interface XMGMeViewController ()

@end

@implementation XMGMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavBar];

}

- (void)setupNavBar
{
    self.title = @"我的";
    // 设置item
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click" target:self action:@selector(setting)];
    UIBarButtonItem *moonItem = [UIBarButtonItem itemWithImage:@"mine-moon-icon" highImage:@"mine-moon-icon-click" target:self action:@selector(moon)];
    self.navigationItem.rightBarButtonItems = @[settingItem, moonItem];
    // 注册cell（非nib cell）
    [self.tableView registerClass:[FCMeCell class] forCellReuseIdentifier:FCMinCellId];
    self.tableView.backgroundColor = FCGlobalColor;
    // 调整header和footer
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = FCTopicCellMargin;
    // 调整内边距
    self.tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
    // 设置footerView
    self.tableView.tableFooterView = [[FCMeFooterView alloc] init];
}

#pragma mark- 点击事件
- (void)setting
{
    FCSetupViewController *setup = [[FCSetupViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:setup animated:YES];
}
- (void)moon
{

}

#pragma mark- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FCMeCell *cell = [tableView dequeueReusableCellWithIdentifier:FCMinCellId];
    if (indexPath.section == 0 ) {
        cell.imageView.image = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
        cell.textLabel.text = @"登录/注册";
    }else if (indexPath.section == 1) {
        cell.textLabel.text = @"离线下载";
    }
    return cell;
}

@end
