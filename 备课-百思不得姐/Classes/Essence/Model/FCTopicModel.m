//
//  FCTopicModel.m
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/12.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "FCTopicModel.h"
#import "NSDate+FCDateExtension.h"
#import "FCComment.h"
#import "FCUser.h"
@implementation FCTopicModel
{
    CGFloat _cellHeigth; // 手动成分成员变量
//    CGRect _pictureViewFram;
}

// get方法
- (NSString *)create_time
{
    // 日期格式类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 帖子创建的时间
    NSDate *createDate = [fmt dateFromString:_create_time];
    
    if (createDate.isThisYear) {// 今年
        if (createDate.isToday) {// 今天
            NSDateComponents *cmps = [[NSDate date] fc_detaFrom:createDate];
            if (cmps.hour >= 1) { // 时间差 >= 1小时
                return [NSString stringWithFormat:@"%zd小时前",cmps.hour];
            }else if (cmps.minute >= 1) { // 1小时 > 时间差 >= 1分钟
                return [NSString stringWithFormat:@"%zd分钟前",cmps.minute];
            }else{ // 时间差 < 1分钟
                return @"刚刚";
            }
        }else if (createDate.isYesterday) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:createDate];
        }else{// 其它时间
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:createDate];
        }
        
    }else{// 非今年
        return _create_time;
    }
}


/**
 *  get方法返回cell的动态高度
 */
- (CGFloat)cellHeigth
{
    // 添加此判读之后不会重复调用计算已经计算过的cell高度
    if (!_cellHeigth) {
        // 文字最大宽度、高度限制
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 4 * FCTopicCellMargin, MAXFLOAT);
        // 计算文字的动态高度
        CGFloat textH = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
        // 文字的高度 （上 -> 头像，文字）
        _cellHeigth = textH + FCTopicCellMargin + FCTopicCellTextY;
        
        // 图片cell高度  （中 -> 图片）
        if (self.type == FCTopicTypePicture) { // 图片帖子 --------------------
            // 图片显示的宽度
            CGFloat pictureW = maxSize.width;
            // 图片显示的高度
            CGFloat pictureH = pictureW * self.height / self.width;
            // 处理图片高度过长时
            if (pictureH >= FCTopicCellPictureMaxH ) {
                pictureH = FCTopicCellPictureBreakH;
                self.bigPicture = YES; // 判定为过长图片；
            }
            // 计算图片nib的frame
            _pictureViewFram = CGRectMake(FCTopicCellMargin, FCTopicCellTextY + textH + FCTopicCellMargin, pictureW, pictureH);
            // cell的高度
            _cellHeigth += pictureH + FCTopicCellMargin;
        
        }else if (self.type == FCTopicTypeVoice) { // 声音帖子----------------
            CGFloat vioceX = FCTopicCellMargin;
            CGFloat vioceY = FCTopicCellTextY + textH + FCTopicCellMargin;
            CGFloat vioceW = maxSize.width;
            CGFloat vioceH = vioceW * self.height / self.width;
            _vioceViewFram = CGRectMake(vioceX, vioceY, vioceW, vioceH);
             _cellHeigth += vioceH + FCTopicCellMargin;
        
        }else if (self.type == FCTopicTypeVideo) { // 视频帖子----------------
            CGFloat videoX = FCTopicCellMargin;
            CGFloat videoY = FCTopicCellTextY + textH + FCTopicCellMargin;
            CGFloat videoW = maxSize.width;
            CGFloat videoH = videoW * self.height / self.width;
            _videoViewFram = CGRectMake(videoX, videoY, videoW, videoH);
            _cellHeigth += videoH + FCTopicCellMargin;
            
        }
        
        // 如果有最热评论
        FCComment *cmt = [self.top_cmt firstObject];
        NSString *content = [NSString stringWithFormat:@"%@: %@",cmt.user.username,cmt.content];
        CGFloat contentH = [content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
        if (cmt) {
            _cellHeigth += FCTopicCellMargin + FCTopicCellTopCmtTitleH + contentH;
        }
        
        
        // 底部工具条的高度 （下 -> 底部4个按钮）
        _cellHeigth += FCTopicCellMargin + FCTopicCellBottomBarH;
    }
    return _cellHeigth;
}


/**
 *  修改模型参数名字(方法一)
 */
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"small_image" : @"image0",
             @"large_image" : @"image1",
             @"middle_image": @"image2",
             @"ID"          : @"id"     };
}
/**
 *  修改模型参数名字(方法二)
 */
//+ (NSString *)replacedKeyFromPropertyName121:(NSString *)propertyName
//{
//    if ([propertyName isEqualToString:@"ID"]) {
//        return @"id";
//    }
//    return propertyName;
//}


+ (NSDictionary *)objectClassInArray
{
//    return @{@"top_cmt" : [FCComment class]};// 方法一：需要引入头文件
    return @{@"top_cmt" : @"FCComment"}; // 方法二：不需要引入头文件
}

@end
