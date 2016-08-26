//
//  FCPublishViewController.m
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/15.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "FCPublishViewController.h"
#import "FCWordViewController.h"
#import "XMGNavigationViewController.h"
@interface FCPublishViewController ()

@end

@implementation FCPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, SCREENWIDTH, 20)];
    la.textAlignment = NSTextAlignmentCenter;
    la.text = @"发布页面，懒得写了";
    [self.view addSubview:la];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.xmg_y = CGRectGetMaxY(la.frame) + 30;
    button.xmg_width = 100;
    button.xmg_x = 150;
    button.xmg_height = 30;
    [button setTitle:@"发段子" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(topicClick) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
    
}

- (void)topicClick
{
    FCWordViewController *word = [[FCWordViewController alloc] init];
    XMGNavigationViewController *nav = [[XMGNavigationViewController alloc] initWithRootViewController:word];
    [self presentViewController:nav animated:YES completion:nil];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
