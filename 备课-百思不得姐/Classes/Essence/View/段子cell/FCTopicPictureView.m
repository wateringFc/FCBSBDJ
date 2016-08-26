//
//  FCTopicPictureView.m
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/14.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "FCTopicPictureView.h"
#import "FCTopicModel.h"
//#import <M13ProgressViewRing.h>
#import "FCProgressView.h" // 集成第三方框架，达成面向对象开发
#import "FCShowPictureViewController.h"
//#import <DALabeledCircularProgressView.h> // 进度条存在一定缺陷，不使用
@interface FCTopicPictureView ()
/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *imageViews;
/** GIF标识 */
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
/** 查看大图按钮 */
@property (weak, nonatomic) IBOutlet UIButton *seeBigButton;
/** 进度条控件 */
@property (weak, nonatomic) IBOutlet FCProgressView *progressView;

@end

@implementation FCTopicPictureView

+ (instancetype)pictureView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

- (void)setTopic:(FCTopicModel *)topic
{
    _topic = topic;
    
    // 设置图片(带图片下载进度)
//    [self.imageViews sd_setImageWithURL:[NSURL URLWithString:topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        self.progressView.hidden = NO;
//        // receivedSize 接收到的大小 expectedSize 期望得到的大小
//        CGFloat progress = 1.0 * receivedSize / expectedSize;
//        [self.progressView setProgress:progress];
//        // 设置进度条中间文字
//        NSString *text = [NSString stringWithFormat:@"%.0f％",progress * 100];
//        text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
//        self.progressView.progressLabel.text = text;
//        
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        self.progressView.hidden = YES;
//    }];
    
    
    // 立马显示最新的进度值（防止因为网速慢，导致显示的是其它图片的下载进度）
    [self.progressView setProgress:topic.pictureProgress animated:NO];
    
    [self.imageViews sd_setImageWithURL:[NSURL URLWithString:topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        // 计算进度值
        topic.pictureProgress = 1.0 * receivedSize / expectedSize;
        // 显示进度值
        [self.progressView setProgress:topic.pictureProgress animated:NO];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
        
        // 如果是大图片，才需要进行绘图处理
        if (topic.isBigPicture == NO) {
            return;
        }
        
        // 获取长图顶部内容↓
        // 开启图形上下文
        UIGraphicsBeginImageContextWithOptions(topic.pictureViewFram.size, YES, 0.0);
        // 将下载完的图片对象绘制到图形上下文
        CGFloat width = topic.pictureViewFram.size.width;
        CGFloat height = width * image.size.height / image.size.width;
        [image drawInRect:CGRectMake(0, 0, width, height)];
        // 获得图片
        self.imageViews.image =UIGraphicsGetImageFromCurrentImageContext();
        // 结束图形上下文
        UIGraphicsEndImageContext();
        
    }];
    
    
    
    
    
    /** 注：在不知道图片扩展名的情况下，如何知道图片真实类型？
     .取出图片的第一个字节，就可以判断出图片的真实类型  */
    // 判断是否为GIF图片(把扩展名转为小写，根据图片路径扩展名判断是否显示与否)
    NSString *extension = topic.large_image.pathExtension;
    self.gifView.hidden = ![extension.lowercaseString isEqualToString:@"gif"];
    
    
    // 判断时候显示“点击查看大图”按钮
    if (topic.isBigPicture) {// 大图
        self.seeBigButton.hidden = NO;
        // 内容显示模式
        self.imageViews.contentMode = UIViewContentModeScaleAspectFill;
    }else{// 非大图
        self.seeBigButton.hidden = YES;
        self.imageViews.contentMode = UIViewContentModeScaleToFill;
    }
    
}

- (void)awakeFromNib
{
    // 当设置了固定的frame，但是还是出现偏差，设置以下便可纠正位置
    self.autoresizingMask = UIViewAutoresizingNone;
    
    // 给图片添加监听器
    self.imageViews.userInteractionEnabled = YES;
    [self.imageViews addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
    
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
