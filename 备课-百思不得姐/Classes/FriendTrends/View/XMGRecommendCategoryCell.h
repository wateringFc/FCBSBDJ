//
//  XMGRecommendCategoryCell.h
//  备课-百思不得姐
//
//  Created by MJ Lee on 15/6/25.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>
// 左边model
@class XMGRecommendCategory;

/**
 *  左边cell
 */
@interface XMGRecommendCategoryCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;


/**
 *  左边model
 */
@property (strong, nonatomic) XMGRecommendCategory *category;
@end
