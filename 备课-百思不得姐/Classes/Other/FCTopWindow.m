//
//  FCTopWindow.m
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/17.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "FCTopWindow.h"

@implementation FCTopWindow

static UIWindow *window_;

+ (void)initialize
{
    window_ = [[UIWindow alloc] init];
    window_.frame = CGRectMake(0, 0, SCREENWIDTH, 20);
    window_.windowLevel = UIWindowLevelAlert;
    window_.backgroundColor = [UIColor yellowColor];
}

+ (void)show
{
    window_.hidden = NO;
}

@end
