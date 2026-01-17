//
//  HKUserModel.h
//  FamousWine
//
//  Created by Administrator on 15/12/18.
//  Copyright © 2015年 pg. All rights reserved.22
//

#import <Foundation/Foundation.h>
#import "HKUserModel.h"


@interface FWUserInfoContext : NSObject

+(FWUserInfoContext *)context;
+(FWUserInfoContext *)initWithModel:(HKUserModel *)userInfoModel;
-(void)clearAll;
@property (copy, nonatomic)NSString  *userId;
@property (copy, nonatomic)NSString  *userName;
@property (copy, nonatomic)NSString  *password;
@property (copy, nonatomic)NSString  *hwUsername;
@property (copy, nonatomic)NSString  *hwPassword;
@property (copy, nonatomic)NSString  *icon;
@property (copy, nonatomic)NSString  *nickName;
@property (copy, nonatomic)NSString  *realName;
@property (copy, nonatomic)NSString  *drinkAge;
@property (copy, nonatomic)NSString  *drinkingCapacity;
@property (copy, nonatomic)NSString  *level;
@property (copy, nonatomic)NSString  *hobby;
@property (copy, nonatomic)NSString  *integral;
@property (copy, nonatomic)NSString  *accumulatedIntegral;
@property (copy, nonatomic)NSString  *invitedCode;
@property (copy, nonatomic)NSString  *sign;
@property (copy, nonatomic)NSString  *gender;
@property (copy, nonatomic)NSString  *birthday;
@property (copy, nonatomic)NSString  *mobile;
@property (copy, nonatomic)NSString  *email;
@property (copy, nonatomic)NSString  *address;
@property (copy, nonatomic)NSString  *latitude;
@property (copy, nonatomic)NSString  *longitude;
@property (copy, nonatomic)NSString  *city;
@property (copy, nonatomic)NSString  *profession;
@property (copy, nonatomic)NSString  *company;
@property (copy, nonatomic)NSString  *activated;
@property (copy, nonatomic)NSString  *deleted;
@property (copy, nonatomic)NSString  *updatedDate;
@property (copy, nonatomic)NSString  *createdDate;
@property (copy, nonatomic)NSString  *pcCount;
@property (copy, nonatomic)NSString  *mcCount;



@property(nonatomic,copy)NSString *access_token;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *avator;


@end
