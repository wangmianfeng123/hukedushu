//
//  HKChanel.h
//  Code
//
//  Created by Ivan li on 2019/9/18.
//  Copyright © 2019 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HkChannelData : NSObject

#pragma mark -- 获取推广渠道
+ (void)requestHkChannelData;


#pragma mark - 删除渠道
+ (void)deleteHkChannelData;

@end

NS_ASSUME_NONNULL_END
