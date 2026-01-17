//
//  HKMyInfoNotificationCell.h
//  Code
//
//  Created by hanchuangkeji on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKMyInfoNotificationModel.h"
@class HKMyNotificationCellModel;

@interface HKMyNotificationCell : UITableViewCell

@property (nonatomic, strong)HKMyNotificationCellModel *model;

@end


@interface HKMyNotificationCellModel : NSObject

@property (nonatomic, copy)NSString *avator;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *count;
/// 普通评论
@property(nonatomic,assign)NSInteger comment_unread_msg_total;
/// 短视频评论
@property(nonatomic,assign)NSInteger short_video_unread_msg_total;
/// 读书评论
@property(nonatomic,assign)NSInteger unread_book_reply;
/// 点赞
@property(nonatomic,assign)NSInteger like_unread_msg_total;
@end
