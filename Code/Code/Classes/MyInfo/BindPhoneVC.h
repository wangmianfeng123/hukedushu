//
//  BindPhoneVC.h
//  Code
//
//  Created by Ivan li on 2017/9/1.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKBaseVC.h"

@interface BindPhoneVC : HKBaseVC

@property(nonatomic,strong)HKUserModel  *userInfoModel;
/** 0 - 普通绑定。 1- 登录受限绑定  */
@property(nonatomic,assign)HKBindPhoneType bindPhoneType;

@property(nonatomic,copy)void(^bindPhoneBlock)(NSString *phone);

@end
