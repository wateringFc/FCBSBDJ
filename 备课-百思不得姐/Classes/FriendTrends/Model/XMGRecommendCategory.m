//
//  XMGRecommendCategory.m
//  备课-百思不得姐
//
//  Created by MJ Lee on 15/6/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "XMGRecommendCategory.h"

@implementation XMGRecommendCategory
/**
 *  懒加载 users 数组
 */
- (NSMutableArray *)users
{
    if (!_users) {
        self.users = [NSMutableArray array];
    }
    return _users;
}
@end
