//
//  XMGTopicCell.h
//  备课-百思不得姐
//
//  Created by MJ Lee on 15/6/18.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FCTopicModel;

@interface XMGTopicCell : UITableViewCell

/**
 *  方便其他地方调用cell
 */
+ (instancetype)showCell;

@property (strong, nonatomic) FCTopicModel *topic;

@end
