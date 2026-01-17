//
//  HKMyInfoNotificationCell.h
//  Code
//
//  Created by hanchuangkeji on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKBookCommentModel,HKMyInfoNotificationModel,HKShortVideoCommentModel;

@interface HKMyInfoNotificationCell : UITableViewCell

@property (nonatomic, strong)HKMyInfoNotificationModel *model;

@property (nonatomic, strong)HKShortVideoCommentModel *shortVideoCommentModel;

@property (nonatomic, copy)void(^replyBtnClickBlock)(id model,HKBookCommentModel *bookModel);

@property (nonatomic, copy)void(^avatorClickBlock)(id model,HKBookCommentModel *bookModel);

@property (nonatomic, strong)HKBookCommentModel *bookCommentModel;

@end

