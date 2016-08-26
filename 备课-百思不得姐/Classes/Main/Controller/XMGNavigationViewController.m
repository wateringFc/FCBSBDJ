//
//  XMGNavigationViewController.m
//  备课-百思不得姐
//
//  Created by MJ Lee on 15/6/15.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "XMGNavigationViewController.h"

@interface XMGNavigationViewController ()

@end

@implementation XMGNavigationViewController

/**
 *  当第一次使用这个类的时候会调用一次
 */
+ (void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearance];
    UIImage *bg = [UIImage imageNamed:@"navigationbarBackgroundWhite"];
    [bar setBackgroundImage:bg forBarMetrics:UIBarMetricsDefault];
    [bar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:20]}];
    
    // 统一设置左右itme属性
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    // Normal
    NSMutableDictionary *itmeAtts = [NSMutableDictionary dictionary];
    itmeAtts[NSForegroundColorAttributeName] = [UIColor blackColor];
    itmeAtts[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [item setTitleTextAttributes:itmeAtts forState:UIControlStateNormal];
    // Disabled
    NSMutableDictionary *itmeDisabledAtts = [NSMutableDictionary dictionary];
    itmeDisabledAtts[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    itmeDisabledAtts[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [item setTitleTextAttributes:itmeDisabledAtts forState:UIControlStateDisabled];
    
    
}


/**
 *  系统 拦截控制器push方法
 *
 *  @param viewController 控制器
 *  @param animated       动画
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count) {// 如果 push进来的不是第一个控制器
        viewController.hidesBottomBarWhenPushed = YES;
        
        UIButton *button = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        // 设置位置：
        // 方法一：1.设置长宽，2.偏移
        button.bounds = CGRectMake(0, 0, 70, 30);
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        // 方法二：1.设置长宽  2.按钮整体内容向哪个方向对齐
//        button.bounds = CGRectMake(0, 0, 70, 30);
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        // 方法三：包裹内容
//        [button sizeToFit];
        
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
    // 此方法放在下面 在其他 控制器可以再定义左上角按钮，
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

@end
