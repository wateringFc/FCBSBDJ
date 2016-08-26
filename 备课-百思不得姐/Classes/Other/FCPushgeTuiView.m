//
//  FCPushgeTuiView.m
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/11.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "FCPushgeTuiView.h"

@implementation FCPushgeTuiView


+ (instancetype)gutuiView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

// 点击“我知道了”删除引导页
- (IBAction)removeView:(id)sender
{
    [self removeFromSuperview];
}

/**
 *  显示消息引导页
 */
+(void)show
{
    // 获取Window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSString *key = @"CFBundleShortVersionString";
    // 获得当前软件版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    // 获得沙盒中存储的版本号
    NSString *sanboxVersion = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    // 判断版本（第一次打开就显示）
    if (![currentVersion isEqualToString:sanboxVersion]) {
        // 创建消息推送引导添加到window上
        FCPushgeTuiView *pushView = [FCPushgeTuiView gutuiView];
        pushView.frame = window.bounds;
        [window addSubview:pushView];
        // 存储版本号
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        // 立即存储
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}



@end
