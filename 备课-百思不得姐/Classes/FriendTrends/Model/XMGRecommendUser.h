//
//  XMGRecommendUser.h
//  备课-百思不得姐
//
//  Created by MJ Lee on 15/6/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  右边Model
 */
@interface XMGRecommendUser : NSObject

/**
 *  昵称
 */
@property (copy, nonatomic) NSString *screen_name;

/**
 *  头像
 */
@property (copy, nonatomic) NSString *header;

/**
 *  粉丝数
 */
@property (assign, nonatomic) int fans_count;
@end
