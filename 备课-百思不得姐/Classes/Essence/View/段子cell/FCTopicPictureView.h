//
//  FCTopicPictureView.h
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/14.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FCTopicModel;
/**
 *  图片模块中间内容
 */
@interface FCTopicPictureView : UIView

// 拿到数据模型
@property (strong, nonatomic) FCTopicModel *topic;

+ (instancetype)pictureView;

@end
