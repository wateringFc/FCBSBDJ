//
//  FCParentClassViewController.h
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/14.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef enum : NSUInteger {
//    FCTopicTypeAll = 1,
//    FCTopicTypePicture = 10,
//    FCTopicTypeWord = 29,
//    FCTopicTypeVoice = 31,
//    FCTopicTypeVideo = 41
//} FCTopicType;

@interface FCParentClassViewController : UITableViewController
@property (assign, nonatomic) FCTopicType type;

@end
