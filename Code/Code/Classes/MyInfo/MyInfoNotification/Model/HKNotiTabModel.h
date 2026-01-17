//
//  HKNotiTabModel.h
//  Code
//
//  Created by Ivan li on 2021/1/27.
//  Copyright © 2021 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class HKOriginalUserModel,HKOriginalModel,HomeAdvertModel;

@interface HKNotiTabModel : NSObject

@property (nonatomic, strong)NSNumber * ID;  //
@property (nonatomic, copy)NSString * name;  //
@property (nonatomic, strong)NSNumber * unread;  //

@end



@interface HKNotiMessageModel : NSObject
@property (nonatomic, copy)NSString * ID;  //
@property (nonatomic, copy)NSString * uid;  //
@property (nonatomic, copy)NSString * original_id;  //
@property (nonatomic, copy)NSString * original_type;  //
@property (nonatomic, copy)NSString * connect_id;  //
@property (nonatomic, copy)NSString * connect_uid;  //
@property (nonatomic, copy)NSString * connect_type;  //
@property (nonatomic, strong)NSNumber * is_read;  //
@property (nonatomic, copy)NSString * created_at;  //
@property (nonatomic, copy)NSString * contextSuffix;  //提醒关联字符串后缀
@property (nonatomic, copy)NSString * contextPrefix;  //提醒关联字符串前缀
@property (nonatomic , assign) BOOL isSubscribe ; //判断是否显示关注按钮

@property (nonatomic , strong) HKOriginalUserModel * originalUser;//被提醒用户信息
@property (nonatomic , strong) HKOriginalModel * original; //被提醒用户内容
@property (nonatomic , strong) HKOriginalUserModel * connectUser; //触发提醒用户信息
@property (nonatomic , strong) HKOriginalModel * connect; //触发提醒用户内容/动作
@end


@interface HKOriginalUserModel : NSObject
@property (nonatomic, copy)NSString * uid;  //
@property (nonatomic, copy)NSString * avatar;  //
@property (nonatomic, copy)NSString * username;  //
@property (nonatomic, assign)BOOL isSubscribed;  //有没有关注

@end

@interface HKOriginalModel : NSObject
@property (nonatomic, copy)NSString * ID;  //
@property (nonatomic, copy)NSString * topic_id;  //
@property (nonatomic, copy)NSString * content;  //
@property (nonatomic, copy)NSString * context;  //
@property (nonatomic, assign)BOOL isLiked;  //
//@property (nonatomic, strong)NSArray * redirectPackage;  //
@property (nonatomic,strong) HomeAdvertModel * redirectPackage;


@end


@interface HKSystemNotiMsgModel : NSObject
@property (nonatomic, copy)NSString * title;  //
@property (nonatomic, copy)NSString * sub_title;  //
@property (nonatomic, copy)NSString * url;  //
@property (nonatomic ,copy) NSString * created_at;
@end


NS_ASSUME_NONNULL_END
