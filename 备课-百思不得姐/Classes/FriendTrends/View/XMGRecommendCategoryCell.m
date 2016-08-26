//
//  XMGRecommendCategoryCell.m
//  备课-百思不得姐
//
//  Created by MJ Lee on 15/6/25.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "XMGRecommendCategoryCell.h"
#import "XMGRecommendCategory.h"

@interface XMGRecommendCategoryCell()
/**
 *  选中时的指示器（注意cell选中后背景色会覆盖指示器）
 */
@property (weak, nonatomic) IBOutlet UIView *selectedIndicator;

@end

@implementation XMGRecommendCategoryCell

// 此方法省去 控制器 if(!cell){.......}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"category";
    XMGRecommendCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}

// 修改nib中控件的属性
- (void)awakeFromNib
{
    self.textLabel.font = [UIFont systemFontOfSize:15];
    // 当cell的 selection 为None 时，及时cell被选中，内部子控件也不会进入高亮状态，如果想在选中后做操作在 👇下面方法中操作
//    self.textLabel.highlightedTextColor = XMGColor(219, 21, 26);
}


/**
 *  监听cell的选中与否
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // 没有选中的时候隐藏
    self.selectedIndicator.hidden = !selected;
    // 设置选中/未选中的样色
    self.textLabel.textColor = selected?XMGColor(192, 62, 66):[UIColor darkGrayColor];
}

/**
 *  cell控件赋值
 *
 *  @param category 左边model
 */
- (void)setCategory:(XMGRecommendCategory *)category
{
    _category = category;
    self.textLabel.text = category.name;
}
@end
