//
//  UIBarButtonItem+XMGExtension.h
//  watering
//
//  Created by FC on 15/6/15.
//  Copyright © 2015年 watering. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (XMGExtension)

/**
 *  添加UIBarButtonItem左右按钮
 *
 *  @param image     图片
 *  @param highImage 高亮图片
 *  @param target    目标
 *  @param action    点击事件
 */
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;
@end
