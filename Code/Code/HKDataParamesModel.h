//
//  HKDataParamesModel.h
//  Code
//
//  Created by eon Z on 2022/8/10.
//  Copyright © 2022 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKDataParamesModel : NSObject

@property (nonatomic , copy) NSString * time;
@property (nonatomic , copy) NSString * lib;
@property (nonatomic , copy) NSString * lib_version;
@property (nonatomic , copy) NSString * event_name;
@property (nonatomic , copy) NSString * client_type;
@property (nonatomic , copy) NSString * distinct_id;
@property (nonatomic , copy) NSString * app_version;
@property (nonatomic , copy) NSString * platform;
@property (nonatomic , copy) NSString * uid;
@property (nonatomic , copy) NSString * model;
@property (nonatomic , copy) NSString * os;
@property (nonatomic , copy) NSString * referrer;
@property (nonatomic , copy) NSString * os_version;
@property (nonatomic , assign) int screen_height;
@property (nonatomic , assign) int screen_width;
@property (nonatomic , copy) NSString * wifi;
@property (nonatomic , copy) NSString * carrier;

@property (nonatomic , copy)NSString * vip;
@property (nonatomic , copy)NSString * regd;


@end

NS_ASSUME_NONNULL_END
