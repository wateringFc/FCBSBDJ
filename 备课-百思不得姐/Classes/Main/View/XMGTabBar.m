//
//  XMGTabBar.m
//  备课-百思不得姐
//
//  Created by MJ Lee on 15/6/15.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "XMGTabBar.h"
#import "FCPublishViewController.h"
#import "FCWordViewController.h"
#import "XMGNavigationViewController.h"
@interface XMGTabBar()
@end

@implementation XMGTabBar


- (nonnull instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // 添加中间 加号按钮
        UIButton *publishButton = [[UIButton alloc] init];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [self addSubview:publishButton];
        [publishButton makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.equalTo([publishButton backgroundImageForState:UIControlStateNormal].size);
        }];
        [publishButton addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark- 跳转发布
- (void)publishClick
{
//    FCPublishViewController *publish = [[FCPublishViewController alloc] init];
//    // 拿到跟控制器modal
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:publish animated:NO completion:nil
//     ];
    
    
    FCWordViewController *word = [[FCWordViewController alloc] init];
    XMGNavigationViewController *nav = [[XMGNavigationViewController alloc] initWithRootViewController:word];
    // 这里不能用self来弹出其它控制器，因为self执行了dismiss操作
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [root presentViewController:nav animated:YES completion:nil];
    
}

/**
 *  布局子控件（等tabBar布局完成之后，本类再重新对子控件布局，从而达到效果）
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 原来的4个
    CGFloat width = self.xmg_width / 5;
    int index = 0;
    for (UIControl *control in self.subviews) {
        // 控制自定义按钮的位置（判断是排除中间加号按钮 因为自定义button 继承自 UIControl）
        if (![control isKindOfClass:[UIControl class]] || [control isKindOfClass:[UIButton class]]) continue;
        control.xmg_width = width;
        control.xmg_x = index > 1 ? width * (index + 1) : width * index;
        index++;
    }
    
}





@end
