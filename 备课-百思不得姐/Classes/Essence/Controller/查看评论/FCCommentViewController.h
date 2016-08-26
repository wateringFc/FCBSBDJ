//
//  FCCommentViewController.h
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/16.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FCTopicModel;
@interface FCCommentViewController : UIViewController
// 给tableview的header Cell赋值使用
@property (strong, nonatomic) FCTopicModel *topic;
@end
