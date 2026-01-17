//
//  HKPushNoticeModel.h
//  Code
//
//  Created by Ivan li on 2021/7/22.
//  Copyright © 2021 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKPushNoticeModel : NSObject

@property (nonatomic, copy)NSString * name;  //
@property (nonatomic, copy)NSString * description;  //
@property (nonatomic, copy)NSString * key;  //
@property (nonatomic, assign)BOOL value;  //
@property (nonatomic, strong)NSNumber * j_push_hour;
@property (nonatomic, strong)NSNumber * j_push_hour_type;
@property (nonatomic, strong)NSNumber * j_push_type;

@property (nonatomic, copy)NSString * pushFrequency;  //推送频率
@property (nonatomic, copy)NSString * j_push_hour_typeString; // 00或者30

@end

NS_ASSUME_NONNULL_END
