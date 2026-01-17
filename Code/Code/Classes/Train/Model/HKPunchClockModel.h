//
//  HKPunchClockModel.h
//  Code
//
//  Created by yxma on 2020/8/26.
//  Copyright © 2020 pg. All rights reserved.
//

/**
{
    avator = "https://app-test.huke88.com/images/user_avator.jpg";
    "created_at" = "2020-08-26 11:59:27";
    "del_at" = 0;
    "del_reason" = "";
    "del_type" = 0;
    "del_user" = 0;
    id = 420436;
    "image_url" = "https://pic.huke88.com/training/task/2020-08-26/FC4854A9-7712-7FEA-4A03-390AF7B51457.jpg";
    "is_del" = 0;
    "is_self" = 0;
    "is_share" = 0;
    like = 0;
    "task_day" = 12;
    "task_desc" = "";
    "thumbs_up" = 0;
    "training_id" = 345;
    uid = 716732614;
    "updated_at" = 1598414367;
    username = xiaoaibaidu;
    "vip_class" = 1;
}
*/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKPunchClockModel : NSObject
@property (nonatomic, copy) NSString * avator;
@property (nonatomic, copy) NSString * created_at;
@property (nonatomic, copy) NSString * del_reason;
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * image_url;
@property (nonatomic, copy) NSString * task_desc;
@property (nonatomic, copy) NSString * training_id;
@property (nonatomic, copy) NSString * uid;
@property (nonatomic, copy) NSString * updated_at;
@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString * thumbs_up;



@property (nonatomic, assign) int del_at;
@property (nonatomic, assign) int del_type;
@property (nonatomic, assign) int del_user;
@property (nonatomic, assign) int is_del;
@property (nonatomic, assign) int is_self;
@property (nonatomic, assign) int is_share;
@property (nonatomic, assign) int like;
@property (nonatomic, assign) int task_day;
@property (nonatomic, assign) int vip_class;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;


@end

NS_ASSUME_NONNULL_END
