//
//  HKVersionModel.m
//  Code
//
//  Created by Ivan li on 2017/12/13.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKVersionModel.h"
#import "HKOneLoginRewardView.h"

@implementation HKVersionModel

@end



@implementation HKInitConfigModel

+ (NSDictionary*)mj_replacedKeyFromPropertyName {
    
    return @{@"desc":@"description"};
}

@end





@implementation HKInitConfigManger

+ (instancetype)sharedInstance {
    
    static HKInitConfigManger *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (instancetype)init {
    if (self = [super init]) {
        // 成功登录
        HK_NOTIFICATION_ADD(HKLoginSuccessNotification, userloginSuccessNotification);
    }
    return self;
}

- (void)userloginSuccessNotification {
    [self loginGiftData];
}


#pragma mark --- 登录礼包
- (void)loginGiftData {
    [HKHttpTool POST:USER_GET_REGISTER_GIFT parameters:nil success:^(id responseObject) {
        if (HKReponseOK) {
            HKInitConfigModel *configModel = [HKInitConfigModel mj_objectWithKeyValues:responseObject[@"data"][@"giftInfo"]];
            if (!isEmpty(configModel.name)) {
                // 礼包弹窗
                [HKOneLoginRewardView showOneLoginRewardAlertViewWithFrame:CGRectZero configModel:configModel];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}


@end;
