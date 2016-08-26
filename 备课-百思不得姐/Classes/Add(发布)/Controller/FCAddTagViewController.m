//
//  FCAddTagViewController.m
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/25.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "FCAddTagViewController.h"
#import "FCTagButton.h"
#import "FCTagTextField.h"
#define BgColor XMGColor(74, 139, 209)
@interface FCAddTagViewController ()<UITextFieldDelegate>

/** 容器 */
@property (weak, nonatomic) UIView *contenView;
/** 文本输入框 */
@property (weak, nonatomic) UITextField *textField;
/** 添加显示标签 */
@property (weak, nonatomic) UIButton *addButton;
/** 所有的标签按钮 */
@property (nonatomic, strong) NSMutableArray *tagButtons;

@end

@implementation FCAddTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    [self setupContentView];
    [self setupTextFiled];
    [self setupTags];
    
}
#pragma mark- 懒加载
- (NSMutableArray *)tagButtons {
    if (!_tagButtons) {
        self.tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}

- (UIButton *)addButton
{
    if (!_addButton) {
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.xmg_width = self.contenView.xmg_width;
        addButton.xmg_height = 35;
        addButton.backgroundColor = BgColor;
        [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
        // 让按钮内部的文字图片左对齐
        addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        addButton.contentEdgeInsets = UIEdgeInsetsMake(0, FCTagMargin, 0, FCTagMargin);
        addButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contenView addSubview:addButton];
        _addButton = addButton;
    }
    return _addButton;
}

#pragma mark - 上个界面传过来的标签文字，到本界面再已标签按钮形式显示出来
- (void)setupTags
{
    for (NSString *str in self.tags) {
        self.textField.text = str;
        [self addButtonClick];
    }
}


#pragma mark- 设置导航栏
- (void)setupNav
{
    self.title = @"添加标签";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
}

#pragma mark - 实现完成itme点击事件
- (void)done
{
    // 取出数组中所有按钮的文字(方法一)
//    NSMutableArray *tags = [NSMutableArray array];
//    for (FCTagButton *tagButton in self.tagButtons) {
//        [tags addObject:tagButton.currentTitle];
//    }
    // 取出数组中所有按钮的文字(方法二)
    NSArray *tags = [self.tagButtons valueForKeyPath:@"currentTitle"];
    // Block 传递数据
    !self.tagsBlock ? : self.tagsBlock(tags);
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 背景容器
- (void)setupContentView
{
    UIView *contenView = [[UIView alloc] init];
    contenView.xmg_x = FCTagMargin;
    contenView.xmg_y = 64 + FCTagMargin;
    contenView.xmg_width = self.view.xmg_width - 2 * FCTagMargin;
    contenView.xmg_height = self.view.xmg_height - 2 * FCTagMargin;
    [self.view addSubview:contenView];
    self.contenView = contenView;
}

#pragma mark- 创建输入框
- (void)setupTextFiled
{
    FCTagTextField *textField = [[FCTagTextField alloc] init];
    textField.xmg_y = 0;
    textField.xmg_x = FCTagMargin;
    textField.xmg_width = self.contenView.xmg_width;
    textField.xmg_height = 25;
    textField.delegate = self;
    textField.placeholder = @"多个标签用换行或逗号隔开";
    // 设置占位文字之后才能设置占位文字的颜色
    [textField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    // UITextField 继承 UIControl ，所有可以使用addTarget进行监听文字变化
    [textField addTarget:self action:@selector(textDidchange) forControlEvents:UIControlEventEditingChanged];
    [textField becomeFirstResponder];
    [self.contenView addSubview:textField];
    self.textField = textField;
    
    // 按删除键 删除 前面标签按钮
    __weak typeof(self) weakSelf = self;
    textField.deleteBlock = ^{
        if (weakSelf.textField.hasText) return; // 有文字就return
        [weakSelf tagButtonClick:[weakSelf.tagButtons lastObject]];
    };
}

#pragma mark - 监听文字变化事件
- (void)textDidchange
{
    if (self.textField.hasText) {
        // 1.有文字，显示添加标签按钮
        self.addButton.hidden = NO;
        self.addButton.xmg_y = CGRectGetMaxY(self.textField.frame) + FCTagMargin;
        [self.addButton setTitle:[NSString stringWithFormat:@"添加标签:%@",self.textField.text] forState:UIControlStateNormal];
        // 2.获取最后一个字符串(用，号添加标签)
        NSString *text = self.textField.text;
        NSUInteger len = text.length;
        NSString *lastLetter = [text substringFromIndex:len - 1];
        if ([lastLetter hasSuffix:@","] || [lastLetter hasSuffix:@"，"]) {
            // 去除，号
            self.textField.text = [text substringToIndex:len - 1];
            // 调用添加按钮方法
            [self addButtonClick];
        }
    }else{
        // 没有文字，隐藏添加标签按钮
        self.addButton.hidden = YES;
    }
    
    // 更新标签和文本框的frame
    [self updateTagButFrame];
}

#pragma mark - 监听添加标签按钮点击事件
- (void)addButtonClick
{
    // 限制标签数量
    if (self.tagButtons.count == 5) {
        [SVProgressHUD showErrorWithStatus:@"最多只能添加5个标签" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    // 1.添加一个“标签按钮”
    FCTagButton *tagButton = [FCTagButton buttonWithType:UIButtonTypeCustom];
    [tagButton setTitle:self.textField.text forState:UIControlStateNormal];
    tagButton.xmg_height = self.textField.xmg_height;
    [tagButton addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contenView addSubview:tagButton];
    // 2.把按钮添加到数组中
    [self.tagButtons addObject:tagButton];
    // 3.更新标签按钮和更新TextField的Frame
    [self updateTagButFrame];
    // 4.清空textField的文字
    self.textField.text = nil;
    // 5.隐藏显示标签按钮
    self.addButton.hidden = YES;
}

#pragma mark - 添加一个“标签按钮”点击事件(删除)
- (void)tagButtonClick:(UIButton *)tagButton
{
    // 1.删除按钮
    [tagButton removeFromSuperview];
    // 2.从数组中删除这个按钮
    [self.tagButtons removeObject:tagButton];
    // 3.重新布局按钮位置
    [UIView animateWithDuration:0.3 animations:^{
        [self updateTagButFrame];
    }];
}

#pragma mark - 更新标签按钮的frame(核心代码)
- (void)updateTagButFrame
{
    for (int i = 0; i < self.tagButtons.count; i++) {
        FCTagButton *tagButton = self.tagButtons[i];
        
        if (i == 0) { // 最前面的标签按钮
            tagButton.xmg_x = 0;
            tagButton.xmg_y = 0;
            
        }else{ // 其它标签按钮
            FCTagButton *lastTagButton = self.tagButtons[i - 1];
            /** 计算当前行左边的宽度 */
            CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + FCTagMargin;
            /** 计算当前行剩余右边的宽度 */
            CGFloat rightWidth = self.contenView.xmg_width - leftWidth;
            
            if (rightWidth >= tagButton.xmg_width) { // 按钮标签显示在当前行
                tagButton.xmg_y = lastTagButton.xmg_y;
                tagButton.xmg_x = leftWidth;
                
            }else{
                tagButton.xmg_x = 0;
                tagButton.xmg_y = CGRectGetMaxY(lastTagButton.frame) +FCTagMargin;
            }
        }
    }
    // 更新TextField的Frame
    [self updateTextFieldFrame];
}

#pragma mark - 更新TextField的Frame
- (void)updateTextFieldFrame
{
    // 1、取出最后一个标签按钮
    FCTagButton *lastTagBut = [self.tagButtons lastObject];
    
    // 2、左边的宽度
    CGFloat leftWidth = CGRectGetMaxX(lastTagBut.frame) + FCTagMargin;
    // 2.1、更新textField的frame
    if (self.contenView.xmg_width - leftWidth >= [self textFieldTextWidth]) {
        self.textField.xmg_y = lastTagBut.xmg_y;
        self.textField.xmg_x = leftWidth;
    }else{
        self.textField.xmg_x = 0;
        self.textField.xmg_y = CGRectGetMaxY([[self.tagButtons lastObject] frame]) + FCTagMargin;
    }
}

#pragma mark - textFielde文字宽度
- (CGFloat)textFieldTextWidth
{
    CGFloat textW = [self.textField.text sizeWithAttributes:@{NSFontAttributeName : self.textField.font}].width;
    return MAX(100, textW);
}

#pragma mark - <UITextFieldDelegate>
// 监听键盘return按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.hasText) {
        [self addButtonClick];
    }
    return YES;
}

// 右边清除按钮会调用此方法
//- (BOOL)textFieldShouldClear:(UITextField *)textField
//{
//    return YES;
//}


/**
 *  布局子控件的方法(官方推荐在此方法中布局)
 */
- (void)viewDidLayoutSubviews
{
    
}

@end
