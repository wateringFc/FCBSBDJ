//
//  FCAddTagViewController.h
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/25.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCAddTagViewController : UIViewController

/** 获取tags的Block */
@property (copy, nonatomic) void (^tagsBlock)(NSArray *tags);

/** 所有的标签 */
@property (strong, nonatomic) NSArray *tags;
@end
