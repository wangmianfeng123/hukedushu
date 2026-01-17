//
//  HKPlayerPlayRate.h
//  Code
//
//  Created by Ivan li on 2019/12/26.
//  Copyright © 2019 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFHKNormalPlayerPlayRate : NSObject

///播放速率
+ (NSString*)normalPlayerPlayRate;

///播放速率
+ (CGFloat)normalPlayerPlayRateFloat;

///存储播放速率（编号）
+ (void)saveNormalPlayerPlayRate:(NSInteger)selected;

///播放速率 index
+ (NSInteger)normalPlayerPlayRateIndex;

/// 通过 速率字符串 返回 rate Index
+ (NSInteger)normalPlayerPlayRateIndexWithRateStr:(NSString*)rateStr;

/// 通过 Index ->  rate速率字符串
+ (NSString*)normalPlayerPlayRateWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
