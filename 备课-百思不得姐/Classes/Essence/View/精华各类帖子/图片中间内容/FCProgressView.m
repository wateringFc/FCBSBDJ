//
//  FCProgressView.m
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/15.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "FCProgressView.h"

@implementation FCProgressView


- (void)awakeFromNib
{
     // 设置进度条属性
    self.secondaryColor = [UIColor lightGrayColor];
    self.primaryColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
}

@end
