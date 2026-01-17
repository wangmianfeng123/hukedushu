//
//  HKMyInfoNotificationModel.h
//  Code
//
//  Created by hanchuangkeji on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKMyInfoNotificationModel : NSObject

@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *username;

@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *avator;
@property (nonatomic, copy)NSString *comment_id;
@property (nonatomic, copy)NSString *video_id;
@property (nonatomic, copy)NSString *top_id;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, assign)BOOL is_read;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *cover_url;

@property (nonatomic, assign)BOOL isShortVideo; // 是否为短视频评论，默认NO

//@property (nonatomic, copy)NSString *unread_msg_total;

@property (nonatomic, assign)double created_at;

@property (nonatomic, copy)NSString *created_at_string;

@property (nonatomic, assign)CGFloat contentLBHeigth;


@property (nonatomic, assign)CGFloat cellHeight;

@end
