//
//  XMGTag.h
//  备课-百思不得姐
//
//  Created by MJ Lee on 15/6/28.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  首页leftTabbarItme模型
 */
@interface XMGTag : NSObject
/**
 *  名字
 */
@property (copy, nonatomic) NSString *theme_name;
/**
 *  图片
 */
@property (copy, nonatomic) NSString *image_list;
/**
 *  订阅数
 */
@property (assign, nonatomic) NSInteger sub_number;
@end
