//
//  FCTextField.m
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/11.
//  Copyright © 2016年 FC. All rights reserved.
//

#import "FCTextField.h"
#import <objc/runtime.h>
static NSString *const GetTextFieldVar = @"_placeholderLabel.textColor";
@implementation FCTextField


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

//// 重写系统方法更改等待文字属性(方法二，方法一见FCLoginRegisterViewController.m 中 changeTextColor方法)
//-(void)drawPlaceholderInRect:(CGRect)rect
//{
//    // rect 可以改变等待文字的位置
//    [self.placeholder drawInRect:CGRectMake(0, 10, rect.size.width, 25)
//                  withAttributes:@{
//                                   NSForegroundColorAttributeName:[UIColor grayColor],
//                                   NSFontAttributeName:self.font
//                                  }];
//}



//______________________扩展 tuntime ——————————————————————————

/**
 *  runtime(运行时)
    官方C语言库
    能做很多底层操作(比如访问隐藏的一些成员变量/成员方法)
 */

+ (void)initialize
{
//    [self getIvar];
//    [self getProperty];
}


// 查看所有属性（一般用处不大，写框架会涉及到）
+ (void)getProperty
{
    
    unsigned int count = 0;
    objc_property_t *prperties = class_copyPropertyList([UITextField class], &count);
    // 获取属性
    for (int i = 0; i < count; i++) {
        objc_property_t  prperty = prperties[i];
        NSLog(@" 打印所有属性 %s <----> 属性类型%s", property_getName(prperty),property_getAttributes(prperty));
    }
    // 释放内存
    free(prperties);
}

// 查看 类中隐藏 成员变量
+ (void)getIvar
{
    unsigned int count = 0;
    // class_copyIvarList:拷贝类中所有成员变量列表（拷贝列表，此内存需要程序员负责）
    // 参数一：类名 参数二：取地址
    Ivar *ivars = class_copyIvarList([UITextField class], &count);
    
    // 访问所有成员变量
    for (int i = 0; i < count; i++) {
        Ivar ivar = *(ivars + i); // 等价于 Ivar ivar = ivars[i];
        NSLog(@"打印所有成员变量 %s",ivar_getName(ivar));
    }
    // 释放内存
    free(ivars);
}
//______________________扩展 tuntime ——————————————————————————




/**
 *  nib创建后的操作
 */
-(void)awakeFromNib
{
    // 拿到 UITextField 隐藏的成员变量 _placeholderLabel 进行修改
    // 方法1
//    UILabel *placeholderLaber = [self valueForKey:@"_placeholderLabel"];
//    placeholderLaber.textColor = [UIColor grayColor];
    
    // 方法2
//    [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    // 修改光标颜色与文字颜色一致
    self.tintColor = self.textColor;
    
    // 不成为第一响应者
    [self resignFirstResponder];
}


/**
 *  重写系统 成为第一响应者 方法  （当前文本框 被 选中时候调用）
 */
- (BOOL)becomeFirstResponder
{
    // 与文字颜色保持一致
    [self setValue:self.textColor forKeyPath:GetTextFieldVar];
    // 因此项目不需要，暂时关闭
//    self.layer.borderColor = self.textColor.CGColor;
//    self.layer.borderWidth = 1.0;
    return [super becomeFirstResponder];
}


/**
 *  重写系统 取消第一响应者 方法 （当前文本框 未被 选中时候调用）
 */
- (BOOL)resignFirstResponder
{
    [self setValue:[UIColor grayColor] forKeyPath:GetTextFieldVar];
    // 因此项目不需要，暂时关闭
//    self.layer.borderColor = [UIColor grayColor].CGColor;
//    self.layer.borderWidth = 1.0;
    return [super resignFirstResponder];
}


/**
 *  给外界提供修改文字颜色的接口
 */
- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor
{
    _placeholderTextColor = placeholderTextColor;
    [self setValue:placeholderTextColor forKeyPath:GetTextFieldVar];
    
}


/**
 *  外部调用方法：
    .当nib调用的时候 把当前的 输入框 的Class 修改为当前类即可
    .当代码调用的时，包含头文件初始化后即可使用
 */



@end
