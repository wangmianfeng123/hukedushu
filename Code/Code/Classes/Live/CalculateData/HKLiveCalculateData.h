//
//  HKLiveCalculateData.h
//  Code
//
//  Created by hanchuangkeji on 2019/3/19.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKLiveCalculateData : NSObject

+ (instancetype)shareInstance;

- (void)eachHourLiveData;

@end

NS_ASSUME_NONNULL_END
