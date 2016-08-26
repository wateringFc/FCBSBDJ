//
//  FCCommensHeaderView.m
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/17.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "FCCommensHeaderView.h"

@interface FCCommensHeaderView()
/**
 *  文字标签
 */
@property (weak, nonatomic) UILabel *label;

@end

@implementation FCCommensHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = FCGlobalColor;
        // 创建label
        UILabel *label = [[UILabel alloc] init];
        label.textColor = XMGColor(67, 67, 67);
        label.xmg_x = FCTopicCellMargin;
        label.xmg_width = 200;
        // 跟随父控件拉伸
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        label.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:label];
        self.label = label;
    }
    return self;
}


- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    self.label.text = title;
}



@end
