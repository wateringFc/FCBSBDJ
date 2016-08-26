//
//  FCCommentCell.m
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/17.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "FCCommentCell.h"
#import "FCComment.h"
#import "FCUser.h"
@interface FCCommentCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;
@property (weak, nonatomic) IBOutlet UILabel *ding;

@property (weak, nonatomic) IBOutlet UILabel *conten;
@property (weak, nonatomic) IBOutlet UIButton *playVoiceBut;
@end


@implementation FCCommentCell

- (void)awakeFromNib
{
    // 给cell添加背景图
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgView;
}

- (void)setComment:(FCComment *)comment
{
    _comment = comment;
    // 只要是图片都能调用 处理圆形方法（等待图也可以调用）
    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:comment.user.profile_image] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // 头像调用(这样是因为有时候用户没有上传头像给服务器，所以服务器没有返回头像地址给我们，sdImg也就无法没法给我们传递，所以这个时候但没有数据的时候使用等待图显示)
        self.imgView.image = image ? [image circleImage] : placeholder;
    }];
    
    self.sexView.image = [comment.user.sex isEqualToString:FCUserSexMale] ? [UIImage imageNamed:@"Profile_manIcon"] : [UIImage imageNamed:@"Profile_womanIcon"];
    self.conten.text = comment.content;
    self.name.text = comment.user.username;
    self.ding.text = [NSString stringWithFormat:@"%zd",comment.like_count];
    
    // 判断音频按钮显示与否
    if (comment.voiceuri.length) {
        self.playVoiceBut.hidden = NO;
        [self.playVoiceBut setTitle:[NSString stringWithFormat:@"%zd“",comment.voicetime] forState:UIControlStateNormal];
    }else{
        self.playVoiceBut.hidden = YES;
    }
}

- (IBAction)voiceButClick:(id)sender
{
    
}

// 设置间隔
- (void)setFrame:(CGRect)frame
{
    frame.origin.x = FCTopicCellMargin;
    frame.size.width -= 2 *FCTopicCellMargin;
    [super setFrame:frame];
}


#pragma mark- UIMenuController的显示必须要实现方法
- (BOOL)canBecomeFirstResponder
{
    return YES;
}


- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{   // 不使用系统提供的方法（copy cut什么的）
    return NO;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
