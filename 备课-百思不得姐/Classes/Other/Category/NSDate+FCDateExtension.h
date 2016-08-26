//
//  NSDate+FCDateExtension.h
//  watering
//
//  Created by FC on 15/6/15.
//  Copyright © 2015年 watering. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (FCDateExtension)

/**
 * 比较from和自己时间的差值
 *
 *  @param from 当前时间
 */
- (NSDateComponents *)fc_detaFrom:(NSDate *)from;

/**
 *  是否为今年
 */
- (BOOL)isThisYear;

/**
 *  是否为今天
 */
- (BOOL)isToday;

/**
 *  是否为昨天
 */
- (BOOL)isYesterday;

@end
