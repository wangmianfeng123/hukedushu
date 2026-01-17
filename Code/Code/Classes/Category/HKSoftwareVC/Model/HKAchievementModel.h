//
//  HKAchievementModel.h
//  Code
//
//  Created by ivan on 2020/8/25.
//  Copyright © 2020 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HKMapModel;

NS_ASSUME_NONNULL_BEGIN

@interface HKAchievementModel : NSObject

@property(nonatomic, copy)NSString  *name;

@property(nonatomic, copy)NSString  *route_id;

@property(nonatomic, copy)NSString  *username;

@property(nonatomic, strong)HKMapModel *redirect;

@end

NS_ASSUME_NONNULL_END
