//
//  FCTopicVideoView.m
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/16.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "FCTopicVideoView.h"
#import "FCTopicModel.h"
#import "FCShowPictureViewController.h"
@interface FCTopicVideoView()
/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *videoImgView;
/** 播放次数 */
@property (weak, nonatomic) IBOutlet UILabel *videoPlayCount;
/** 视频长度 */
@property (weak, nonatomic) IBOutlet UILabel *videoLenght;

@end

@implementation FCTopicVideoView


+ (instancetype)videoView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

- (void)setTopic:(FCTopicModel *)topic
{
    _topic = topic;
    
    [self.videoImgView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    
    // 播放次数
    self.videoPlayCount.text = [NSString stringWithFormat:@"%zd播放",topic.playcount];
    
    // 时长
    NSInteger minute = topic.videotime / 60;
    NSInteger second = topic.videotime % 60;
    self.videoLenght.text = [NSString stringWithFormat:@"%02zd:%02zd",minute,second];
}

- (void)awakeFromNib
{
    // 当设置了固定的frame，但是还是出现偏差，设置以下便可纠正位置
    self.autoresizingMask = UIViewAutoresizingNone;
    
    // 给图片添加监听器
    self.videoImgView.userInteractionEnabled = YES;
    [self.videoImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
    
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
