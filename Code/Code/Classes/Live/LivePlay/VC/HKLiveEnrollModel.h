//
//  HKLiveEnrollModel.h
//  Code
//
//  Created by ivan on 2020/9/1.
//  Copyright © 2020 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKLiveEnrollModel : NSObject

//免费直播的报名或取消报名
+ (RACSignal *)signalLiveEnrollWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
