//
//  XMGFriendTrendsViewController.m
//  备课-百思不得姐
//
//  Created by MJ Lee on 15/6/15.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "XMGFriendTrendsViewController.h"
#import "XMGRecommendViewController.h"
#import "FCLoginRegisterViewController.h"
@interface XMGFriendTrendsViewController ()
@end

@implementation XMGFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = FCGlobalColor;
    
    [self setupNavBar];
}

- (void)setupNavBar
{
    
#warning 小技巧
//    在xib 或者 SB 中，一个label要求显示多行的时候,在换行的地方使用 option + 回车  实现换行
    
    self.navigationItem.title = @"我的关注";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" highImage:@"friendsRecommentIcon-click" target:self action:@selector(following)];
}

- (void)following
{
    XMGRecommendViewController *fr = [[XMGRecommendViewController alloc] init];
    [self.navigationController pushViewController:fr animated:YES];
}

#pragma mark-  登录注册
- (IBAction)loginBut:(id)sender {
    FCLoginRegisterViewController *login = [[FCLoginRegisterViewController alloc] init];
    [self presentViewController:login animated:YES completion:nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
