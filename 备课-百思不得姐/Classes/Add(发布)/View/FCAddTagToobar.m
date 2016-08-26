//
//  FCAddTagToobar.m
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/25.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "FCAddTagToobar.h"
#import "FCAddTagViewController.h"
#define BgColor XMGColor(74, 139, 209)

@interface FCAddTagToobar()
/** 显示标签的view */
@property (weak, nonatomic) IBOutlet UIView *topView;
/** 存放所有标签 */
@property (strong, nonatomic) NSMutableArray *tagLabes;
/** 添加按钮 */
@property (weak, nonatomic) UIButton *addButton;
@end


@implementation FCAddTagToobar

+ (instancetype)toolbar
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}


- (NSMutableArray *)tagLabes
{
    if (!_tagLabes) {
        _tagLabes = [NSMutableArray array];
    }
    return _tagLabes;
}

- (void)awakeFromNib
{
    // 1.显示 + 号按钮
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
//    // 获取图片的大小
//    addButton.xmg_size = [UIImage imageNamed:@"tag_add_icon"].size;
//    // 图片普通状态时候的大小
//    addButton.xmg_size = [addButton imageForState:UIControlStateNormal].size;
    // 当前正在展示的图片大小
    addButton.xmg_size = addButton.currentImage.size;
    addButton.xmg_x = FCTopicCellMargin;
    [addButton addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:addButton];
    self.addButton = addButton;
    
    
    // 2.默认显示2个标签
    [self createTags:@[@"吐槽", @"糗事"]];
}


#pragma mark - 点击 + 号 按钮事件
- (void)addBtnClick
{
    FCAddTagViewController *vc = [[FCAddTagViewController alloc] init];
    
    __weak typeof(self) weakSelf = self;
    // 拿到用户添加标签的所有文字
    vc.tagsBlock = ^(NSArray *tags){
        [weakSelf createTags:tags];
    };
    
    // 取出所有标签的文字 传递 给添加标签页面的数组
    vc.tags = [self.tagLabes valueForKeyPath:@"text"];
    
    [(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController pushViewController:vc animated:YES];
    
    /* 重要知识点：
     a modal出b
     [a presentViewController: b animated:YES completion:nil];
     a.presentedViewController -> b (a 找到 b)
     b.presentingViewController -> a (b 找到 a)
     */
    
}


// 在 layoutSubviews 中布局子控件之后 从nib中获得宽高就不会出问题
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < self.tagLabes.count; i++) {
        UILabel *tagLabel = self.tagLabes[i];
        
        if (i == 0) { // 最前面的标签
            tagLabel.xmg_x = 0;
            tagLabel.xmg_y = 0;
            
        }else{ // 其它标签
            UILabel *lastTagLabel = self.tagLabes[i - 1];
            /** 计算当前行左边的宽度 */
            CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + FCTagMargin;
            /** 计算当前行剩余右边的宽度 */
            CGFloat rightWidth = self.topView.xmg_width - leftWidth;
            
            if (rightWidth >= tagLabel.xmg_width) { // 按钮标签显示在当前行
                tagLabel.xmg_y = lastTagLabel.xmg_y;
                tagLabel.xmg_x = leftWidth;
                
            }else{
                tagLabel.xmg_x = 0;
                tagLabel.xmg_y = CGRectGetMaxY(lastTagLabel.frame) + FCTagMargin;
            }
        }
        
    }
    // 3.计算 + 号 按钮的frame
    [self updateAddButtonFrame];
}


#pragma mark - 计算 + 号 按钮的frame
- (void)updateAddButtonFrame
{
    // 1、取出最后一个标签
    UILabel *lastTagLabel = [self.tagLabes lastObject];
    // 2、左边的宽度
    CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + FCTagMargin;
    // 2.1、更新 + 号按钮的frame
    if (self.topView.xmg_width - leftWidth >= self.addButton.xmg_width) {
        self.addButton.xmg_y = lastTagLabel.xmg_y;
        self.addButton.xmg_x = leftWidth;
    }else{
        self.addButton.xmg_x = 0;
        self.addButton.xmg_y = CGRectGetMaxY([[self.tagLabes lastObject] frame]) + FCTagMargin;
    }
    
    // 顶部控件的整体高度
    CGFloat oldH = self.xmg_height;
    self.xmg_height = CGRectGetMaxY(self.addButton.frame) + 45;
    self.xmg_y -= self.xmg_height - oldH;
}


#pragma mark - 根据回调过来的数组创建显示标签
- (void)createTags:(NSArray *)tags
{
    // 1.清空之前数组中内容，防止数组中标签叠加，出现问题
    [self.tagLabes makeObjectsPerformSelector:@selector(removeFromSuperview)]; // 数组中的标签从父类中抹掉
    [self.tagLabes removeAllObjects]; // 删除数组中所有内容
    
    // 2.计算数组中标签显示frame
    for (int i = 0; i < tags.count; i++) {
        UILabel *tagLabel = [[UILabel alloc] init];
        // 添加到数组中
        [self.tagLabes addObject:tagLabel];
        tagLabel.backgroundColor = BgColor;
        tagLabel.text = tags[i];
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.textColor = [UIColor whiteColor];
        tagLabel.font = [UIFont systemFontOfSize:14];
        [tagLabel sizeToFit];
        tagLabel.xmg_width += 2 * FCTagMargin;
        tagLabel.xmg_height = 25;
        [self.topView addSubview:tagLabel];
    }
    
    // 重新布局子控件 ✨
    [self setNeedsLayout];
}




- (IBAction)clickBut:(id)sender
{
    LogFunc;
}




@end
