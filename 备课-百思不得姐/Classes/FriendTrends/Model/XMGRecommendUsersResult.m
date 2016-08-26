//
//  XMGRecommendUsersResult.m
//  备课-百思不得姐
//
//  Created by MJ Lee on 15/6/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "XMGRecommendUsersResult.h"
#import "XMGRecommendUser.h"

@implementation XMGRecommendUsersResult
+ (NSDictionary *)objectClassInArray
{
    return @{@"list" : [XMGRecommendUser class]};
}
@end
