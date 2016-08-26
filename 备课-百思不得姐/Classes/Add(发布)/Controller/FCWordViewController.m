//
//  FCWordViewController.m
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/24.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "FCWordViewController.h"
#import "FCPlaceholderTextView.h"
#import "FCAddTagToobar.h"
@interface FCWordViewController ()<UITextViewDelegate>

/** 文本输入控件 */
@property (weak, nonatomic) FCPlaceholderTextView *textView;
/** 工具条 */
@property (weak, nonatomic) FCAddTagToobar *toobar;

@end

@implementation FCWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    [self createUI];
    [self setupToobar];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 成为第一响应者，显示视图的时候就弹出键盘
    [self.textView becomeFirstResponder];
}


- (void)setupNav
{
    self.title = @"发表文字";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(post)];
    // 设置默认不能点击
    self.navigationItem.rightBarButtonItem.enabled = NO;
    // 强制刷新
    [self.navigationController.navigationBar layoutIfNeeded];
}

#pragma mark- 事件处理区
- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)post
{
    LogFunc;
}

#pragma mark- 创建UI
- (void)createUI
{
    FCPlaceholderTextView *textView = [[FCPlaceholderTextView alloc] init];
    textView.frame = self.view.bounds;
//    textView.placeholderTextColor = [UIColor redColor];
    textView.placeholderText = @"把好玩的图片，好笑的段子或糗事发到这里，接受千万网友膜拜吧！发布违反国家法律内容的，我们将依法提交给有关部门处理...";
    textView.delegate = self;
    [self.view addSubview:textView];
    self.textView = textView;
}

#pragma mark- 设置toobar
- (void)setupToobar
{
    FCAddTagToobar *toobar = [FCAddTagToobar toolbar];
    toobar.xmg_width = self.view.xmg_width;
    toobar.xmg_y = self.view.xmg_height - toobar.xmg_height;
    [self.view addSubview:toobar];
    self.toobar = toobar;
    
    // 监听键盘弹出、隐藏
    [FCNoteCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

// 实现 监听键盘弹出、隐藏 方法
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 拿到键盘最终的frame （CGRectValue 转换成 位置）
    CGRect keyFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 拿到键盘起落 动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        // 利用 transform 移动比控制 self.toobar Y值好一点
        self.toobar.transform = CGAffineTransformMakeTranslation(0, keyFrame.origin.y - SCREENHEIGHT);
    }];
    
}


#pragma mark- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    // textView内容发生改变，有文字的时候就可以点击
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
