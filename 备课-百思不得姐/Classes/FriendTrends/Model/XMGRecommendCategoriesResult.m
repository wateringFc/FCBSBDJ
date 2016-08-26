//
//  XMGRecommendCategoriesResult.m
//  备课-百思不得姐
//
//  Created by MJ Lee on 15/6/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "XMGRecommendCategoriesResult.h"
#import "XMGRecommendCategory.h"

@implementation XMGRecommendCategoriesResult
+ (NSDictionary *)objectClassInArray
{
    return @{@"list" : [XMGRecommendCategory class]};
}
@end
