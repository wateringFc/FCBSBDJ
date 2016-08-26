//
//  FCTagButton.m
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/26.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "FCTagButton.h"

@implementation FCTagButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


- (void)setup
{
    self.backgroundColor = XMGColor(74, 139, 209);
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
}

// 重写文字内容方法
- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    [self sizeToFit];// 自动计算大小
    self.xmg_width  += 3 * FCTagMargin; // 在计算好的基础上加3个间距
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.xmg_x = FCTagMargin;
    self.imageView.xmg_x = CGRectGetMaxX(self.titleLabel.frame) + FCTagMargin;
}

@end
