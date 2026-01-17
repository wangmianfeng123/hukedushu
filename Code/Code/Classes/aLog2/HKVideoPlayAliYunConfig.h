//
//  HKVideoPlayAliYunConfig.h
//  Code
//
//  Created by Ivan li on 2019/8/29.
//  Copyright © 2019 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 视频播放 阿里云 统计
 */
@interface HKVideoPlayAliYunConfig : NSObject

//btn_id  1 视频播放 2 视频详情页收藏 3 视频详情页下载 4 虎课读书播放 5 个人中心 (去登录标签) 6 个人中心头像 14首页底部悬浮登录 15新手任务的弹窗入口
@property(nonatomic,assign)NSInteger btnID;

//show_type 1 弹窗触发 2 登录成功
@property(nonatomic,assign)NSInteger showType;

// 16 首页推荐视频曝光  17 首页推荐视频点击  18 首页推荐视频播放
@property(nonatomic,assign)NSInteger btn_type;
@property(nonatomic,assign)NSInteger btn_id;



+ (instancetype)sharedInstance;

+ (void)hkVideoPlayAliYunConfig:(NSInteger)btnID  showType:(NSInteger)showType;

//统计阿里云统计-首页推荐视频 曝光 点击 播放
+ (void)videoPlayAliYunVideoID:(NSString *)videoID btn_type:(NSInteger)btn_type;

@end

NS_ASSUME_NONNULL_END
