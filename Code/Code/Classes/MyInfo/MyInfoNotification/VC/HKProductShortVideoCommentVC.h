//
//  HKMyInfoNotification.h
//  Code
//
//  Created by hanchuangkeji on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKBaseVC.h"

@interface HKProductShortVideoCommentVC : HKBaseVC

- (void)allRedBtnClicked;

@property (nonatomic, copy)void(^unread_msg_totalBlock)(NSString *unread_msg_total, int index);

@property (nonatomic, assign)int index;

@end
