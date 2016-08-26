//
//  XMGRecommendCategory.h
//  备课-百思不得姐
//
//  Created by MJ Lee on 15/6/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  左边tableview Model
 */
@interface XMGRecommendCategory : NSObject
/**
 *  id
 */
@property (copy, nonatomic) NSString *id;
/**
 *  名字
 */
@property (copy, nonatomic) NSString *name;
/**
 *  总数
 */
@property (assign, nonatomic) int count;

/**
 *  这个类别对应的用户数据(解决重复请求，自定义)
 */
@property (strong, nonatomic) NSMutableArray *users;

/**
 *  总数
 */
@property (assign, nonatomic) NSInteger total;

/**
 *  当前页码
 */
@property (assign, nonatomic) NSInteger currentPage;

@end
