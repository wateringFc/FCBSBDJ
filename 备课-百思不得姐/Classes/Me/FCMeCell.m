//
//  FCMeCell.m
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/18.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "FCMeCell.h"

@implementation FCMeCell

- (void)awakeFromNib {
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 给cell添加背景图
        UIImageView *bgView = [[UIImageView alloc] init];
        bgView.image = [UIImage imageNamed:@"mainCellBackground"];
        self.backgroundView = bgView;
        
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.textLabel.textColor = [UIColor darkGrayColor];
    }
    return self;
}


// 重新布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.imageView.image == nil) {
        return;
    }
    
    self.imageView.xmg_width = 30;
    self.imageView.xmg_height = self.imageView.xmg_width;
    self.imageView.xmg_centerY = self.contentView.xmg_height /2;
    
    self.textLabel.xmg_x = CGRectGetMaxX(self.imageView.frame) + FCTopicCellMargin;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
