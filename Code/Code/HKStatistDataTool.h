//
//  HKStatistDataTool.h
//  Code
//
//  Created by eon Z on 2022/8/10.
//  Copyright © 2022 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HKVideoPlayParamesModel,HKPageVisitParamesModel,HKClickParamesModel;

@interface HKStatistDataTool : NSObject

@property(nonatomic, copy) NSString * uuid;

+ (instancetype)sharedInstance;

//视频播放统计
+ (void)reportVideoPlayData:(HKVideoPlayParamesModel *)model;

//页面统计
+ (void)reportPageVisitPage_title:(NSString *)page_title;

//点击事件
//+ (void)reportClickEventDataRoute:(NSString *)route module:(NSInteger )module;
//+ (void)reportClickEventDataRoute:(NSString *)route module:(NSInteger )module position:(NSInteger )position;
//+ (void)reportClickEventDataRoute:(NSString *)route module:(NSInteger )module position:(NSInteger )position paramDics:(NSMutableDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
