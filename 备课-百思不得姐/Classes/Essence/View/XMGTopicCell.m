//
//  XMGTopicCell.m
//  备课-百思不得姐
//
//  Created by MJ Lee on 15/6/18.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "XMGTopicCell.h"
#import "FCTopicModel.h"
#import "NSDate+FCDateExtension.h"
#import "FCComment.h"
#import "FCUser.h"
#import "FCTopicPictureView.h"
#import "FCTopicVioceView.h"
#import "FCTopicVideoView.h"
@interface XMGTopicCell()
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 时间 */
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
/** 文字 */
@property (weak, nonatomic) IBOutlet UILabel *text_label;
/** “踩”按钮 */
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
/** “分享”按钮 */
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
/** “评论”按钮 */
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
/** “顶”按钮 */
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
/** 是否位新浪加V */
@property (weak, nonatomic) IBOutlet UIImageView *vipView;
/** 最热评论内容 */
@property (weak, nonatomic) IBOutlet UILabel *topCmpLabel;
/** 最热评论父控件 */
@property (weak, nonatomic) IBOutlet UIView *topCmtView;


/** 图片帖子中间的内容 */
@property (weak, nonatomic) FCTopicPictureView *pictureView;
/** 声音帖子中间的内容 */
@property (weak, nonatomic) FCTopicVioceView *vioceView;
/** 视频帖子中间的内容 */
@property (weak, nonatomic) FCTopicVideoView *videoView;
@end

@implementation XMGTopicCell


+ (instancetype)showCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

// 懒加载，保证图片nib只加载一次
-(FCTopicPictureView *)pictureView
{
    if (!_pictureView) {
        // 因为是弱引用，不能这么创建
//        _pictureView = [FCTopicPictureView pictureView];
        FCTopicPictureView *pictureView = [FCTopicPictureView pictureView];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}

// 声音
- (FCTopicVioceView *)vioceView
{
    if (!_vioceView) {
        FCTopicVioceView *vioceView = [FCTopicVioceView vioceView];
        [self.contentView addSubview:vioceView];
        _vioceView = vioceView;
    }
    return _vioceView;
}

// 视频
- (FCTopicVideoView *)videoView
{
    if (!_videoView) {
        FCTopicVideoView *videoView = [FCTopicVideoView videoView];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}

- (void)awakeFromNib
{
    // 给cell添加背景图
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgView;
}


/**
 *  cell上显示发帖时间的显示形式
    今年
        今天
            1分钟前（刚刚）
            1小时内（xx分钟前）
            其它（xx小时前）
        昨天
            昨天 18：59：59
        其它
            06-13 19：31：21
    非今年
        2016-11-10 18：23：32
 */


- (void)setTopic:(FCTopicModel *)topic
{
    _topic = topic;
    
    // 判断是否显示加V图片
    self.vipView.hidden = !topic.isSina_v;
    
    // 头像
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:[[UIImage imageNamed:@"defaultUserIcon"] circleImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.iconView.image = [image circleImage];
    }];
    // 昵称
    self.nameLabel.text = topic.name;
    
    // 设置帖子的创建时间(create_time属性已经在模型中重写get方法处理时间显示)
    self.createdAtLabel.text = topic.create_time;
    
    // 文字
    self.text_label.text = topic.text;
    
    // 底部 4 个按钮
    [self setupButtonTitles:self.dingButton count:topic.ding placheolderText:@"顶"];
    [self setupButtonTitles:self.caiButton count:topic.cai placheolderText:@"踩"];
    [self setupButtonTitles:self.shareButton count:topic.repost placheolderText:@"分享"];
    [self setupButtonTitles:self.commentButton count:topic.comment placheolderText:@"评论"];
    
    // 根据模型类型（帖子类型）添加对应的内容到cell的中间
    if (topic.type == FCTopicTypePicture) {// 把图片 的内容添加到cell中间
        // 防止循环利用不显示
        self.pictureView.hidden = NO;
        self.vioceView.hidden = YES;
        self.videoView.hidden = YES;
        // 把模型传过去进行赋值
        self.pictureView.topic = topic;
        // 给nib位置赋值
        self.pictureView.frame = topic.pictureViewFram;
        
    }else if (topic.type == FCTopicTypeVoice) { // 声音
        self.pictureView.hidden = YES;
        self.vioceView.hidden = NO;
        self.videoView.hidden = YES;
        self.vioceView.topic = topic;
        self.vioceView.frame = topic.vioceViewFram;
    
    }else if (topic.type == FCTopicTypeVideo) { // 视频
        self.pictureView.hidden = YES;
        self.vioceView.hidden = YES;
        self.videoView.hidden = NO;
        self.videoView.topic = topic;
        self.videoView.frame = topic.videoViewFram;
        
    }else{ // 段子
        self.videoView.hidden = YES;
        self.vioceView.hidden = YES;
        self.pictureView.hidden = YES;
    }
    
    
    // 处理最热评论
    // 因为在cell上只显示一条最热评论，所以取出第一个数据就可以了 firstObject
    FCComment *cmt = [topic.top_cmt firstObject];
    if (cmt) {
        self.topCmtView.hidden = NO;
        self.topCmpLabel.text = [NSString stringWithFormat:@"%@: %@",cmt.user.username,cmt.content];
    }else{
        self.topCmtView.hidden = YES;
    }
    
    
}


/**
 *  处理底部 4个按钮文字显示
 *
 *  @param button      哪个按钮
 *  @param count       数量
 *  @param placheolderText    如果数量为0时
 */
- (void)setupButtonTitles:(UIButton *)button count:(NSInteger)count placheolderText:(NSString *)placheolderText
{
    if (count > 10000) {
        placheolderText = [NSString stringWithFormat:@"%.1f万", count / 10000.0];
    }else {
        placheolderText = [NSString stringWithFormat:@"%zd", count];
    }
    [button setTitle:placheolderText forState:UIControlStateNormal];
}

#pragma mark- cell右上角按钮点击事件
- (IBAction)more:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"收藏", @"举报", nil];
    [sheet showInView:self.window];
}

// 设置cell分割线
- (void)setFrame:(CGRect)frame
{
    frame.origin.x = FCTopicCellMargin;
    frame.origin.y += FCTopicCellMargin;
    
    
    
    frame.size.width -= 2 * FCTopicCellMargin;
//    frame.size.height -= FCTopicCellMargin; // 如果调用本句代码 直接减，在评论使用这个cell做header的时候，会一直调用，调用一回减10（间距），就会出现问题，而下面的算法就是固定高度减去10（就不会）一直调用
    frame.size.height = self.topic.cellHeigth - FCTopicCellMargin;
    [super setFrame:frame];
}

@end
