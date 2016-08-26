//
//  UIImage+FCExtension.m
//  watering
//
//  Created by FC on 15/6/15.
//  Copyright © 2015年 watering. All rights reserved.
//

#import "UIImage+FCExtension.h"

@implementation UIImage (FCExtension)

- (UIImage *)circleImage
{
    // 开启图形上下文  NO:代表透明（设置为YES之后四个角会显示黑色）
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    // 获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    // 裁剪
    CGContextClip(ctx);
    // 将图片内容画上去
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return image;
}

@end
