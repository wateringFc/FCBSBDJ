//
//  FCTopicVideoView.h
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/16.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FCTopicModel;
@interface FCTopicVideoView : UIView
// 拿到数据模型
@property (strong, nonatomic) FCTopicModel *topic;
+ (instancetype)videoView;
@end
