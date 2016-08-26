//
//  FCTopicVioceView.m
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/16.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "FCTopicVioceView.h"
#import "FCTopicModel.h"
#import "FCShowPictureViewController.h"
@interface FCTopicVioceView ()
/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
/** 播放次数 */
@property (weak, nonatomic) IBOutlet UILabel *playCount;
/** 音乐长度 */
@property (weak, nonatomic) IBOutlet UILabel *lenght;

@end

@implementation FCTopicVioceView

+ (instancetype)vioceView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}


- (void)setTopic:(FCTopicModel *)topic
{
    _topic = topic;
    
    // 图片
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    
    // 播放次数
    self.playCount.text = [NSString stringWithFormat:@"%zd播放",topic.playcount];
    
    // 时长
    NSInteger minute = topic.voicetime / 60;
    NSInteger second = topic.voicetime % 60;
    self.lenght.text = [NSString stringWithFormat:@"%02zd:%02zd",minute,second];
}

- (void)awakeFromNib
{
    // 当设置了固定的frame，但是还是出现偏差，设置以下便可纠正位置
    self.autoresizingMask = UIViewAutoresizingNone;
    
    // 给图片添加监听器
    self.imgView.userInteractionEnabled = YES;
    [self.imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
    
}

// 查看大图
- (void)showPicture
{
    FCShowPictureViewController *show = [[FCShowPictureViewController alloc] init];
    show.topic = self.topic;
#warning 注：因为本类是集成UIView，只是一个控件，无法跳转，所以要拿到根控制器进行跳转
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:show animated:YES completion:nil];
}



@end
