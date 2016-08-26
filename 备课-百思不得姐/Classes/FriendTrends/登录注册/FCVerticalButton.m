//
//  FCVerticalButton.m
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/10.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "FCVerticalButton.h"

@implementation FCVerticalButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}


// 通过代码来使用（使用方法见FCLoginRegisterViewController.m）
- (void)setUp
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}


/**
 *  通过XIB来使用（通过XIB使用的话，得设置button的Clas为本类）
 */
- (void)awakeFromNib
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}


/**
 *  重新布局子控件
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整图片
    self.imageView.xmg_x = 0;
    self.imageView.xmg_y = 0;
    self.imageView.xmg_width = self.xmg_width;
    self.imageView.xmg_height = self.imageView.xmg_width;
    
    // 调整文字
    self.titleLabel.xmg_x = 0;
    self.titleLabel.xmg_y = self.imageView.xmg_height;
    self.titleLabel.xmg_width = self.xmg_width;
    self.titleLabel.xmg_height = self.xmg_height - self.titleLabel.xmg_y;
}

@end
