//
//  HKShortVideoMainVC+Category.h
//  Code
//
//  Created by Ivan li on 2019/3/26.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKShortVideoMainVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKShortVideoMainVC (Category)


- (void)testSemaphore;

/**
 播放时 移动流量 提醒
 
 @param sure (确定按钮 回调)
 */

- (void)playtipByWWAN:(void(^)())sureAction  cancelAction: (void(^)())cancelAction;



/** 滑动动画 */
- (void)showScorllAnimationView;


/** 双击点赞动画 */
- (void)showPraiseAnimationView;


/**
 短视频 播放记录（次数）

 @param videoId 
 */
- (void)postShortVideoPlayCount:(NSString*)videoId;

/**
 设置 短视频 每日更新提示
 */
- (void)setShortVideoUpdateCountPerDay;

@end

NS_ASSUME_NONNULL_END
