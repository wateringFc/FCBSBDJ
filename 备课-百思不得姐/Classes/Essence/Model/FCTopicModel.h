//
//  FCTopicModel.h
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/12.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h> // ----> 因为要添加 辅助 属性，其中包含 CGFloat 保险起见使用<UIKit/UIKit.h>

/** 帖子模型 */
@interface FCTopicModel : NSObject

/** id */
@property (copy, nonatomic) NSString *ID;
/** 昵称 */
@property (copy, nonatomic) NSString *name;
/** 头像 */
@property (copy, nonatomic) NSString *profile_image;
/** 时间 */
@property (copy, nonatomic) NSString *create_time;
/** 内容 */
@property (copy, nonatomic) NSString *text;
/** 顶的数量 */
@property (assign, nonatomic) NSInteger ding;
/** 踩的数量 */
@property (assign, nonatomic) NSInteger cai;
/** 评论数量 */
@property (assign, nonatomic) NSInteger comment;
/** 转发的数量 */
@property (assign, nonatomic) NSInteger repost;
/** 是否为新浪加V用户 */
@property (assign, nonatomic, getter=isSina_v) BOOL sina_v;
/** 帖子的类型 */
@property (assign, nonatomic) FCTopicType type;

/****** 图片相关 ******/
/** 小图片 */
@property (copy, nonatomic) NSString *small_image;
/** 大图片 */
@property (copy, nonatomic) NSString *large_image;
/** 中图片 */
@property (copy, nonatomic) NSString *middle_image;
/** 是否为gif图片 */
@property (assign, nonatomic) BOOL is_gif;
/** 图片的宽度 */
@property (assign, nonatomic) CGFloat width;
/** 图片的高度 */
@property (assign, nonatomic) CGFloat height;
/** 评论数组模型（这个top_cmt 数组里面存放的是 FCComment 模型） */
@property (strong, nonatomic) NSArray *top_cmt;

/****** 声音相关 ******/
/** 声音时长 */
@property (assign, nonatomic) NSInteger voicetime;
/** 声音播放次数 */
@property (assign, nonatomic) NSInteger playcount;

/****** 视频相关 ******/
/** 视频时长 */
@property (assign, nonatomic) NSInteger videotime;



// 假如需要取到 top_cmt 数组字典中 user 字典中的 username  在.m中使用下面方法就可以取到对应的参数
//@property (copy, nonatomic) NSString *username;

//+ (NSDictionary *)replacedKeyFromPropertyName
//{
//    return @{@"username" : @"top_cmt[0].user.username"};
//}





//-------以下为辅助属性-------
/** cell的高度(添加为只读属性之后，编译器不会自动生成成员变量，需要自己手动生成) */
@property (assign, nonatomic, readonly) CGFloat cellHeigth;
/** 图片控件（nib）的frame */
@property (assign, nonatomic, readonly) CGRect pictureViewFram;
/** 图片是否过长 */
@property (assign, nonatomic, getter=isBigPicture) BOOL bigPicture;
/** 图片下载进度 */
@property (assign, nonatomic) CGFloat pictureProgress;

/** 声音控件（nib）的frame */
@property (assign, nonatomic, readonly) CGRect vioceViewFram;

/** 视频控件（nib）的frame */
@property (assign, nonatomic, readonly) CGRect videoViewFram;

@end
