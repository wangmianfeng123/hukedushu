//
//  HKMessageReplyVC.h
//  Code
//
//  Created by Ivan li on 2017/10/31.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKBaseVC.h"
#import "HKShortVideoCommentModel.h"



/** 消息 类别 */
typedef NS_ENUM(NSUInteger, HKMessageType) {
    HKMessageType_video = 0, // 普通视频
    HKMessageType_shortVideo,  //短视频视频
    HKMessageType_book, // 虎课读书
};


@class NewCommentModel,CommentChildModel,HKBookCommentModel;


@interface HKMessageReplyVC : HKBaseVC


- (instancetype)initWithModel:(id)commentModel;

/// 短视频评论
@property(nonatomic, strong)HKShortVideoCommentModel *shortVideoCommentModel;
/// 读书评论
@property(nonatomic,assign)HKBookCommentModel *bookCommentModel;

@property(nonatomic,assign)HKMessageType MessageType;

@end
