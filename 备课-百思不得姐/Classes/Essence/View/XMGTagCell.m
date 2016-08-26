//
//  XMGTagCell.m
//  备课-百思不得姐
//
//  Created by MJ Lee on 15/6/28.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "XMGTagCell.h"
#import "XMGTag.h"

@interface XMGTagCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation XMGTagCell



- (void)setTagModel:(XMGTag *)tagModel
{
    _tagModel = tagModel;
    
    self.nameLabel.text = tagModel.theme_name;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:tagModel.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.iconView.image = [image circleImage];
    }];
    
    NSString *subNumber = nil;
    if (tagModel.sub_number < 10000) {
        subNumber = [NSString stringWithFormat:@"已有%zd人订阅",tagModel.sub_number];
    }else{
        subNumber = [NSString stringWithFormat:@"已有%.1f万人订阅",tagModel.sub_number/10000.0];
    }
    self.countLabel.text = subNumber;
}


// 重写setFram方法， 修改 self.contentView 的frame来达到 左右下间距（一般用于分割线）
-(void)setFrame:(CGRect)frame
{
    frame.origin.x = 10;
    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 1;
    [super setFrame:frame];
}


@end
