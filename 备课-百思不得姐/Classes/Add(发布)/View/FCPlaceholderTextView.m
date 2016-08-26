//
//  FCPlaceholderTextView.m
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/24.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "FCPlaceholderTextView.h"

@interface FCPlaceholderTextView()
/** 占位文字label */
@property (weak, nonatomic) UILabel *placeholderLabel;

@end

@implementation FCPlaceholderTextView

/** 懒加载 */
- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        // 添加一个用来显示占位文字的label
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.xmg_x = 4;
        placeholderLabel.xmg_y = 7;
        placeholderLabel.numberOfLines = 0;
        [self addSubview:placeholderLabel];
        _placeholderLabel = placeholderLabel;
    }
    return _placeholderLabel;
}

/** 初始化 */
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 垂直方向永远有弹簧效果
        self.alwaysBounceVertical = YES;
        // 设置默认的占位文字颜色(外界设置之后引用外界设置颜色)
        self.placeholderTextColor = [UIColor darkGrayColor];
        // 设置默认的字体
        self.font = [UIFont systemFontOfSize:15];
        // 监听文字改变
        [FCNoteCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

/** 实现监听方法 */
- (void)textDidChange
{
    // 只要有文字就隐藏 占位文字
    self.placeholderLabel.hidden = self.hasText;
}

#pragma mark-  重写set方法
- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor
{
    _placeholderTextColor = placeholderTextColor;
    self.placeholderLabel.textColor = placeholderTextColor;
}

- (void)setPlaceholderText:(NSString *)placeholderText
{
    _placeholderText = [placeholderText copy];
    self.placeholderLabel.text = placeholderText;
    [self setNeedsLayout];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeholderLabel.font = font;
    [self setNeedsLayout];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textDidChange];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self textDidChange];
}

/** 更新占位文字的尺寸*/
- (void)layoutSubviews
{
    [super layoutSubviews];
    //  方法一
    //    CGSize maxSize = CGSizeMake(self.xmg_width - 2 * self.placeholderLabel.xmg_x, MAXFLOAT);
    //    self.placeholderLabel.xmg_size = [self.placeholderText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:nil].size;
    
    // 方法二
    self.placeholderLabel.xmg_width = self.xmg_width - 2 * self.placeholderLabel.xmg_x;
    [self.placeholderLabel sizeToFit]; // 包裹内容
}

- (void)dealloc
{
    // 销毁通知
    [FCNoteCenter removeObserver:self];
}

/** 注意：
 [self setNeedsLayout]  --> 会在恰当的时候调用 layoutSubviews 方法
 [self setNeedsDisplay] --> 会在恰当的时候调用 drawRect 方法
 */







@end
