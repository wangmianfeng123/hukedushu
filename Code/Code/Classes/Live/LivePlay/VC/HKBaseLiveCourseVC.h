//
//  HKBaseLiveCourseVC.h
//  Code
//
//  Created by hanchuangkeji on 2018/12/6.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMStickyPageControllerTool.h"
#import "HKLiveDetailModel.h"


NS_ASSUME_NONNULL_BEGIN

@class HKLiveCoursePlayer;

@interface HKBaseLiveCourseVC : WMStickyPageControllerTool

@property (nonatomic, copy)void(^didselectCourse)(HKLiveDetailModel *model);

@property (nonatomic, copy) void(^didSelectedRecBlock)(VideoModel *model);

@property (nonatomic , strong) void(^refreshBlock)(void);
@property (nonatomic , strong) void(^refreshBottomBlock)(HKLiveDetailModel *model);

@property (nonatomic, copy)NSString *course_id;
@property (nonatomic, weak)HKLiveCoursePlayer *topPlayerView;

@property (nonatomic, strong)HKLiveDetailModel *model;

@property(nonatomic, assign)BOOL isLocalVideo ; //标记本地视频，从本地下载过来
@property (nonatomic, copy)NSString *live_id;  //直播小节id,用于播放本地视频


@end

NS_ASSUME_NONNULL_END
