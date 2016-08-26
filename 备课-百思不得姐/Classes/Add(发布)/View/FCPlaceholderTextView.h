//
//  FCPlaceholderTextView.h
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/24.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCPlaceholderTextView : UITextView
/** 占位文字 */
@property (copy, nonatomic) NSString *placeholderText;
/** 占位文字颜色 */
@property (strong, nonatomic) UIColor *placeholderTextColor;

@end
