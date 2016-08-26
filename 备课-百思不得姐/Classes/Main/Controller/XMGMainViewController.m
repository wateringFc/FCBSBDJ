//
//  XMGMainViewController.m
//  备课-百思不得姐
//
//  Created by MJ Lee on 15/6/15.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "XMGMainViewController.h"
#import "XMGEssenceViewController.h"
#import "XMGNewViewController.h"
#import "XMGFriendTrendsViewController.h"
#import "XMGMeViewController.h"
#import "XMGNavigationViewController.h"
#import "XMGTabBar.h"

@interface XMGMainViewController ()

@end

@implementation XMGMainViewController

// 初始化 对 tabBar 的属性进行统一设置
+ (void)initialize
{
    // 重要知识点：只有系统方法后面有 -> UI_APPEARANCE_SELECTOR   都可以通过 appearance 进行统一设置
    // 如：- (void)setTitleTextAttributes:(nullable NSDictionary<NSString *,id> *)attributes forState:(UIControlState)state NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
    UITabBarItem *appearance = [UITabBarItem appearance];
    
    // 设置名字 选中 的颜色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    [appearance setTitleTextAttributes:attrs forState:UIControlStateSelected];
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 重点知识：替换tabbar（kvc直接访问成员变量）
    [self setValue:[[XMGTabBar alloc] init] forKeyPath:@"tabBar"];
    
    // 初始化所有的子控制器
    [self setupChildViewControllers];
}

/**
 * 初始化所有的子控制器
 */
- (void)setupChildViewControllers
{
    XMGEssenceViewController *essence = [[XMGEssenceViewController alloc] init];
    [self setupOneChildViewController:essence title:@"精华" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
    
    XMGNewViewController *new = [[XMGNewViewController alloc] init];
    [self setupOneChildViewController:new title:@"新帖" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];
    
    XMGFriendTrendsViewController *friends = [[XMGFriendTrendsViewController alloc] init];
    [self setupOneChildViewController:friends title:@"关注" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
    
    XMGMeViewController *me = [[XMGMeViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self setupOneChildViewController:me title:@"我" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
    
    
    // 在tabBar上添加按钮
//    UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [pushButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
//    [pushButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateSelected];
//    pushButton.backgroundColor = [UIColor blackColor];
//    // 设置大小为当前图片大小
//    pushButton.bounds = CGRectMake(0, 0, pushButton.currentBackgroundImage.size.width, pushButton.currentBackgroundImage.size.width);
//    // 设置中点
//    pushButton.center = CGPointMake(self.tabBar.frame.size.width * 0.5, self.tabBar.frame.size.height * 0.5);
//    [self.tabBar addSubview:pushButton];
    
}



/**
 *  初始化子控制器参数
 *
 *  @param vc            控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中图片
 */
- (void)setupOneChildViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    // 给控制器添加 navigtion 
    [self addChildViewController:[[XMGNavigationViewController alloc] initWithRootViewController:vc]];
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
