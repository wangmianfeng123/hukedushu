//
//  HKShortVideoControlView.h
//  Code
//
//  Created by Ivan li on 2019/3/25.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFHKNormalPlayer.h"


@class HKShortVideoModel;

NS_ASSUME_NONNULL_BEGIN


@protocol HKShortVideoControlViewDelegate <NSObject>

@optional
/** 登录 */
- (void)hkShortVideoControlView:(UIView*)view login:(BOOL)login;

- (void)hkShortVideoControlView:(UIView*)view videoPlayer:(ZFHKNormalPlayerController *)videoPlayer playStateChanged:(ZFHKNormalPlayerPlaybackState)state;

@end



@interface HKShortVideoControlView : UIView <ZFPlayerMediaControl>

- (void)resetControlView;

- (void)showCoverViewWithUrl:(NSString *)coverUrl;

/** 双击回调 */
@property(nonatomic,copy) void (^gestureDoubleCallback) ();

@property(nonatomic,copy) void (^wiFiplayCallback) ();

@property (nonatomic, weak)id <HKShortVideoControlViewDelegate> delegate;

@property (nonatomic, strong)HKShortVideoModel *videoModel;

/**
 播放时长
 @return 时长 秒
 */
- (NSTimeInterval)playVideoTime;

/** 重置播放计时 */
- (void)resetProgressTimer;

@end

NS_ASSUME_NONNULL_END





