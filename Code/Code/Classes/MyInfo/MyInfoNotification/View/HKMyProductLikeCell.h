//
//  HKMyInfoNotificationCell.h
//  Code
//
//  Created by hanchuangkeji on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "HKMyInfoNotificationModel.h"
@class HKMyProductLikeCellModel;

@interface HKMyProductLikeCell : UITableViewCell

@property (nonatomic, copy)void(^avatorClickBlock)(HKMyProductLikeCellModel *);

@property (nonatomic, strong)HKMyProductLikeCellModel *model;

@end


@interface HKMyProductLikeCellModel : NSObject
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *username;
@property (nonatomic, copy)NSString *avatar;
@property (nonatomic, copy)NSString *target_id;
@property (nonatomic, copy)NSString *target_type;
@property (nonatomic, copy)NSString * is_read;
@property (nonatomic, copy)NSString *created_at;
@property (nonatomic, copy)NSString * content;  //
@property (nonatomic, copy)NSString * notice_title;  //

//@property (nonatomic, copy)NSString *cover;
//@property (nonatomic, copy)NSString *task_id;
@end
