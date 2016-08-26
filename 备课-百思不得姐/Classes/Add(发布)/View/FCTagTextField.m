//
//  FCTagTextField.m
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/26.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "FCTagTextField.h"

@implementation FCTagTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}


// 监听TextField删除文字事件
- (void)deleteBackward
{
    // 一旦有值，就调用Block（意思就是一旦点了删除就调用Block）
    !self.deleteBlock ? : self.deleteBlock();
    
    
    [super deleteBackward];
    
}

@end
