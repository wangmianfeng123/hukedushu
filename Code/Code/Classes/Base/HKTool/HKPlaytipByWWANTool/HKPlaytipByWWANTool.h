//
//  HKPlaytipByWWANTool.h
//  Code
//
//  Created by Ivan li on 2019/6/19.
//  Copyright © 2019 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKPlaytipByWWANTool : NSObject
/** 短视频 流量播放提醒 */
+ (void)shortVideoPlaytipByWWAN:(void(^)())sureAction  cancelAction: (void(^)())cancelAction;

/** 视频详情页 流量播放提醒 */
+ (void)nomarlVideoPlaytipByWWAN:(void(^)())sureAction  cancelAction: (void(^)())cancelAction;

/** 视频详情页 流量下载提醒 */
+ (void)nomarlVideoDownloadtipByWWAN:(void(^)())sureAction  cancelAction: (void(^)())cancelAction;

@end

NS_ASSUME_NONNULL_END
