//
//  FWUserInfoContext.m
//  FamousWine
//
//  Created by Administrator on 15/12/18.
//  Copyright © 2015年 pg. All rights reserved.
//

#import "FWUserInfoContext.h"

static FWUserInfoContext* context;

@implementation FWUserInfoContext
//@synthesize userName,userID,passWord;


-(id)init{
    self = [super init];
    if (self){
    }
    return self;
}



+(FWUserInfoContext*) context
{
    if (!context) {
        @synchronized(self){
            if(!context) {
                context = [[FWUserInfoContext alloc] init];
            }
        }
    }
    return context;
}



+ (FWUserInfoContext *)initWithModel:(HKUserModel *)userInfoModel
{
    if (!context) {
        @synchronized(self){
            if (!context) {
                context = [[FWUserInfoContext alloc] init];
            }
        }
    }
    
    context.access_token   = userInfoModel.access_token;
    context.ID   = userInfoModel.ID;
    context.username   = userInfoModel.username;
    context.avator   = userInfoModel.avator;
    
//    context.userId   = userInfoModel.userId;
//    context.userName = userInfoModel.userName;
//    context.password = userInfoModel.password;
//    context.hwUsername = userInfoModel.hwUsername;
//    context.hwPassword = userInfoModel.hwPassword;
//    context.icon = userInfoModel.icon;
//    context.nickName=userInfoModel.nickName;
//    context.realName=userInfoModel.realName;
//    context.drinkAge=userInfoModel.drinkAge;
//    context.drinkingCapacity=userInfoModel.drinkingCapacity;
//    context.level=userInfoModel.level;
//    context.hobby=userInfoModel.hobby;
//    context.integral=userInfoModel.integral;
//    context.accumulatedIntegral=userInfoModel.accumulatedIntegral;
//    context.invitedCode=userInfoModel.invitedCode;
//    context.sign=userInfoModel.sign;
//    context.gender=userInfoModel.gender;
//    context.birthday=userInfoModel.birthday;
//    context.mobile=userInfoModel.mobile;
//    context.email=userInfoModel.email;
//    context.address=userInfoModel.address;
//    context.latitude=userInfoModel.latitude;
//    context.longitude=userInfoModel.longitude;
//    context.city=userInfoModel.city;
//    context.profession=userInfoModel.profession;
//    context.company=userInfoModel.company;
//    context.activated=userInfoModel.activated;
//    context.deleted=userInfoModel.deleted;
//    context.updatedDate=userInfoModel.updatedDate;
//    context.createdDate=userInfoModel.createdDate;
    return context;
}




-(void)clearAll
{
    self.userName = nil;
    self.userId = nil;
    self.password = nil;
    self.hwUsername = nil;
    self.hwPassword = nil;
    self.icon = nil;
    self.nickName = nil;
    self.realName = nil;
    self.drinkAge = nil;
    self.drinkingCapacity = nil;
    self.level = nil;
    self.hobby = nil;
    self.integral = nil;
    self.accumulatedIntegral = nil;
    self.invitedCode = nil;
    self.sign = nil;
    self.gender = nil;
    self.birthday = nil;
    self.mobile = nil;
    self.email = nil;
    self.address = nil;
    self.latitude = nil;
    self.longitude = nil;
    self.city = nil;
    self.profession = nil;
    self.company = nil;
    self.activated = nil;
    self.deleted = nil;
    self.updatedDate = nil;
    self.createdDate = nil;
    self.pcCount = nil;
    self.mcCount = nil;
    
    
    self.access_token = nil;
    self.ID = nil;
    self.username = nil;
    self.avator = nil;
    
    
}

@end
