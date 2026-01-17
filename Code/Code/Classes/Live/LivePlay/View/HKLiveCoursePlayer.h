//
//  HKLiveCoursePlayerCell.h
//  Code
//
//  Created by hanchuangkeji on 2018/10/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKLiveListModel.h"
#import "HKLiveDetailModel.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFIJKPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import "UIImageView+ZFCache.h"
#import "ZFUtilities.h"
#import "HKLivePlayerInfoView.h"
#import "HKPlayBackPlayerControlView.h"


NS_ASSUME_NONNULL_BEGIN

@class HKLivePlayerInfoView,HKPermissionVideoModel;

@interface HKLiveCoursePlayer : UIView

// 播放器
@property (nonatomic, strong,nullable) ZFPlayerController *player;

@property (nonatomic, strong) HKLivePlayerInfoView *playInfoView;

@property (nonatomic, strong)HKLiveDetailModel *model;

@property (nonatomic, strong) HKPlayBackPlayerControlView *controlView;

@property (nonatomic, copy)void(^backBtnClickBlock)();

@property (nonatomic, copy)void(^shareBtnClickBlock)();

@property (nonatomic, copy)void(^middleBtnClickBlock)();

@property (nonatomic, copy)void(^livingBtnClickBlock)();

@property (nonatomic, copy)void(^countdownEndDataBlock)();

@property (nonatomic, copy)void(^resolutionActionBlock)(CGFloat rate);

@property (nonatomic, copy)void(^playerPlayStateChanged)(ZFPlayerPlaybackState playState);
/** 投屏*/
@property (nonatomic, copy)void(^airPlayGuideVCBlock) (BOOL fullScreen);

@property (nonatomic, strong) HKPermissionVideoModel * permissionModel;//视频信息
@property (nonatomic, assign) NSInteger    seekTime;

@end

NS_ASSUME_NONNULL_END
