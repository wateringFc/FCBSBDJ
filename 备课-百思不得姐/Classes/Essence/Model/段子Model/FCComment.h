//
//  FCComment.h
//  备课-百思不得姐
//
//  Created by 方存 on 16/8/16.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FCUser;

/** 评论模型 */
@interface FCComment : NSObject
/** id */
@property (copy, nonatomic) NSString *ID;
/** 音频评论的时长 */
@property (nonatomic, assign) NSInteger voicetime;
/** 音频评论的内容(URL) */
@property (nonatomic, copy) NSString *voiceuri;
/** 评论的文字内容 */
@property (nonatomic, copy) NSString *content;
/** 别点赞的数量 */
@property (nonatomic, assign) NSInteger like_count;
/** 用户模型 */
@property (nonatomic, strong) FCUser *user;


@end
