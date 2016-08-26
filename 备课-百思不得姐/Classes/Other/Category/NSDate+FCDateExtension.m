//
//  NSDate+FCDateExtension.m
//  watering
//
//  Created by FC on 15/6/15.
//  Copyright © 2015年 watering. All rights reserved.
//

#import "NSDate+FCDateExtension.h"

@implementation NSDate (FCDateExtension)
- (NSDateComponents *)fc_detaFrom:(NSDate *)from
{
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // self 指当前时间
    return [calendar components:unit fromDate:from toDate:self options:0];
}


/**
 *  是否为今年
 */
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    return nowYear == selfYear;
}

/**
 *  是否为今天(方法一)
 */
//- (BOOL)isToday
//{
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
//    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
//    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
//    return nowCmps.year == selfCmps.year && nowCmps.month == selfCmps.month && nowCmps.day == selfCmps.day;
//}


/**
 *  是否为今天(方法二)
 */
- (BOOL)isToday
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSString *selfString = [fmt stringFromDate:self];
    return [nowString isEqualToString:selfString];
}


/**
 *  是否为昨天
 */
- (BOOL)isYesterday
{
    // 2015-12-31 23:59:59 -> 2015-12-31
    // 2016-01-01 00:00:01 -> 2016-01-01
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *nowDate = [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    NSDate *selfDate = [fmt dateFromString:[fmt stringFromDate:self]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:selfDate toDate:nowDate options:0];
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}





//    // 通过日历分别获取当前的年月日
//    NSInteger year =  [calendar component:NSCalendarUnitYear fromDate:nowDate];
//    NSInteger month = [calendar component:NSCalendarUnitMonth fromDate:nowDate];
//    NSInteger day =   [calendar component:NSCalendarUnitDay fromDate:nowDate];
//    // 通过日历一次性获取当前的年月日
//    NSDateComponents *comps=  [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:nowDate];


@end
