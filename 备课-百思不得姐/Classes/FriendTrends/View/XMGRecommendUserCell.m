//
//  XMGRecommendUserCell.m
//  备课-百思不得姐
//
//  Created by MJ Lee on 15/6/25.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "XMGRecommendUserCell.h"
#import "XMGRecommendUser.h"

@interface XMGRecommendUserCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@end

@implementation XMGRecommendUserCell

// 此方法省去 控制器 if(!cell){.......}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"user";
    XMGRecommendUserCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}


- (void)setUser:(XMGRecommendUser *)user
{
    _user = user;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.header] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.iconView.image = [image circleImage];
    }];
    self.nameLabel.text = user.screen_name;
    NSString *subNumber = nil;
    if (user.fans_count < 10000) {
        subNumber = [NSString stringWithFormat:@"%zd人关注",user.fans_count];
    }else{
        subNumber = [NSString stringWithFormat:@"%.1f万人关注",user.fans_count/10000.0];
    }
    self.followersLabel.text = subNumber;
}
@end
