//
//  XMGRecommendUserCell.h
//  备课-百思不得姐
//
//  Created by MJ Lee on 15/6/25.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMGRecommendUser;

@interface XMGRecommendUserCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 *  右边Model
 */
@property (strong, nonatomic) XMGRecommendUser *user;
@end
