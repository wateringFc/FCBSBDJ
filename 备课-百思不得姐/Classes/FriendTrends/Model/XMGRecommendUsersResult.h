//
//  XMGRecommendUsersResult.h
//  备课-百思不得姐
//
//  Created by MJ Lee on 15/6/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGRecommendUsersResult : NSObject
@property (assign, nonatomic) int total;
@property (assign, nonatomic) int next_page;
@property (assign, nonatomic) int total_page;
@property (strong, nonatomic) NSArray *list;
@end
