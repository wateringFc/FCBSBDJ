//
//  UIView+XMGExtension.h
//  watering
//
//  Created by FC on 15/6/15.
//  Copyright © 2015年 watering. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  在分类中声明 @property ，只会生成方法的声明，不会生成方法的实现和带有_下划线的成员变量
 */
@interface UIView (XMGExtension)

@property (assign, nonatomic) CGFloat xmg_x;
@property (assign, nonatomic) CGFloat xmg_y;
@property (nonatomic, assign) CGSize  xmg_size;
@property (assign, nonatomic) CGFloat xmg_centerX;
@property (assign, nonatomic) CGFloat xmg_centerY;
@property (assign, nonatomic) CGFloat xmg_width;
@property (assign, nonatomic) CGFloat xmg_height;

/** 判断一个控件是否真正显示在window上 */
- (BOOL)isShowingKeyWindow;

/** 加载Nib */
+ (instancetype)viewFromNib;

@end
