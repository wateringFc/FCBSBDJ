//
//  FCLoginRegisterViewController.m
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/10.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "FCLoginRegisterViewController.h"
#import "FCVerticalButton.h"
@interface FCLoginRegisterViewController ()
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *loginBut;
@property (weak, nonatomic) IBOutlet UIButton *registerBut;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *pswField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLoginLine;

@end

@implementation FCLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self changeTextColor];
}


#pragma mark- 注册
- (IBAction)registers:(id)sender
{
    [self.view endEditing:YES];
    
    if (self.leftLoginLine.constant == 0) {
        // 显示注册界面
        self.leftLoginLine.constant = -self.view.xmg_width;
        [self.registerBut setTitle:@"已有账号？" forState:UIControlStateNormal];
    }else{
        self.leftLoginLine.constant = 0;  // 显示登陆界面
        [self.registerBut setTitle:@"注册账号" forState:UIControlStateNormal];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        // 马上更新布局
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];
  
}

#pragma mark-  X
- (IBAction)popBut:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- 修改状态栏颜色（信号，电量，时间）
- (UIStatusBarStyle)preferredStatusBarStyle
{
    // 修改为白色
    return UIStatusBarStyleLightContent;
}

#pragma mark - 修改等待文字颜色
- (void)changeTextColor
{
    // NSMutableAttributedString (富文本)
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:@"手机号" attributes:attrs];
//    self.phoneField.attributedPlaceholder = placeholder;


    /**
     NSString *const NSFontAttributeName;(字体)
     NSString *const NSParagraphStyleAttributeName;(段落)
     NSString *const NSForegroundColorAttributeName;(字体颜色)
     NSString *const NSBackgroundColorAttributeName;(字体背景色)
     NSString *const NSLigatureAttributeName;(连字符)
     NSString *const NSKernAttributeName;(字间距)
     NSString *const NSStrikethroughStyleAttributeName;(删除线)
     NSString *const NSUnderlineStyleAttributeName;(下划线)
     NSString *const NSStrokeColorAttributeName;(边线颜色)
     NSString *const NSStrokeWidthAttributeName;(边线宽度)
     NSString *const NSShadowAttributeName;(阴影)
     NSString *const NSVerticalGlyphFormAttributeName;(横竖排版)
     */
    
//    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:@"手机号"];
//    // 根据range来设置颜色（一般不使用）
//    [placeholder setAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(0, 1)];
//    // 也可以根据range来设置某个字体大小(多加一个参数即可)
//    [placeholder setAttributes:@{
//                                 NSForegroundColorAttributeName : [UIColor redColor],
//                                 NSFontAttributeName: [UIFont systemFontOfSize:25],
//                                 NSBackgroundColorAttributeName: [UIColor grayColor],
//                                 NSStrikethroughStyleAttributeName:@1,
//                                 } range:NSMakeRange(1, 1)];
//    [placeholder setAttributes:@{NSForegroundColorAttributeName : [UIColor greenColor]} range:NSMakeRange(2, 1)];
//    self.phoneField.attributedPlaceholder = placeholder;

}





- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}









// 测试封装button代码使用
//- (void)test
//{
//    FCVerticalButton *button = [[FCVerticalButton alloc] init];
//    button.frame = CGRectMake(100, 100, 100, 150);
//    [button setImage:[UIImage imageNamed:@"defaultUserIcon"] forState:UIControlStateNormal];
//    [button setTitle:@"测试" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//}



@end
