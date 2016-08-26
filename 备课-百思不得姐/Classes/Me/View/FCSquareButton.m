//
//  FCSquareButton.m
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/18.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "FCSquareButton.h"
#import "FCSquare.h"
#import <UIButton+WebCache.h>
@implementation FCSquareButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        [self setUp];
    }
    return self;
}


- (void)setUp
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self setBackgroundImage:[UIImage imageNamed:@"mainCellBackground"] forState:UIControlStateNormal];
}


- (void)setSquareModel:(FCSquare *)squareModel
{
    _squareModel = squareModel;
    [self setTitle:squareModel.name forState:UIControlStateNormal];
    [self sd_setImageWithURL:[NSURL URLWithString:squareModel.icon] forState:UIControlStateNormal];
}


/**
 *  重新布局子控件
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整图片
    self.imageView.xmg_y = self.xmg_height * 0.2;
    self.imageView.xmg_width = self.xmg_width * 0.5;
    self.imageView.xmg_height = self.imageView.xmg_width;
    self.imageView.xmg_centerX = self.xmg_width * 0.5;
    
    // 调整文字
    self.titleLabel.xmg_x = 0;
    self.titleLabel.xmg_y = CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.xmg_width = self.xmg_width;
    self.titleLabel.xmg_height = self.xmg_height - self.titleLabel.xmg_y;
}


@end
