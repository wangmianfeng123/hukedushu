//
//  ZFNormalPlayerControlView.m
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ZFNormalPlayerControlView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIView+CustomControlView.h"
#import "MMMaterialDesignSpinner.h"
#import "HKDownloadManager.h"

//add   0908
#import "HKPermissionVideoModel.h"
#import "DownloadCacher.h"
#import "VideoModel.h"

#import "HKNextVideoCountDownView.h"
#import "DetailModel.h"
#import "HKZFNormalPlayerShareBtn.h"
#import "HKPlayTimeTipView.h"
#import "HKPlayMaterialTipView.h"
#import "HKPlayerResolutionBtn.h"

#import <QuartzCore/QuartzCore.h>
#import "NSString+MD5.h"
#import "HKPlayerCollectionView.h"
#import "HKPlayerSimilarVideoCell.h"
#import "HKPlayerFullScreenSimilarVideoView.h"
  
#import "UIView+SNFoundation.h"
#import "UIButton+ImageTitleSpace.h"
#import "HKPlayerBuyVipView.h"
#import "HKPlayerAutoPlayConfigView.h"
#import "HKAutoPlayTipIView.h"
#import "HKLivingSpeedLoadingView.h"



#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

static const CGFloat ZFNormalPlayerAnimationTimeInterval             = 5.5f;//7.0f;modify 0903
static const CGFloat ZFNormalPlayerControlBarAutoFadeOutTimeInterval = 0.5f; //1.5f;//0.35f; modify 0903

@interface ZFNormalPlayerControlView () <UIGestureRecognizerDelegate,HKNextVideoCountDownViewDelegate,HKZFNormalPlayerShareBtnDelegate,HKPlayTimeTipViewDelegate,MZTimerLabelDelegate,HKPlayerFullScreenSimilarVideoDelegate,HKPlayerSimilarVideoCellDelagate,HKBuyVipViewDelegate,HKPlayerAutoPlayConfigViewDelegate,HKAutoPlayTipIViewDelegate>

/** 标题 */
@property (nonatomic, strong) UILabel                 *titleLabel;
///** 开始播放按钮 */
//@property (nonatomic, strong) UIButton                *startBtn;
/** 当前播放时长label */
@property (nonatomic, strong) UILabel                 *currentTimeLabel;
/** 视频总时长label */
@property (nonatomic, strong) UILabel                 *totalTimeLabel;
/** 缓冲进度条 */
@property (nonatomic, strong) UIProgressView          *progressView;
/** 滑杆 */
@property (nonatomic, strong) ASValueTrackingSlider   *videoSlider;
///** 全屏按钮 */
//@property (nonatomic, strong) UIButton                *fullScreenBtn;
/** 锁定屏幕方向按钮 */
@property (nonatomic, strong) UIButton                *lockBtn;
/** 系统菊花 */
@property (nonatomic, strong) HKLivingSpeedLoadingView *activity;
//@property (nonatomic, strong) MMMaterialDesignSpinner *activity;
/** 返回按钮*/
@property (nonatomic, strong) UIButton                *backBtn;
/** 关闭按钮*/
@property (nonatomic, strong) UIButton                *closeBtn;
/** 重播按钮 */
@property (nonatomic, strong) UIButton                *repeatBtn;
/** bottomView*/
@property (nonatomic, strong) UIImageView             *bottomImageView;
/** topView */
@property (nonatomic, strong) UIImageView             *topImageView;
/** 缓存按钮 */
@property (nonatomic, strong) UIButton                *downLoadBtn;
/** 切换分辨率按钮 */
@property (nonatomic, strong) UIButton                *resolutionBtn;
/** 自动播放配置 按钮 */
@property (nonatomic, strong) UIButton                *autoPlayConfigBtn;
/** 自动播放配置 */
@property (nonatomic, strong)HKPlayerAutoPlayConfigView *autoPlayConfigView;

//@property (nonatomic, strong) HKPlayerResolutionBtn                *resolutionBtn;

/** 分辨率的View */
@property (nonatomic, strong) UIView                  *resolutionView;
///** 播放按钮 */
@property (nonatomic, strong) UIButton                *playeBtn;
/** 加载失败按钮 */
@property (nonatomic, strong) UIButton                *failBtn;
/** 快进快退View*/
@property (nonatomic, strong) UIView                  *fastView;
/** 快进快退进度progress*/
@property (nonatomic, strong) UIProgressView          *fastProgressView;
/** 快进快退时间*/
@property (nonatomic, strong) UILabel                 *fastTimeLabel;
/** 快进快退ImageView*/
@property (nonatomic, strong) UIImageView             *fastImageView;
/** 当前选中的分辨率btn按钮 */
@property (nonatomic, weak  ) UIButton                *resoultionCurrentBtn;
/** 占位图 */
//@property (nonatomic, strong) UIImageView             *placeholderImageView;
@property (nonatomic, strong) UIImageView             *placeholderImageView;

/** 控制层消失时候在底部显示的播放进度progress */
@property (nonatomic, strong) UIProgressView          *bottomProgressView;
/** 分辨率的名称 */
@property (nonatomic, strong) NSArray                *resolutionArray;

/** 显示控制层 */
@property (nonatomic, assign, getter=isShowing) BOOL  showing;
/** 小屏播放 */
@property (nonatomic, assign, getter=isShrink ) BOOL  shrink;
/** 在cell上播放 */
@property (nonatomic, assign, getter=isCellVideo)BOOL cellVideo;
/** 是否拖拽slider控制播放进度 */
@property (nonatomic, assign, getter=isDragged) BOOL  dragged;
/** 是否播放结束 */
@property (nonatomic, assign, getter=isPlayEnd) BOOL  playeEnd;
/** 是否全屏播放 */
@property (nonatomic, assign,getter=isFullScreen)BOOL fullScreen;
/** 是否获取到进度 */
@property (atomic, assign,getter=isGetProgress)BOOL getProgress;


// 标记是否是第一次播放
typedef enum {
    LookStatusOnce = 0,
    LookStatusTwo = 1,
}LookStatus;

// 标记是否是第一次查询VIP
typedef enum {
    CheckVipStatusOnce = 0,
    CheckVipStatusTwo = 1,
}CheckVipStatus;


// 标记是否是第一次查询 视频 的缓存状态
typedef enum {
    CheckVideoStatusOnce = 0,
    CheckVideoStatusTwo = 1,
}CheckVideoStatus;

//--------------add yang----------------//
@property (nonatomic, strong)HKPermissionVideoModel *permissionVideoModel;

@property (atomic, assign) LookStatus lookStatus;

@property (atomic, assign) CheckVipStatus checkVipStatus;

@property (atomic, assign) CheckVideoStatus checkVideoStatus;

/** 设置倒计时 提示  1212 */
@property (nonatomic, strong)HKNextVideoCountDownView *countdownView;
/** 分享解锁视频按钮 */
//@property (nonatomic, strong)HKZFNormalPlayerShareBtn *playerShareBtn;
/** 上一次观看时间 提示 */
@property (nonatomic, strong)HKPlayTimeTipView *timeTipView;
/** 是否已经显示 观看时间 YES - 已显示 */
@property (atomic, assign)BOOL isShowPlayTimeTip;
/** 素材下载 提示 */
@property (nonatomic, strong)HKPlayMaterialTipView *materialTipView;
/** 素材下载提示 计时器 */
@property (nonatomic, strong) MZTimerLabel   *materialTimerLabel;
/** 是否已经显示 素材下载提示  YES - 已显示 */
@property (atomic, assign)BOOL isShowMaterialTip;

@property (atomic, assign)BOOL isFirst;

@property (nonatomic, strong)CAShapeLayer *borderLayer;

@property (nonatomic, strong) ZFNormalPlayerModel  *playerModel;

@property (nonatomic,strong) UIView *collectionBgView;

@property (nonatomic,strong) HKPlayerSimilarVideoCell *playerSimilarVideoCell;

@property (nonatomic,strong) NSMutableArray *similarVideoArray;

/** 竖直 相似推荐 */
@property (nonatomic,strong) HKPlayerSimilarVideoCell *verticalSimilarVideoView;
/** 全屏 相似推荐 */
@property (nonatomic,strong) HKPlayerFullScreenSimilarVideoView *fullScreenSimilarVideoView;

@property (nonatomic,strong)HKAutoPlayTipIView *autoPlayTipIView;
/** YES - 已显示 */
@property (atomic, assign) BOOL isShowAutoPlayTip;

//--------------add yang----------------//





@end

@implementation ZFNormalPlayerControlView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self addSubview:self.watchLabel];
        [self addSubview:self.materialTimerLabel];
        
        self.checkVipStatus = CheckVipStatusOnce;
        self.checkVideoStatus = CheckVideoStatusOnce;
        
        [self addSubview:self.placeholderImageView];
        [self addSubview:self.topImageView];
        [self addSubview:self.bottomImageView];
        [self.bottomImageView addSubview:self.startBtn];
        [self.bottomImageView addSubview:self.currentTimeLabel];
        [self.bottomImageView addSubview:self.progressView];
        [self.bottomImageView addSubview:self.videoSlider];
        [self.bottomImageView addSubview:self.fullScreenBtn];
        [self.bottomImageView addSubview:self.totalTimeLabel];
        
        [self.topImageView addSubview:self.downLoadBtn];
        [self addSubview:self.lockBtn];
        [self.topImageView addSubview:self.backBtn];
        [self addSubview:self.activity];
        [self addSubview:self.repeatBtn];
        [self addSubview:self.playeBtn];
        [self addSubview:self.failBtn];
        
        [self addSubview:self.fastView];
        [self.fastView addSubview:self.fastImageView];
        [self.fastView addSubview:self.fastTimeLabel];
        [self.fastView addSubview:self.fastProgressView];
        
        [self.topImageView addSubview:self.resolutionBtn];
        [self.topImageView addSubview:self.titleLabel];
        [self addSubview:self.closeBtn];
        [self addSubview:self.bottomProgressView];
        
        
        /**************0903***********/
        
        [self addSubview:self.lookCountTipLabel];
        [self addSubview:self.bottomVipBtn];
        //图文按钮
        [self addSubview:self.centerGraphicBtn];
        [self.topImageView addSubview:self.topGraphicBtn];
        //自动播放
        [self.topImageView addSubview:self.autoPlayConfigBtn];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(lookPermissionsNotification:)
                                                     name:KLookPermissionsNotification object:self];
        
        /*****************************/
        // 添加子控件的约束
        [self makeSubViewsConstraints];
    
        self.downLoadBtn.hidden    = YES;
        self.resolutionBtn.hidden   = YES;
        // 初始化时重置controlView
        [self zf_playerResetControlView];
        // app退到后台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
        // app进入前台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayground) name:UIApplicationDidBecomeActiveNotification object:nil];

        [self listeningRotating];
        [self showControlView]; // add yang 显示控制层
        // 初始化 倍速 视图
        [self zf_playerResolutionArray:nil];
        //add 0402
        [self setResolutionBtnCorner:YES];
        
        self.isShowAutoPlayTip = [HKNSUserDefaults boolForKey:@"HKAutoPlayTipIView"];
        
    }
    return self;
}


- (void)dealloc {
    
    if (self.materialTimerLabel) { [self.materialTimerLabel pause]; }
    TTVIEW_RELEASE_SAFELY(self.materialTimerLabel);
    
    HK_NOTIFICATION_REMOVE();
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}


/***********************  设置倒计时 提示  1212  ***********************/

- (HKNextVideoCountDownView*)countdownView {
    if (!_countdownView) {
        _countdownView = [[HKNextVideoCountDownView alloc]init];
        _countdownView.delegate = self;
        _countdownView.detailModel = self.detailModel;
    }
    return _countdownView;
}


/** 到计时提示 播放下一节视频 */
- (void)setTimeTip {

    NSString * nextId = _detailModel.next_video_info.video_id;
    if (!isEmpty(nextId) && ![nextId isEqualToString:@"0"]) {
        [self addSubview:self.countdownView];
        [self.countdownView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
}


- (void)playNextVideo:(id)sender iskillTime:(BOOL)iskillTime {
    //iskillTime -- yes   只是关闭定时器。 NO --  关闭定时器 并 跳转
    if (iskillTime) {
        
    }else{
        if([self.delegate respondsToSelector:@selector(zf_controlView:nextVideoAction:)]){
            [self.delegate zf_controlView:nil nextVideoAction:self.detailModel];
        }
    }
    TTVIEW_RELEASE_SAFELY(_countdownView);
}

/***********************  设置倒计时 提示  1212  ***********************/


#pragma mark - 创建 无观看权限 提示购买VIP 视图
- (void)setBuyVipView {
    
    UIView *buyVipView = [self viewWithTag:1000];
    if (buyVipView == nil) {
        //未创建
        [self makeBuyVipBgConstraints];
        self.bottomImageView.hidden = !self.bottomImageView.hidden;
        if (!isEmpty(self.detailModel.pictext_url)) {
            self.centerGraphicBtn.hidden = !self.centerGraphicBtn.hidden;
        }
    }
}


#pragma mark - 移除购买VIP
- (void)removeBuyVipView {
    UIView *buyVipView = [self viewWithTag:1000];
    if (nil != buyVipView) {
        self.bottomImageView.hidden = !self.bottomImageView.hidden;
        if (!isEmpty(self.detailModel.pictext_url)) {
            self.centerGraphicBtn.hidden = !self.centerGraphicBtn.hidden;
        }
        TTVIEW_RELEASE_SAFELY(self.buyVipBgView);
    }
}


- (void)makeBuyVipBgConstraints {
    
    [self insertSubview:self.buyVipBgView belowSubview:self.topImageView];
    [self.buyVipBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


/** 创建 时间 提示视图 和约束 */
- (void)makeTimeViewAndConstraints {
    
    if (self.playerModel.seekTime >0) {
        if (!self.isShowPlayTimeTip) {
            [self addSubview:self.timeTipView];
            [self.timeTipView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.mas_bottom).offset(-PADDING_35);
                make.left.equalTo(self.mas_left).offset(PADDING_15);
                make.size.mas_equalTo(CGSizeMake(370/2 + [self timeWordWidth], 30));
            }];
            self.isShowPlayTimeTip = YES;
        }
    }
}


/** 计算 时间 字符串 宽度 */
- (float)timeWordWidth {
    ZFNormalPlayerModel *model = self.playerModel;
    float width = 0;
    if (model.seekTime >0) {
        NSString *time = nil;
        if (self.playerModel.seekTime >59) {
            NSInteger min = model.seekTime/60;
            NSInteger sec = model.seekTime%60;
            if (sec>0) {
                time = [NSString stringWithFormat:@"%ld分%ld秒",min,sec];
            }else {
                time = [NSString stringWithFormat:@"%ld分",min];
            }
        }else{
            time = [NSString stringWithFormat:@"%ld秒",model.seekTime];
        }
        width = [time sizeWithFont:HK_FONT_SYSTEM(12) maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
        // 网络视频才可以 跳转下一节 ,从下载列表来的 不能跳转
        if ([model.detailModel.video_down_status isEqualToString:@"1"]) {
            NSString *nextId = model.detailModel.next_video_info.video_id;
            if (!isEmpty(nextId) && ![nextId isEqualToString:@"0"]) {
                width += 60;
            }
        }
    }
    return width;
}


/**创建 下载 提示视图 和约束 */
- (void)makeMaterialTipViewAndConstraints {
    [self addSubview:self.materialTipView];
    [self.materialTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-PADDING_35);
        make.right.equalTo(self.mas_right).offset(-PADDING_15);
        make.size.mas_equalTo(CGSizeMake(510/2, 110/2));
    }];
}




- (void)makeSubViewsConstraints {
    
    [self.watchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10, 10));
        make.center.equalTo(self);
    }];
    
    [self.placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IS_IPHONE_X) {
            if (@available(iOS 11.0,*)) {
                make.left.equalTo(self.mas_safeAreaLayoutGuideLeft);
                make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
                make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
                make.top.equalTo(self.mas_safeAreaLayoutGuideTop);
            }
        }else{
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.mas_trailing).offset(7);
        make.top.equalTo(self.mas_top).offset(-7);
        make.width.height.mas_equalTo(20);
    }];
    
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (IS_IPHONE_X) {
            if (@available(iOS 11.0,*)) {
                make.left.equalTo(self.mas_safeAreaLayoutGuideLeft);
                make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
                make.top.equalTo(self.mas_safeAreaLayoutGuideTop);
            }
        }else{
            make.leading.trailing.equalTo(self);
            make.top.equalTo(self.mas_top).offset(0);
        }
        make.height.mas_equalTo(70);
    }];
    
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.topImageView.mas_leading).offset(PADDING_15);
        make.centerY.equalTo(self.topImageView);
        //make.top.equalTo(self.topImageView.mas_top).offset(IS_IPHONE_X ?PADDING_25 :PADDING_15);
        //make.width.height.mas_equalTo(50);
    }];

    [self.downLoadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(49);
        make.trailing.equalTo(self.topImageView.mas_trailing).offset(-10);
        make.centerY.equalTo(self.backBtn.mas_centerY);
    }];

    [self.resolutionBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.size.mas_equalTo(IS_IPHONE6PLUS ?CGSizeMake(40, 20): CGSizeMake(37, 18));
        make.right.equalTo(self.autoPlayConfigBtn.mas_left).offset(-35/2);
        make.centerY.equalTo(self.backBtn.mas_centerY);
    }];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.backBtn.mas_trailing).offset(15);
        make.centerY.equalTo(self.backBtn.mas_centerY);
        make.width.mas_lessThanOrEqualTo(300);
        //make.trailing.equalTo(self.resolutionBtn.mas_leading).offset(-10);
    }];
    
    
    //------------------ add 0903------------------//
    [self.lookCountTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.leading.trailing.bottom.mas_equalTo(0);
        //make.right.equalTo(self.bottomVipBtn.mas_left).offset(5);
        make.leading.mas_equalTo(20);
        make.bottom.mas_equalTo(-5);
        make.height.mas_equalTo(20);
    }];
    
    [self.bottomVipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(60);
    }];
    
    //----------------- add 0903 ----------------//
    
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {

        if (IS_IPHONE_X) {
            if (@available(iOS 11.0,*)) {
                make.left.equalTo(self.mas_safeAreaLayoutGuideLeft);
                make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
                make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
            }
        }else{
            make.leading.trailing.bottom.mas_equalTo(0);
        }
        make.height.mas_equalTo(50);
    }];
    
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomImageView.mas_leading).offset(10);//.offset(5);
        make.bottom.equalTo(self.bottomImageView.mas_bottom).offset(-5);
        make.width.height.mas_equalTo(35);
    }];
    
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.startBtn.mas_trailing).offset(3);//offset(-3);
        make.centerY.equalTo(self.startBtn.mas_centerY);
        make.width.mas_equalTo(43);
    }];
    
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.trailing.equalTo(self.bottomImageView.mas_trailing).offset(0);//.offset(-5);
        make.centerY.equalTo(self.startBtn.mas_centerY);
    }];
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.fullScreenBtn.mas_leading).offset(3);
        make.centerY.equalTo(self.startBtn.mas_centerY);
        make.width.mas_equalTo(43);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(4);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-4);
        make.centerY.equalTo(self.startBtn.mas_centerY);
    }];
    
    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(4);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-4);
        make.centerY.equalTo(self.currentTimeLabel.mas_centerY).offset(-1);
        make.height.mas_equalTo(30);
    }];
    
    [self.lockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backBtn);
        make.centerY.equalTo(self.mas_centerY);
        //make.leading.equalTo(self.mas_leading).offset(IS_IPHONE_X?35:15);
        //make.width.height.mas_equalTo(45);
    }];
    
    [self.repeatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.center.equalTo(self.placeholderImageView);
    }];
    
    [self.playeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.width.height.mas_equalTo(55);
        make.center.equalTo(self.placeholderImageView);
    }];
    
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.placeholderImageView);
        make.width.with.height.mas_equalTo(80);
        //make.centerX.equalTo(self);
        //make.centerY.equalTo(self.mas_centerY).offset(10);
        //make.width.with.height.mas_equalTo(30);
    }];
    
    
    [self.failBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.placeholderImageView);
        //make.width.mas_equalTo(130);
        make.width.mas_equalTo(250); //modify  yang
        make.height.mas_equalTo(33);
    }];
    
    [self.fastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(125);
        make.height.mas_equalTo(80);
        make.center.equalTo(self.placeholderImageView);
    }];
    
    [self.fastImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(32);
        make.height.mas_offset(32);
        make.top.mas_equalTo(5);
        make.centerX.mas_equalTo(self.fastView.mas_centerX);
    }];
    
    [self.fastTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.with.trailing.mas_equalTo(0);
        make.top.mas_equalTo(self.fastImageView.mas_bottom).offset(2);
    }];
    
    [self.fastProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(12);
        make.trailing.mas_equalTo(-12);
        make.top.mas_equalTo(self.fastTimeLabel.mas_bottom).offset(10);
    }];
    
    [self.bottomProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
    [self.centerGraphicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(self.placeholderImageView);
    }];
    
    [self.topGraphicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self.resolutionBtn);
        make.right.equalTo(self.resolutionBtn.mas_left).offset(-PADDING_15);
        //make.centerY.equalTo(self.resolutionBtn);
        //make.height.greaterThanOrEqualTo(self.resolutionBtn).offset(1.5);
    }];
}




- (void)layoutSubviews {
    [super layoutSubviews];
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (currentOrientation == UIDeviceOrientationPortrait) {
        [self setOrientationPortraitConstraint];
    } else {
        [self setOrientationLandscapeConstraint];
    }

    /** 推荐视频显示 */
    [self setDeviceChangeSimilarVideoView];
    // 标题
    self.titleLabel.hidden = !self.isFullScreen;
    
    [self remakePlayConfigBtnConstraints];
}

#pragma mark - Action

/**
 *  点击切换分别率按钮
 */
- (void)changeResolution:(UIButton *)sender {
    if (![sender isKindOfClass:[UIButton class]]) return;
    sender.selected = YES;
    if (sender.isSelected) {
//        sender.backgroundColor = RGBA(86, 143, 232, 1);
        
    } else {
//        sender.backgroundColor = [UIColor clearColor];
    }
    self.resoultionCurrentBtn.selected = NO;
    self.resoultionCurrentBtn.backgroundColor = [UIColor clearColor];
    self.resoultionCurrentBtn = sender;
    
    // 隐藏分辨率View
    self.resolutionView.hidden  = YES;
    // 分辨率Btn改为normal状态
    self.resolutionBtn.selected = NO;
    // topImageView上的按钮的文字
    [self.resolutionBtn setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    NSLog(@"------ %@",self.delegate);
    if ([self.delegate respondsToSelector:@selector(zf_controlView:resolutionAction:)]) {
        [self savePlayRate:(sender.tag - 200)+1];
        [self.delegate zf_controlView:self resolutionAction:sender];
        //友盟倍速统计事件
        [MobClick event:UM_RECORD_DETAIL_PAGE_SPEED];
    }
    
    // add 0402
    self.resolutionBtn.backgroundColor = [UIColor clearColor];
    [self setResolutionBtnCorner:NO];
}


//存储播放速率（编号）
- (void)savePlayRate:(NSInteger)selected {
    NSInteger state = [HKNSUserDefaults integerForKey:HKRatePlay];
    if (0 == state) {
        [HKNSUserDefaults setInteger:selected forKey:HKPlayerPlayRate];
        [HKNSUserDefaults synchronize];
    }
}


/**
 *  UISlider TapAction
 */
- (void)tapSliderAction:(UITapGestureRecognizer *)tap {
    if ([tap.view isKindOfClass:[UISlider class]]) {
        UISlider *slider = (UISlider *)tap.view;
        CGPoint point = [tap locationInView:slider];
        CGFloat length = slider.frame.size.width;
        // 视频跳转的value
        CGFloat tapValue = point.x / length;
        if ([self.delegate respondsToSelector:@selector(zf_controlView:progressSliderTap:)]) {
            [self.delegate zf_controlView:self progressSliderTap:tapValue];
        }
    }
}
// 不做处理，只是为了滑动slider其他地方不响应其他手势
- (void)panRecognizer:(UIPanGestureRecognizer *)sender {}

- (void)backBtnClick:(UIButton *)sender {
    // 状态条的方向旋转的方向,来判断当前屏幕的方向
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    // 在cell上并且是竖屏时候响应关闭事件
    if (self.isCellVideo && orientation == UIInterfaceOrientationPortrait) {
        if ([self.delegate respondsToSelector:@selector(zf_controlView:closeAction:)]) {
            [self.delegate zf_controlView:self closeAction:sender];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(zf_controlView:backAction:)]) {
            [self.delegate zf_controlView:self backAction:sender];
        }
    }
}

- (void)lockScrrenBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.showing = NO;
    [self zf_playerShowControlView];
    if ([self.delegate respondsToSelector:@selector(zf_controlView:lockScreenAction:)]) {
        [self.delegate zf_controlView:self lockScreenAction:sender];
    }
}


- (void)playBtnClick:(UIButton *)sender {
    
#pragma mark - 查询 观看权限
//    sender.selected = !sender.selected;  //modify yang
    // add 1231 隐藏切换分辨率视图
    if (_resolutionView) {
        _resolutionView.hidden = YES;
    }
    //隐藏中间播放按钮
    self.playeBtn.hidden = YES;
    [self queryDownloadStatus];
    
    if (self.videoStatus == HKDownloadFinished) {
        self.checkVideoStatus = CheckVideoStatusTwo;
        // 下载完成
        [self getProgress:self.detailModel sender:sender];
        /**
            if ([self.delegate respondsToSelector:@selector(zf_controlView:playAction:)]) {
                [self.delegate zf_controlView:self playAction:sender];
                [self zf_playerShowOrHideControlView];
                [self hiddenLookCountTipLabel];
                //时间提示
                [self makeTimeViewAndConstraints];
                self.resolutionBtn.hidden = NO;
            }
        **/
    }else{
        if (![HKAccountTool shareAccount]) {
            if ([self.delegate respondsToSelector:@selector(zf_controlView:loginAction:)]) {
                [self.delegate zf_controlView:self loginAction:nil];
            }
            return;
        }
        // 下载未完成
        [self playVideo:sender];
    }
}


#pragma mark - 播放下载未完成
- (void)playNoFinishVideo:(UIButton *)sender {
    
    // 下载未完成
    if (self.checkVipStatus == CheckVipStatusOnce || [self.permissionVideoModel.is_paly isEqualToString:@"0"] ) {
        
        [self getPermission:self.detailModel];
    }else{
        if ([self.delegate respondsToSelector:@selector(zf_controlView:playAction:)]) {
            [self.delegate zf_controlView:self playAction:sender];
            [self zf_playerShowOrHideControlView];
            [self hiddenLookCountTipLabel];
            //时间提示
            [self makeTimeViewAndConstraints];
        }
    }
}


- (void)playVideo:(UIButton *)sender {
    WeakSelf;
    if ([HkNetworkManageCenter shareInstance].networkStatus
        == AFNetworkReachabilityStatusReachableViaWWAN && self.checkVideoStatus == CheckVideoStatusOnce) {

        __block UIButton *tempSender = sender;
        [LEEAlert alert].config
        .LeeAddTitle(^(UILabel *label) {
            label.text = @"流量提醒";
            label.textColor = [UIColor blackColor];
        })
        .LeeAddContent(^(UILabel *label) {
            label.text = Mobile_Network;
            label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
        })
        .LeeAddAction(^(LEEAction *action) {

            action.type = LEEActionTypeCancel;
            action.title = @"稍后观看";
            action.titleColor = COLOR_ff7c00;
            action.backgroundColor = [UIColor whiteColor];
            action.clickBlock = ^{
                return ;
            };
        })
        .LeeAddAction(^(LEEAction *action) {

            action.type = LEEActionTypeDefault;
            action.title = @"继续观看";
            action.titleColor = COLOR_333333;
            action.backgroundColor = [UIColor whiteColor];
            action.clickBlock = ^{
                StrongSelf;
                [strongSelf playNoFinishVideo:tempSender];
                strongSelf.checkVideoStatus = CheckVideoStatusTwo;// 标记第二次查询状态
            };
        })
        .LeeHeaderColor([UIColor whiteColor])
        .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
        .LeeShow();
    }else{
        [self playNoFinishVideo:sender];
        self.checkVideoStatus = CheckVideoStatusTwo;
    }
}




- (void)closeBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(zf_controlView:closeAction:)]) {
        [self.delegate zf_controlView:self closeAction:sender];
    }
}

- (void)fullScreenBtnClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(zf_controlView:fullScreenAction:)]) {
        [self.delegate zf_controlView:self fullScreenAction:sender];
        if (sender.selected) {
            if (!self.isShowMaterialTip) {
                if ([self.playerModel.detailModel.is_show_tips isEqualToString:@"1"] &&  CheckVideoStatusTwo == self.checkVideoStatus) {
                    [self.materialTimerLabel start];
                    self.isShowMaterialTip = YES;
                }
            }
        }
    }
}

- (void)repeatBtnClick:(UIButton *)sender {
    // 重置控制层View
    [self zf_playerResetControlView];
    [self zf_playerShowControlView];
    if ([self.delegate respondsToSelector:@selector(zf_controlView:repeatPlayAction:)]) {
        [self.delegate zf_controlView:self repeatPlayAction:sender];
    }
}

- (void)downloadBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(zf_controlView:downloadVideoAction:)]) {
        [self.delegate zf_controlView:self downloadVideoAction:sender];
    }
}



/** isHiddenView yes - 点击播放界面 隐藏分辨率View  */
- (void)resolutionBtnClick:(UIButton *)sender isHiddenView:(BOOL)isHiddenView{
    sender.selected = !sender.selected;
    // 显示隐藏分辨率View
    self.resolutionView.hidden = !sender.isSelected;
    // add 0402
    if (self.isFirst && !isHiddenView) {
        if (self.borderLayer) {
            [self.borderLayer removeFromSuperlayer];
        }
    }else{
        [self setResolutionBtnCorner:NO];
    }
    self.isFirst = YES;
}


/** 中间播放按钮 */
- (void)centerPlayBtnClick:(UIButton *)sender {
    [self playBtnClick:self.startBtn];
//    if ([self.delegate respondsToSelector:@selector(zf_controlView:cneterPlayAction:)]) {
//        [self.delegate zf_controlView:self cneterPlayAction:sender];
//    }
}

- (void)failBtnClick:(UIButton *)sender {
    self.failBtn.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(zf_controlView:failAction:)]) {
        [self.delegate zf_controlView:self failAction:sender];
    }
}

- (void)progressSliderTouchBegan:(ASValueTrackingSlider *)sender {
    [self zf_playerCancelAutoFadeOutControlView];
    self.videoSlider.popUpView.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(zf_controlView:progressSliderTouchBegan:)]) {
        [self.delegate zf_controlView:self progressSliderTouchBegan:sender];
    }
}

- (void)progressSliderValueChanged:(ASValueTrackingSlider *)sender {
    if ([self.delegate respondsToSelector:@selector(zf_controlView:progressSliderValueChanged:)]) {
        [self.delegate zf_controlView:self progressSliderValueChanged:sender];
    }
}

- (void)progressSliderTouchEnded:(ASValueTrackingSlider *)sender {
    self.showing = YES;
    if ([self.delegate respondsToSelector:@selector(zf_controlView:progressSliderTouchEnded:)]) {
        [self.delegate zf_controlView:self progressSliderTouchEnded:sender];
    }
}

/**
 *  应用退到后台
 */
- (void)appDidEnterBackground {
    //[self zf_playerCancelAutoFadeOutControlView];
    [self.watchLabel pause];
}

/**
 *  应用进入前台
 */
- (void)appDidEnterPlayground {
    //if (!self.isShrink) { [self zf_playerShowControlView]; }
}

- (void)playerPlayDidEnd {
    self.backgroundColor  = RGBA(0, 0, 0, .6);
    self.repeatBtn.hidden = NO;
    // 初始化显示controlView为YES
    self.showing = NO;
    // 延迟隐藏controlView
    [self zf_playerShowControlView];
}

/**
 *  屏幕方向发生变化会调用这里
 */
- (void)onDeviceOrientationChange {
    
    if (ZFNormalPlayerShared.isLockScreen) { return; }
    self.lockBtn.hidden         = !self.isFullScreen;
    self.fullScreenBtn.selected = self.isFullScreen;
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown || orientation == UIDeviceOrientationPortraitUpsideDown) { return; }
    if (!self.isShrink && !self.isPlayEnd && !self.showing) {
        // 显示、隐藏控制层
        [self zf_playerShowOrHideControlView];
    }
}

- (void)setOrientationLandscapeConstraint {
    if (self.isCellVideo) {
        self.shrink             = NO;
    }
    self.fullScreen             = YES;
    self.lockBtn.hidden         = !self.isFullScreen;
    self.fullScreenBtn.selected = self.isFullScreen;

}


/** 重置 自动播放 配置 按钮 约束 */
- (void)remakePlayConfigBtnConstraints {
    
    [self.autoPlayConfigBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBtn.mas_centerY);
        if (self.fullScreen) {
            make.left.equalTo(self.topImageView.mas_right).offset(-PADDING_25);
        }else{
            make.left.equalTo(self.topImageView.mas_right);
        }
    }];
    
    [self setAutoPlayTipIView];
}


/** 设置自动播放 提示 */
- (void)setAutoPlayTipIView {
    
    if (self.fullScreen && !self.isShowAutoPlayTip) {
        [self.topImageView addSubview:self.autoPlayTipIView];
        [self.autoPlayTipIView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.autoPlayConfigBtn.mas_bottom).offset(PADDING_10);
            make.right.equalTo(self.autoPlayConfigBtn).offset(PADDING_10);
        }];
    }
}


- (HKAutoPlayTipIView*)autoPlayTipIView {
    if (!_autoPlayTipIView) {
        _autoPlayTipIView = [[HKAutoPlayTipIView alloc]init];
        _autoPlayTipIView.delegate = self;
    }
    return _autoPlayTipIView;
}


/** HKAutoPlayTipIView  delegate    */
- (void)removeAutoPlayTipIView:(HKAutoPlayTipIView *)view {
    TTVIEW_RELEASE_SAFELY(view);
    self.isShowAutoPlayTip = YES;
}


/**
 *  设置竖屏的约束
 */
- (void)setOrientationPortraitConstraint {
    self.fullScreen             = NO;
    self.lockBtn.hidden         = !self.isFullScreen;
    self.fullScreenBtn.selected = self.isFullScreen;
    
    if (self.isCellVideo) {
        //modify yang
        [self.backBtn setImage:ZFNormalPlayerImage(@"ZFNormalPlayer_close") forState:UIControlStateNormal];
        //[self.backBtn setBackgroundImage:ZFNormalPlayerImage(@"ZFNormalPlayer_close") forState:UIControlStateNormal];
    }
}

#pragma mark - Private Method

- (void)showControlView {
    self.showing = YES;
    if (self.lockBtn.isSelected) {
        self.topImageView.alpha    = 0;
        self.bottomImageView.alpha = 0;
    } else {
        self.topImageView.alpha    = 1;
        self.bottomImageView.alpha = (CheckVideoStatusOnce == self.checkVideoStatus)?0 :1;
    }
    self.backgroundColor           = RGBA(0, 0, 0, 0.3);
    self.lockBtn.alpha             = 1;
    if (self.isCellVideo) {
        self.shrink                = NO;
    }
    self.bottomProgressView.alpha  = 0;
    ZFNormalPlayerShared.isStatusBarHidden = NO;
}

- (void)hideControlView {
    self.showing = NO;
    self.backgroundColor         = RGBA(0, 0, 0, 0);
    self.topImageView.alpha      = self.playeEnd;
    self.bottomImageView.alpha    = 0;
    self.lockBtn.alpha           = 0;
    self.bottomProgressView.alpha = 1;
    // 隐藏resolutionView
    self.resolutionBtn.selected = YES;
    [self resolutionBtnClick:self.resolutionBtn isHiddenView:YES];
    if (self.isFullScreen && !self.playeEnd && !self.isShrink) {
        ZFNormalPlayerShared.isStatusBarHidden = YES;
    }
}

/**
 *  监听设备旋转通知
 */
- (void)listeningRotating {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}


- (void)autoFadeOutControlView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(zf_playerHideControlView) object:nil];
    [self performSelector:@selector(zf_playerHideControlView) withObject:nil afterDelay:ZFNormalPlayerAnimationTimeInterval];
}


/**
 slider滑块的bounds
 */
- (CGRect)thumbRect {
    return [self.videoSlider thumbRectForBounds:self.videoSlider.bounds
                                      trackRect:[self.videoSlider trackRectForBounds:self.videoSlider.bounds]
                                          value:self.videoSlider.value];
}

#pragma mark - setter

- (void)setShrink:(BOOL)shrink {
    _shrink = shrink;
    self.closeBtn.hidden = !shrink;
    self.bottomProgressView.hidden = shrink;
}

- (void)setFullScreen:(BOOL)fullScreen {
    _fullScreen = fullScreen;
    ZFNormalPlayerShared.isLandscape = fullScreen;
}

#pragma mark - getter



- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:IS_IPHONE5S ?15 :17];
        [_titleLabel setTextAlignment:NSTextAlignmentLeft];
        _titleLabel.hidden = YES; // add 0903
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:imageName(@"hkplayer_back") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setEnlargeEdgeWithTop:PADDING_15 right:PADDING_25 bottom:PADDING_25 left:PADDING_25];
    }
    return _backBtn;
}

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView                       = [[UIImageView alloc] init];
        _topImageView.userInteractionEnabled = YES;
        _topImageView.alpha                  = 0;
        _topImageView.image                  = ZFNormalPlayerImage(@"ZFNormalPlayer_top_shadow");
    }
    return _topImageView;
}

- (UIImageView *)bottomImageView {
    if (!_bottomImageView) {
        _bottomImageView                        = [[UIImageView alloc] init];
        _bottomImageView.userInteractionEnabled = YES;
        _bottomImageView.alpha                  = 0;
        _bottomImageView.image                  = ZFNormalPlayerImage(@"ZFNormalPlayer_bottom_shadow");
    }
    return _bottomImageView;
}

- (UIButton *)lockBtn {
    if (!_lockBtn) {
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_lockBtn setImage:ZFNormalPlayerImage(@"ZFNormalPlayer_unlock-nor") forState:UIControlStateNormal];
//        [_lockBtn setImage:ZFNormalPlayerImage(@"ZFNormalPlayer_lock-nor") forState:UIControlStateSelected];
        [_lockBtn setImage:imageName(@"hkplayer_unlock-nor") forState:UIControlStateNormal];
        [_lockBtn setImage:imageName(@"hkplayer_lock-nor") forState:UIControlStateSelected];
        [_lockBtn addTarget:self action:@selector(lockScrrenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_lockBtn setHKEnlargeEdge:PADDING_15];

    }
    return _lockBtn;
}

- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_startBtn setImage:ZFNormalPlayerImage(@"ZFNormalPlayer_play") forState:UIControlStateNormal];
        //[_startBtn setImage:ZFNormalPlayerImage(@"ZFNormalPlayer_pause") forState:UIControlStateSelected];
        [_startBtn setImage:imageName(@"hkplayer_play") forState:UIControlStateNormal];
        [_startBtn setImage:imageName(@"hkplayer_pause") forState:UIControlStateSelected];
        [_startBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:ZFNormalPlayerImage(@"ZFNormalPlayer_close") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.hidden = YES;
    }
    return _closeBtn;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel               = [[UILabel alloc] init];
        _currentTimeLabel.textColor     = [UIColor whiteColor];
        _currentTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView                   = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        //缓冲 进度条颜色
        _progressView.progressTintColor = [UIColor whiteColor];//[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _progressView.trackTintColor    = [UIColor clearColor];
    }
    return _progressView;
}

- (ASValueTrackingSlider *)videoSlider {
    if (!_videoSlider) {
        _videoSlider                       = [[ASValueTrackingSlider alloc] init];
        _videoSlider.popUpViewCornerRadius = 0.0;
        _videoSlider.popUpViewColor = RGBA(19, 19, 9, 1);
        _videoSlider.popUpViewArrowLength = 8;

        [_videoSlider setThumbImage:imageName(@"hkplayer_slider") forState:UIControlStateNormal];
        //[_videoSlider setThumbImage:ZFNormalPlayerImage(@"ZFNormalPlayer_slider") forState:UIControlStateNormal];
        _videoSlider.maximumValue          = 1;
        //已经播放进度条颜色
        _videoSlider.minimumTrackTintColor = COLOR_FFD305;//[UIColor whiteColor];
        //进度条颜色
        _videoSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        
        // slider开始滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [_videoSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
        
        UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSliderAction:)];
        [_videoSlider addGestureRecognizer:sliderTap];
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panRecognizer:)];
        panRecognizer.delegate = self;
        [panRecognizer setMaximumNumberOfTouches:1];
        [panRecognizer setDelaysTouchesBegan:YES];
        [panRecognizer setDelaysTouchesEnded:YES];
        [panRecognizer setCancelsTouchesInView:YES];
        [_videoSlider addGestureRecognizer:panRecognizer];
    }
    return _videoSlider;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel               = [[UILabel alloc] init];
        _totalTimeLabel.textColor     = [UIColor whiteColor];
        _totalTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}

- (UIButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //[_fullScreenBtn setImage:ZFNormalPlayerImage(@"ZFNormalPlayer_fullscreen") forState:UIControlStateNormal];
        //[_fullScreenBtn setImage:imageName(@"hkplayer_shrinkscreen") forState:UIControlStateSelected];
    
        [_fullScreenBtn setImage:imageName(@"hkplayer_fullscreen") forState:UIControlStateNormal];
        [_fullScreenBtn setImage:imageName(@"ic_shrink_v2_5") forState:UIControlStateSelected];
        [_fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_fullScreenBtn setEnlargeEdgeWithTop:25 right:0 bottom:0 left:20];
    }
    return _fullScreenBtn;
}


- (HKLivingSpeedLoadingView *)activity {
    if (!_activity) {
        _activity = [[HKLivingSpeedLoadingView alloc] init];
    }
    return _activity;
}


//- (MMMaterialDesignSpinner *)activity {
//    if (!_activity) {
//        _activity = [[MMMaterialDesignSpinner alloc] init];
//        _activity.lineWidth = 2;
//        _activity.duration  = 1;
//        _activity.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
//    }
//    return _activity;
//}



- (UIButton *)repeatBtn {
    if (!_repeatBtn) {
        _repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_repeatBtn setImage:ZFNormalPlayerImage(@"ZFNormalPlayer_repeat_video") forState:UIControlStateNormal];
        [_repeatBtn addTarget:self action:@selector(repeatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _repeatBtn;
}

- (UIButton *)downLoadBtn {
    if (!_downLoadBtn) {
        _downLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downLoadBtn setImage:ZFNormalPlayerImage(@"ZFNormalPlayer_download") forState:UIControlStateNormal];
        [_downLoadBtn setImage:ZFNormalPlayerImage(@"ZFNormalPlayer_not_download") forState:UIControlStateDisabled];
        [_downLoadBtn addTarget:self action:@selector(downloadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downLoadBtn;
}

//- (HKPlayerResolutionBtn *)resolutionBtn {
- (UIButton *)resolutionBtn {
    if (!_resolutionBtn) {
        _resolutionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resolutionBtn.titleLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ?12 :11];
        //_resolutionBtn.backgroundColor = RGBA(0, 0, 0, 0.6);
        [_resolutionBtn addTarget:self action:@selector(resolutionBtnClick:isHiddenView:) forControlEvents:UIControlEventTouchUpInside];
        _resolutionBtn.backgroundColor = [UIColor clearColor];
        
        [_resolutionBtn setBackgroundImage:imageName(@"hkplayer_rate_nomal") forState:UIControlStateNormal];
        [_resolutionBtn setBackgroundImage:imageName(@"hkplayer_rate_selected") forState:UIControlStateSelected];
        [_resolutionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_resolutionBtn setTitleColor:COLOR_27323F forState:UIControlStateSelected];
        [_resolutionBtn setEnlargeEdgeWithTop:PADDING_25 right:PADDING_15 bottom:0 left:PADDING_10];
    }
    return _resolutionBtn;
}


- (CAShapeLayer*)borderLayer {
    if (!_borderLayer) {
        _borderLayer = [CAShapeLayer layer];
    }
    return _borderLayer;
}


/** 设置分辨率按钮 圆角  yes - 延迟设置 */
- (void)setResolutionBtnCorner:(BOOL)isdelay {
    
    /*
    if (isdelay) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setResolutionBtnCorner];
        });
    }else{
        [self setResolutionBtnCorner];
    }
    */
}

- (void)setResolutionBtnCorner {
    
    if (self.borderLayer) {
        [self.borderLayer removeFromSuperlayer];
    }
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.resolutionBtn.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(4, 0)];
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame       = self.resolutionBtn.bounds;
    borderLayer.path        = maskPath.CGPath;
    borderLayer.strokeColor = [UIColor whiteColor].CGColor;
    borderLayer.fillColor   = [UIColor clearColor].CGColor;
    borderLayer.lineWidth   = 1;
    
    self.borderLayer = borderLayer;
    [self.resolutionBtn.layer addSublayer:self.borderLayer];
}



- (UIButton *)playeBtn {
    if (!_playeBtn) {
        _playeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playeBtn setImage:imageName(@"hkplayer_center_play") forState:UIControlStateNormal];
        [_playeBtn addTarget:self action:@selector(centerPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playeBtn;
}


- (UIButton *)failBtn {
    if (!_failBtn) {
        _failBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_failBtn setTitle:@"加载失败,点击重试" forState:UIControlStateNormal];
        [_failBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _failBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _failBtn.backgroundColor = RGBA(0, 0, 0, 0.7);
        [_failBtn addTarget:self action:@selector(failBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _failBtn;
}

- (UIView *)fastView {
    if (!_fastView) {
        _fastView                     = [[UIView alloc] init];
        _fastView.backgroundColor     = RGBA(0, 0, 0, 0.8);
        _fastView.layer.cornerRadius  = 4;
        _fastView.layer.masksToBounds = YES;
    }
    return _fastView;
}

- (UIImageView *)fastImageView {
    if (!_fastImageView) {
        _fastImageView = [[UIImageView alloc] init];
    }
    return _fastImageView;
}

- (UILabel *)fastTimeLabel {
    if (!_fastTimeLabel) {
        _fastTimeLabel               = [[UILabel alloc] init];
        _fastTimeLabel.textColor     = [UIColor whiteColor];
        _fastTimeLabel.textAlignment = NSTextAlignmentCenter;
        _fastTimeLabel.font          = [UIFont systemFontOfSize:14.0];
    }
    return _fastTimeLabel;
}

- (UIProgressView *)fastProgressView {
    if (!_fastProgressView) {
        _fastProgressView                   = [[UIProgressView alloc] init];
        _fastProgressView.progressTintColor = COLOR_FFD305;//[UIColor whiteColor];
        _fastProgressView.trackTintColor    = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    }
    return _fastProgressView;
}


- (UIImageView *)placeholderImageView {
    if (!_placeholderImageView) {
        _placeholderImageView = [[UIImageView alloc] init];
        _placeholderImageView.userInteractionEnabled = YES;
    }
    return _placeholderImageView;
}


- (UIProgressView *)bottomProgressView {
    if (!_bottomProgressView) {
        _bottomProgressView               = [[UIProgressView alloc] init];
        _bottomProgressView.progressTintColor = COLOR_FFD305; //[UIColor whiteColor];
        _bottomProgressView.trackTintColor    = [UIColor clearColor];
    }
    return _bottomProgressView;
}


- (UIButton*)autoPlayConfigBtn {
    if (!_autoPlayConfigBtn) {
        _autoPlayConfigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_autoPlayConfigBtn setBackgroundImage:imageName(@"hkplayer_more") forState:UIControlStateNormal];
        [_autoPlayConfigBtn setBackgroundImage:imageName(@"hkplayer_more") forState:UIControlStateSelected];
        [_autoPlayConfigBtn setEnlargeEdgeWithTop:PADDING_25 right:PADDING_25 bottom:PADDING_5 left:PADDING_10];
        [_autoPlayConfigBtn addTarget:self action:@selector(autoPlayConfigBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _autoPlayConfigBtn;
}


- (void)autoPlayConfigBtnClick:(UIButton*)sender {
    
    [MobClick event:UM_RECORD_DETAIL_PAGE_WINDOW_SETTING];
    
    TTVIEW_RELEASE_SAFELY(self.autoPlayConfigView);
    [self addSubview:self.autoPlayConfigView];
    [self bringSubviewToFront:self.autoPlayConfigView];
    [self.autoPlayConfigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


- (HKPlayerAutoPlayConfigView*) autoPlayConfigView {
    if (!_autoPlayConfigView) {
        _autoPlayConfigView = [[HKPlayerAutoPlayConfigView alloc]init];
        _autoPlayConfigView.delegate = self;
        _autoPlayConfigView.tag = 2020;
    }
    return _autoPlayConfigView;
}

/**autoPlayConfigView delegate */
- (void)removePlayerAutoPlayConfigView:(HKPlayerAutoPlayConfigView *)view {

    TTVIEW_RELEASE_SAFELY(view);
}


- (void)playerRateConfigView:(HKPlayerAutoPlayConfigView *)view state:(NSInteger)state {
    
    if (0 == state) {
        //记录速率
        NSInteger selectd = (self.resoultionCurrentBtn.tag - 200) + 1;
        [HKNSUserDefaults setInteger:selectd forKey:HKPlayerPlayRate];
        [HKNSUserDefaults synchronize];
    }else{
        //清除记录速率
        [HKNSUserDefaults removeObjectForKey:HKPlayerPlayRate];
        [HKNSUserDefaults synchronize];
    }
}


/** 举报视频 */
- (void)playerRateConfigView:(HKPlayerAutoPlayConfigView *)view feedBack:(NSString*)feedBack {
    
    if ([self.delegate respondsToSelector:@selector(zf_controlView:feedBack:)]) {
        [self.delegate zf_controlView:self feedBack:feedBack];
        TTVIEW_RELEASE_SAFELY(view);
    }
}


/************************* add 0903 ***************************/


- (HKPlayerBuyVipView*)buyVipBgView {
    if (!_buyVipBgView) {
        _buyVipBgView = [[HKPlayerBuyVipView alloc]initWithModel:self.permissionVideoModel detailModel:self.detailModel];
        _buyVipBgView.tag = 1000;// 标记 用于遍历视图
        _buyVipBgView.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.8];
        _buyVipBgView.delegate = self;
    }
    return _buyVipBgView;
}


- (void)hKBuyVipViewShareAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(zf_controlView:shareVideoAction:)]) {
        [self.delegate zf_controlView:self shareVideoAction:sender];
    }
}


- (void)hKBuyVipViewBuyVipAction:(UIButton*)sender {
    
    if ([self.delegate respondsToSelector:@selector(zf_controlView:buyVipAction:)]) {
        [self.delegate zf_controlView:self buyVipAction:sender];
    }
}

- (void)hKBuyVipViewCollectVideoAction:(UIButton*)sender {
    
}



- (UILabel *)lookCountTipLabel {
    if (!_lookCountTipLabel) {
        _lookCountTipLabel            = [[UILabel alloc] init];
        _lookCountTipLabel.textColor    = [UIColor whiteColor];
        _lookCountTipLabel.textAlignment = NSTextAlignmentLeft;
        _lookCountTipLabel.font        = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14.0 :13.0];
        //_lookCountTipLabel.text = @"您暂无字体设计VIP会员,每日免费学习一个教程";
        _lookCountTipLabel.hidden = YES;
        self.lookStatus = LookStatusOnce;
    }
    return _lookCountTipLabel;
}


// 计时器
- (MZTimerLabel*)watchLabel {
    if (!_watchLabel) {
        _watchLabel = [[MZTimerLabel alloc] initWithFrame:CGRectZero];
        _watchLabel.timerType = MZTimerLabelTypeStopWatch;
        _watchLabel.backgroundColor = [UIColor clearColor];
        _watchLabel.hidden = YES;
        //_watchLabel.delegate = self;
    }
    return _watchLabel;
}


- (MZTimerLabel*)materialTimerLabel {
    if (!_materialTimerLabel) {
        _materialTimerLabel = [[MZTimerLabel alloc] initWithFrame:CGRectZero];
        _materialTimerLabel.timerType = MZTimerLabelTypeTimer;
        _materialTimerLabel.backgroundColor = [UIColor clearColor];
        _materialTimerLabel.hidden = YES;
        _materialTimerLabel.delegate = self;
        [_materialTimerLabel setCountDownTime:10];
    }
    return _materialTimerLabel;
}

/***************** MZTimerLabel 代理 ******************/
- (void)timerLabel:(MZTimerLabel*)timerLabel countingTo:(NSTimeInterval)time timertype:(MZTimerLabelType)timerType {
    
    NSLog(@"倒计时 ---  %.0f",time);
}

-(void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime {
    [timerLabel pause];
    [self makeMaterialTipViewAndConstraints];
}



- (HKPlayTimeTipView*)timeTipView {
    if (!_timeTipView) {
        _timeTipView = [[HKPlayTimeTipView alloc]initWithFrame:CGRectZero];
        _timeTipView.delegate = self;
        _timeTipView.model = self.playerModel;
    }
    return _timeTipView;
}

/** 下一节视频 代理 */
- (void)hkPlayTimeTipAction:(ZFNormalPlayerModel *)model {
    if ([self.delegate respondsToSelector:@selector(zf_controlView:playTimeTipAction:)]) {
        [self.delegate zf_controlView:nil playTimeTipAction:model];
    }
}



- (HKPlayMaterialTipView*)materialTipView {
    if (!_materialTipView) {
        _materialTipView = [[HKPlayMaterialTipView alloc]initWithFrame:CGRectZero];
//        _materialTipView.userInteractionEnabled = YES;
    }
    return _materialTipView;
}



#pragma mark - 移除 lookCountTipLabel
- (void)hiddenLookCountTipLabel {
    
    WeakSelf;
    if(!self.showing && _lookCountTipLabel != nil){
        
        if ([self.permissionVideoModel.is_vip isEqualToString:@"0"]) { //0 非VIP
            
            [MobClick event:UM_RECORD_VEDIO_PLAYBOTTOM];
            self.lookStatus = LookStatusTwo;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _lookCountTipLabel.hidden = NO;
                [UIView animateWithDuration:3.5 animations:^{
                    _lookCountTipLabel.alpha = 0;
                } completion:^(BOOL finished) {
                    [_lookCountTipLabel removeFromSuperview];
                    _lookCountTipLabel = nil;
                    //_bottomVipBtn.hidden = NO;
                    [weakSelf zf_showVipBtn];
                }];
            });
        }else{
            self.lookStatus = LookStatusTwo;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _lookCountTipLabel.hidden = YES;
                [UIView animateWithDuration:0 animations:^{
                    _lookCountTipLabel.alpha = 0;
                } completion:^(BOOL finished) {
                    [_lookCountTipLabel removeFromSuperview];
                    _lookCountTipLabel = nil;
                }];
            });
        }
    }
}


- (UIButton*)bottomVipBtn {
    
    if (!_bottomVipBtn) {
        _bottomVipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomVipBtn setTitle:@"成为VIP" forState:UIControlStateNormal];
        [_bottomVipBtn setTitleColor:[UIColor colorWithHexString:@"#ff7c00"] forState:UIControlStateNormal];
        _bottomVipBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        _bottomVipBtn.hidden = YES;
        _bottomVipBtn.enabled = YES;
//        [self hiddenOrShowVipBtn];
        [_bottomVipBtn addTarget:self action:@selector(bottomVipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomVipBtn;
}



- (UIButton*)centerGraphicBtn {
    if (!_centerGraphicBtn) {
        _centerGraphicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_centerGraphicBtn  setImage:imageName(@"hkplayer_graphic_bg") forState:UIControlStateNormal];
//        [_centerGraphicBtn  setImage:imageName(@"hkplayer_graphic_bg") forState:UIControlStateHighlighted];
//        [_centerGraphicBtn  setImage:imageName(@"hkplayer_graphic_bg") forState:UIControlStateSelected];
        
        [_centerGraphicBtn setBackgroundImage:imageName(@"hkplayer_graphic_bg") forState:UIControlStateNormal];
        [_centerGraphicBtn setBackgroundImage:imageName(@"hkplayer_graphic_bg") forState:UIControlStateHighlighted];
        [_centerGraphicBtn setBackgroundImage:imageName(@"hkplayer_graphic_bg") forState:UIControlStateSelected];
        [_centerGraphicBtn addTarget:self action:@selector(centerGraphicBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _centerGraphicBtn.hidden = YES;
    }
    return _centerGraphicBtn;
}


- (void)centerGraphicBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(zf_controlView: picUrl: centerGraphicBtnClick:)]) {
        [self.delegate zf_controlView:self picUrl:self.detailModel.pictext_url centerGraphicBtnClick:sender];
    }
}


- (UIButton*)topGraphicBtn {
    if (!_topGraphicBtn) {
        _topGraphicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topGraphicBtn setTitle:@"图文教程" forState:UIControlStateNormal];
        [_topGraphicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _topGraphicBtn.titleLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ?12 :11];
        //_topGraphicBtn.contentEdgeInsets = UIEdgeInsetsMake(4, 7.5, 4, 7.5);
        [_topGraphicBtn setBackgroundImage:imageName(@"hkplayer_rectangle_bg") forState:UIControlStateNormal];
        [_topGraphicBtn setBackgroundImage:imageName(@"hkplayer_rectangle_bg") forState:UIControlStateHighlighted];
        [_topGraphicBtn setBackgroundImage:imageName(@"hkplayer_rectangle_bg") forState:UIControlStateSelected];
        [_topGraphicBtn addTarget:self action:@selector(topGraphicBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topGraphicBtn setEnlargeEdgeWithTop:PADDING_25 right:0 bottom:0 left:PADDING_25];
        _topGraphicBtn.hidden = YES;
    }
    return _topGraphicBtn;
}


- (void)topGraphicBtnClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(zf_controlView: picUrl: topGraphicBtnClick:)]) {
        [self.delegate zf_controlView:self picUrl:self.detailModel.pictext_url topGraphicBtnClick:sender];
    }
}


/** 隐藏中间图文按钮 显示顶部图文按钮 */
- (void)zf_playerShowTopGraphicBtn {
    if (isEmpty(self.detailModel.pictext_url)) {
        
    }else{
        self.centerGraphicBtn.hidden = !self.centerGraphicBtn.hidden;
        self.topGraphicBtn.hidden = !self.topGraphicBtn.hidden;
    }
}



#pragma mark -  显示或隐藏 VIP 按钮
- (void)hiddenOrShowVipBtn {
    if (_lookCountTipLabel == nil) {
        _bottomVipBtn.hidden = !_bottomVipBtn.hidden;
    }
}

#pragma mark -  显示 VIP 按钮
- (void)zf_showVipBtn {
    
//    if (self.fullScreen) {
//        _bottomVipBtn.hidden = YES;
//        return;
//    }
    if (_lookCountTipLabel == nil && [self.permissionVideoModel.is_vip isEqualToString:@"0"] ) {
        _bottomVipBtn.hidden = NO;
        //_bottomVipBtn.enabled = NO;
    }
}

#pragma mark -  隐藏 VIP 按钮
- (void)zf_hiddenVipBtn {
    
//    if (self.fullScreen) {
//        _bottomVipBtn.hidden = YES;
//        return;
//    }
    if (_lookCountTipLabel == nil && [self.permissionVideoModel.is_vip isEqualToString:@"0"]) {
        _bottomVipBtn.hidden = YES;
        //_bottomVipBtn.enabled = YES;
    }
}

#pragma mark - 强制 隐藏 VIP 按钮
- (void)zf_mustHiddenVipBtn {
    if (_bottomVipBtn != nil) {
        _bottomVipBtn.hidden = YES;
    }
}



#pragma mark - 购买VIP
- (void)bottomVipBtnClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(zf_controlView:buyVipAction:)]) {
        [self.delegate zf_controlView:self buyVipAction:sender];
    }
}


/************************* add 0903 ***************************/



#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    //按钮点击冲突
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    
    CGRect rect = [self thumbRect];
    CGPoint point = [touch locationInView:self.videoSlider];
    if ([touch.view isKindOfClass:[UISlider class]]) { // 如果在滑块上点击就不响应pan手势
        if (point.x <= rect.origin.x + rect.size.width && point.x >= rect.origin.x) { return NO; }
    }
    return YES;
}

#pragma mark - Public method

/** 重置ControlView */
- (void)zf_playerResetControlView {
    [self.activity stopAnimating];
    self.videoSlider.value           = 0;
    self.bottomProgressView.progress = 0;
    self.progressView.progress       = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
    self.fastView.hidden             = YES;
    self.repeatBtn.hidden            = YES;
    //self.playeBtn.hidden             = YES;
    self.resolutionView.hidden       = YES;
    self.failBtn.hidden              = YES;
    self.backgroundColor             = [UIColor clearColor];
    self.downLoadBtn.enabled         = YES;
    self.shrink                      = NO;
    self.showing                     = NO;
    self.playeEnd                    = NO;
    self.lockBtn.hidden              = !self.isFullScreen;
    self.failBtn.hidden              = YES;
    self.placeholderImageView.alpha  = 1;
    [self hideControlView];
}

- (void)zf_playerResetControlViewForResolution {
    self.fastView.hidden        = YES;
    self.repeatBtn.hidden       = YES;
    self.resolutionView.hidden  = YES;
    //self.playeBtn.hidden        = YES;
    self.downLoadBtn.enabled    = YES;
    self.failBtn.hidden         = YES;
    self.backgroundColor        = [UIColor clearColor];
    self.shrink                 = NO;
    self.showing                = NO;
    self.playeEnd               = NO;
}

/**
 *  取消延时隐藏controlView的方法
 */
- (void)zf_playerCancelAutoFadeOutControlView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
//    UIView *view = [self viewWithTag:2020];
//    if (view != nil) {
//        [self.autoPlayConfigView removeView];
//        TTVIEW_RELEASE_SAFELY(self.autoPlayConfigView);
//    }
}



/** 设置播放模型 */
- (void)zf_playerModel:(ZFNormalPlayerModel *)playerModel {
    
    if (![self.detailModel.img_cover_url_big isEqualToString:playerModel.detailModel.img_cover_url_big]) {
        // 设置网络占位图片
        if (playerModel.placeholderImageURLString) {
            [self.placeholderImageView sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:playerModel.placeholderImageURLString]) placeholderImage:ZFNormalPlayerImage(@"ZFNormalPlayer_loading_bgView")];
            
        } else {
            self.placeholderImageView.image = playerModel.placeholderImage;
        }
    }
    self.playerModel = playerModel;
    self.detailModel = playerModel.detailModel; // add 1212
    if (playerModel.title) { self.titleLabel.text = playerModel.title;}
    
    // 总时长
    [self setTotalTime];
    // 倍速播放
    //[self zf_playerResolutionArray:[playerModel.resolutionDic allKeys]];
}


- (void)setDetailModel:(DetailModel *)detailModel {
    _detailModel = detailModel;
    self.centerGraphicBtn.hidden = isEmpty(self.detailModel.pictext_url);
}


/** 视频 总时长 */
- (void)setTotalTime {
    
    NSInteger durMin = [HKPlayerLocalRateTool videoTotalTime:self.detailModel];
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",((durMin>0) ?durMin :0), 0];
}



/** 正在播放（隐藏placeholderImageView） */
- (void)zf_playerItemPlaying {
    [UIView animateWithDuration:1.0 animations:^{
        self.placeholderImageView.alpha = 0;
    }];
}

- (void)zf_playerShowOrHideControlView {
    if (self.isShowing) {
        [self zf_playerHideControlView];
    } else {
        [self zf_playerShowControlView];
    }
}
/**
 *  显示控制层
 */
- (void)zf_playerShowControlView {
    
    if (_lookCountTipLabel == nil || self.lookStatus == LookStatusOnce) {
        
        [self zf_hiddenVipBtn]; // 隐藏VIP 按钮
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(zf_controlViewWillShow:isFullscreen:)]) {
            [self.delegate zf_controlViewWillShow:self isFullscreen:self.isFullScreen];
        }
        
        [self zf_playerCancelAutoFadeOutControlView];
        [UIView animateWithDuration:ZFNormalPlayerControlBarAutoFadeOutTimeInterval animations:^{
            [self showControlView];
            self.showing = YES;
        } completion:^(BOOL finished) {
            self.showing = YES;
            [self autoFadeOutControlView];
        }];
    }
}

/**
 *  隐藏控制层
 */
- (void)zf_playerHideControlView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(zf_controlViewWillHidden:isFullscreen:)]) {
        [self.delegate zf_controlViewWillHidden:self isFullscreen:self.isFullScreen];
    }
    [self zf_playerCancelAutoFadeOutControlView];
    [UIView animateWithDuration:ZFNormalPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self hideControlView];
        self.showing = NO;
    } completion:^(BOOL finished) {
        self.showing = NO;
        [self zf_showVipBtn];
    }];
}

/** 小屏播放 */
- (void)zf_playerBottomShrinkPlay {
    self.shrink = YES;
    [self hideControlView];
}

/** 在cell播放 */
- (void)zf_playerCellPlay {
    self.cellVideo = YES;
    self.shrink    = NO;
    [self.backBtn setImage:ZFNormalPlayerImage(@"ZFNormalPlayer_close") forState:UIControlStateNormal];
}

- (void)zf_playerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)value {
    // 当前时长进度progress
    NSInteger proMin = currentTime / 60;//当前秒
    NSInteger proSec = currentTime % 60;//当前分钟
    // duration 总时长
    NSInteger durMin = totalTime / 60;//总秒
    NSInteger durSec = totalTime % 60;//总分钟
    if (!self.isDragged) {
        // 更新slider
        self.videoSlider.value           = value;
        self.bottomProgressView.progress = value;
        // 更新当前播放时间
        self.currentTimeLabel.text       = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    }
    // 更新总时间
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
//    NSLog(@"当前播放时间 %ld",currentTime);
}

- (void)zf_playerDraggedTime:(NSInteger)draggedTime totalTime:(NSInteger)totalTime isForward:(BOOL)forawrd hasPreview:(BOOL)preview {
    // 快进快退时候停止菊花
    [self.activity stopAnimating];
    // 拖拽的时长
    NSInteger proMin = draggedTime / 60;//当前秒
    NSInteger proSec = draggedTime % 60;//当前分钟
    
    //duration 总时长
    NSInteger durMin = totalTime / 60;//总秒
    NSInteger durSec = totalTime % 60;//总分钟
    
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    NSString *totalTimeStr   = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    CGFloat  draggedValue    = (CGFloat)draggedTime/(CGFloat)totalTime;
    NSString *timeStr        = [NSString stringWithFormat:@"%@ / %@", currentTimeStr, totalTimeStr];
    
    // 显示、隐藏预览窗
    self.videoSlider.popUpView.hidden = !preview;
    // 更新slider的值
    self.videoSlider.value            = draggedValue;
    // 更新bottomProgressView的值
    self.bottomProgressView.progress  = draggedValue;
    // 更新当前时间
    self.currentTimeLabel.text        = currentTimeStr;
    // 正在拖动控制播放进度
    self.dragged = YES;
    
    if (forawrd) {
        self.fastImageView.image = ZFNormalPlayerImage(@"ZFNormalPlayer_fast_forward");
    } else {
        self.fastImageView.image = ZFNormalPlayerImage(@"ZFNormalPlayer_fast_backward");
    }
    self.fastView.hidden           = preview;
    self.fastTimeLabel.text        = timeStr;
    self.fastProgressView.progress = draggedValue;

}

- (void)zf_playerDraggedEnd {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.fastView.hidden = YES;
    });
    self.dragged = NO;
    // 结束滑动时候把开始播放按钮改为播放状态
    self.startBtn.selected = YES;
    // 滑动结束延时隐藏controlView
    [self autoFadeOutControlView];
}

- (void)zf_playerDraggedTime:(NSInteger)draggedTime sliderImage:(UIImage *)image; {
    // 拖拽的时长
    NSInteger proMin = draggedTime / 60;//当前秒
    NSInteger proSec = draggedTime % 60;//当前分钟
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    [self.videoSlider setImage:image];
    [self.videoSlider setText:currentTimeStr];
    self.fastView.hidden = YES;
}

/** progress显示缓冲进度 */
- (void)zf_playerSetProgress:(CGFloat)progress {
    [self.progressView setProgress:progress animated:NO];
}

/** 视频加载失败 */
- (void)zf_playerItemStatusFailed:(NSError *)error {
    self.failBtn.hidden = NO;
}

/** 加载的菊花 */
- (void)zf_playerActivity:(BOOL)animated {
    if (animated) {
        [self.activity startAnimating];
        self.fastView.hidden = YES;
    } else {
        [self.activity stopAnimating];
    }
}

/** 播放完了 */
- (void)zf_playerPlayEnd {
    self.repeatBtn.hidden = NO;
    self.playeEnd         = YES;
    self.showing          = NO;
    // 隐藏controlView
    [self hideControlView];
    self.backgroundColor  = RGBA(0, 0, 0, .3);
    ZFNormalPlayerShared.isStatusBarHidden = NO;
    self.bottomProgressView.alpha = 0;

    //add 1020  暂停 计时器
    [self.watchLabel pause];
    if (self.materialTimerLabel) {
        [self.materialTimerLabel pause];
    }
    //NSLog(@"self.watchLabel %f",self.watchLabel.getTimeCounted);

    [self setTimeTip];
    // 推荐教程
    if ([self.detailModel.video_type isEqualToString:@"0"] ) {
        if (0 == self.similarVideoArray.count) {
            [self requestSimilarVideo];
        }else{
            [self setSimilarVideoView];
        }
    }
}





- (NSMutableArray*)similarVideoArray {
    if(!_similarVideoArray) {
        _similarVideoArray = [NSMutableArray array];
    }
    return _similarVideoArray;
}


/**************** 播放完 提示视频  *******************/

/** 请求相似视频*/
- (void)requestSimilarVideo {
    
    WeakSelf;
    NSDictionary *dict = @{@"video_id":self.detailModel.video_id};
    [HKHttpTool POST:VIDEO_GET_RECOMMEND_VIDEO parameters:dict success:^(id responseObject) {
        StrongSelf;
        if (HKReponseOK) {
            strongSelf.similarVideoArray = [VideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            [strongSelf setSimilarVideoView];
        }
    } failure:^(NSError *error) {
        
    }];
}


/** 屏幕方向变化 推荐视频显示 */
- (void)setDeviceChangeSimilarVideoView {
    
    if (self.playeEnd) {
        if (self.similarVideoArray.count>0) {
            if (self.fullScreen) {
                if(_verticalSimilarVideoView){
                    _verticalSimilarVideoView.hidden = YES;
                }
                if(!_fullScreenSimilarVideoView){
                    [self setFullScreenSimilarVideoView];
                }else{
                    _fullScreenSimilarVideoView.hidden = NO;
                }
            }else{
                
                if(_fullScreenSimilarVideoView){
                    _fullScreenSimilarVideoView.hidden = YES;
                }
                if(!_verticalSimilarVideoView){
                    [self setSingleSimilarVideoView];
                }else{
                    _verticalSimilarVideoView.hidden = NO;
                }
            }
        }
    }
}


- (void)setSimilarVideoView {
    if (self.playeEnd) {
        if (self.fullScreen) {
            [self setFullScreenSimilarVideoView];
        }else{
            [self setSingleSimilarVideoView];
        }
    }
}

- (HKPlayerSimilarVideoCell *) verticalSimilarVideoView {
    if (!_verticalSimilarVideoView) {
        _verticalSimilarVideoView = [[HKPlayerSimilarVideoCell alloc]initWithFrame:CGRectZero];
        _verticalSimilarVideoView.playerSimilarVideoDelagate = self;
    }
    return _verticalSimilarVideoView;
}

- (HKPlayerFullScreenSimilarVideoView*)fullScreenSimilarVideoView {
    
    if (!_fullScreenSimilarVideoView) {
        _fullScreenSimilarVideoView = [HKPlayerFullScreenSimilarVideoView new];
        _fullScreenSimilarVideoView.delegate = self;
    }
    return _fullScreenSimilarVideoView;
}


/** 竖屏 推荐视频 */
- (void)setSingleSimilarVideoView {
    
    if (self.similarVideoArray.count>0) {
        
        self.repeatBtn.hidden = YES;
        //self.resolutionBtn.hidden = YES;
        TTVIEW_RELEASE_SAFELY(self.verticalSimilarVideoView);
        if (self.verticalSimilarVideoView) {
            self.verticalSimilarVideoView.hidden = NO;
            [self insertSubview:self.verticalSimilarVideoView belowSubview:self.topImageView];
            [self.verticalSimilarVideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                make.top.equalTo(self.mas_top);
                make.bottom.right.equalTo(self);
            }];
            self.verticalSimilarVideoView.model = self.similarVideoArray[0];
        }
    }
}


#pragma mark HKPlayerSimilarVideoCell  代理
/** cell 点击 */
- (void)hkplayerSimilarVideoCellClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(zf_controlView:nextVideoAction:)]) {
        [self.delegate zf_controlView:self nextVideoAction:sender];
        self.repeatBtn.hidden = NO;
        //self.resolutionBtn.hidden = NO;
        [MobClick event:UM_RECORD_DETAIL_PAGE_PLAY_FINISHED_RECOMMED];
        TTVIEW_RELEASE_SAFELY(self.verticalSimilarVideoView);
    }
}

/** 重播 */
- (void)hkplayerRepeatVideoClick:(id)sender {
    //self.resolutionBtn.hidden = NO;
    [self.verticalSimilarVideoView removeView];
    TTVIEW_RELEASE_SAFELY(self.verticalSimilarVideoView);
    [self repeatBtnClick:self.repeatBtn];
}


/** 全屏 推荐视频 */
- (void)setFullScreenSimilarVideoView {
    
    if (self.similarVideoArray.count>0) {
        self.repeatBtn.hidden = YES;
        //self.resolutionBtn.hidden = YES;
        TTVIEW_RELEASE_SAFELY(self.fullScreenSimilarVideoView);
        if (self.fullScreenSimilarVideoView) {
            [self insertSubview:self.fullScreenSimilarVideoView belowSubview:self.topImageView];
            self.fullScreenSimilarVideoView.hidden = NO;
            
            [self.fullScreenSimilarVideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.top.left.right.equalTo(self);
            }];
            self.fullScreenSimilarVideoView.dataArray = self.similarVideoArray;
        }
    }
}


#pragma mark HKPlayerFullScreenSimilarVideoView  代理

/** cell 点击 */
- (void)hkplayerFullScreenCellClick:(NSIndexPath*)index sender:(id)sender  collectionView:(UICollectionView*)collectionView {
    
    if ([self.delegate respondsToSelector:@selector(zf_controlView:nextVideoAction:)]) {
        
        [self.delegate zf_controlView:self nextVideoAction:sender];
        self.repeatBtn.hidden = NO;
        //self.resolutionBtn.hidden = NO;
        
        if (self.verticalSimilarVideoView) {
            [self.verticalSimilarVideoView removeView];
        }
        TTVIEW_RELEASE_SAFELY(self.fullScreenSimilarVideoView);
        [MobClick event:UM_RECORD_DETAIL_PAGE_PLAY_FINISHED_RECOMMED];
    }
}


/** 重播 */
- (void)hkplayerFullScreenRepeatBtnClick:(id)sender {
    //self.resolutionBtn.hidden = NO;
    [self.fullScreenSimilarVideoView removeView];
    TTVIEW_RELEASE_SAFELY(self.fullScreenSimilarVideoView);
    [self repeatBtnClick:self.repeatBtn];
}


/****************  *******************/



/** 
 是否有下载功能 
 */
- (void)zf_playerHasDownloadFunction:(BOOL)sender {
    self.downLoadBtn.hidden = !sender;
}

/**
 是否有切换分辨率功能
 */

- (void)zf_playerResolutionArray:(NSArray *)resolutionArray {
    
    // **** 重新排序  汤彬添加倍速 ****
    resolutionArray = @[@"0.75x", @"1.0x", @"1.25x", @"1.5x", @"2.0x", @"3.0x"];
    //     **** 重新排序  汤彬添加倍速 ****
    
    _resolutionArray = resolutionArray;
    [_resolutionBtn setTitle:resolutionArray.firstObject forState:UIControlStateNormal];
    // 添加分辨率按钮和分辨率下拉列表
    self.resolutionView = [[UIView alloc] init];
    self.resolutionView.hidden = YES;
    self.resolutionView.backgroundColor = RGBA(0, 0, 0, 0.6); //RGBA(0, 0, 0, 0.2);
    [self addSubview:self.resolutionView];
    
    [self.resolutionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(IS_IPHONE6PLUS ?40 :36);
        make.height.mas_equalTo(29*resolutionArray.count);
        make.leading.equalTo(self.resolutionBtn.mas_leading).offset(0);
        make.top.equalTo(self.resolutionBtn.mas_bottom);
    }];
    
    // resolutionView 绘制 底部圆角
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.resolutionView.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.resolutionView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.resolutionView.layer.mask = maskLayer;
    });

    
    // 分辨率View上边的Btn
    for (NSInteger i = 0 ; i < resolutionArray.count; i++) {
        
        if (i>0) {
//            UILabel *lineLbael = [UILabel new];
//            lineLbael.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.15];
//            lineLbael.frame = CGRectMake(0, 29*i, (IS_IPHONE6PLUS ?40 :36), 1);
//            [self.resolutionView addSubview:lineLbael];
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 200+i;
        btn.frame = CGRectMake(0, 29*i, (IS_IPHONE6PLUS ?40 :36), 28);
        btn.titleLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ?12 :11];
        [btn setTitle:resolutionArray[i] forState:UIControlStateNormal];
        if (i == 0) {
            self.resoultionCurrentBtn = btn;
            btn.selected = YES;
        }
        [btn setTitleColor:COLOR_ffffff forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_FFD305 forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(changeResolution:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.resolutionView addSubview:btn];
        //默认选中第2个
        //if (i == 1) {   [self changeResolution:btn];    }
    }
    
    [self setPlayerRate];
}



/** 设置播放速率 */
- (void)setPlayerRate {
    
    // 记录的播放速率
    NSInteger selected = [HKNSUserDefaults integerForKey:HKPlayerPlayRate];
    if (selected) {
        UIButton *btn = [self.resolutionView viewWithTag:200 + (selected-1)];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self changeResolution:btn];
        });
    }else{
        // 默认选中第2个
        UIButton *btn = [self.resolutionView viewWithTag:201];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self changeResolution:btn];
        });
    }
}




/** 播放按钮状态 */
- (void)zf_playerPlayBtnState:(BOOL)state {
    self.startBtn.selected = state;
    //add 1020  计时器
    if (state) {
        [self.watchLabel start];
    }else{
        [self.watchLabel pause];
    }
}


/** 锁定屏幕方向按钮状态 */
- (void)zf_playerLockBtnState:(BOOL)state {
    self.lockBtn.selected = state;
}


/** 下载按钮状态 */
- (void)zf_playerDownloadBtnState:(BOOL)state {
    self.downLoadBtn.enabled = state;
}



//-------------- add 0908 ------------------//


- (HKPermissionVideoModel*)permissionVideoModel {
    if (!_permissionVideoModel) {
        _permissionVideoModel = [HKPermissionVideoModel new];
    }
    return  _permissionVideoModel;
}



#pragma mark - 观看 权限判断
- (void)getPermission:(DetailModel *)detailModel {
    WeakSelf;
    __block NSString *type = detailModel.video_type;
    if (isEmpty(detailModel.video_id)) {
        return;
    }
//    [[UserInfoServiceMediator sharedInstance] seeAndDownloadByVideoId:detailModel.video_id
//                                                            videoType:[type integerValue]
//                                                                token:nil
//                                                           completion:^(FWServiceResponse *response) {
    
    [[UserInfoServiceMediator sharedInstance] seeAndDownloadByVideoId:detailModel.video_id
                                                          VideoDetail:detailModel
                                                            videoType:[type integerValue]
                                                                token:nil
                                                            searchkey:nil
                                                        searchIdentify:nil
                                                           completion:^(FWServiceResponse *response) {
    
            if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
                StrongSelf;
                HKPermissionVideoModel *model = [HKPermissionVideoModel mj_objectWithKeyValues:response.data];
                strongSelf.permissionVideoModel = model;
                
                if ([type integerValue] == HKVideoType_PGC) {
                    if ([model.is_paly isEqualToString:@"1"]) {
                        strongSelf.checkVipStatus = CheckVipStatusTwo;
                    }
                }else{
                    strongSelf.checkVipStatus = CheckVipStatusTwo;
                }
                //is_paly：0-不可观看 1-可观看
                if (!isEmpty(model.vip_name) && [model.is_vip isEqualToString:@"0"]) {
                    
                    //BOOL isSerise = ([type integerValue] == HKVideoType_Series);// 系列课
                    //NSString *temp = [NSString stringWithFormat:@"您暂无%@VIP会员,每日免费学习一个教程",isSerise ?@"全站通" :model.class_name];
                    
                    NSString *temp = [NSString stringWithFormat:@"您暂无%@VIP会员,每日免费学习一个教程",model.vip_name];
                    NSMutableAttributedString *attributed = [NSMutableAttributedString changeCorlorWithColor:COLOR_ff7c00 TotalString:temp SubStringArray:@[@"VIP会员"]];
                    [strongSelf.lookCountTipLabel setAttributedText: attributed];
                }
                NSDictionary *dict =  @{@"LookPermissions":model,@"videoType":isEmpty(type) ?@"" :type};
                [MyNotification postNotificationName:KLookPermissionsNotification object:strongSelf userInfo:dict];
            }
    } failBlock:^(NSError *error) {
        
    }];
}





#pragma mark - 观看权限
- (void)lookPermissionsNotification:(NSNotification *)noti {
    
    #pragma mark - 播放 下载    is_vip：0-非VIP（不可下载） 1-限5VIP（不可下载） 2-全站VIP或分类无限VIP（可下载），is_paly：0-不可观看 1-可观看
    NSDictionary *dict = noti.userInfo;
    HKPermissionVideoModel *tempModel = dict[@"LookPermissions"];
    //add 1231
    BOOL isPGC = ([dict[@"videoType"] integerValue] == HKVideoType_PGC );
    
    if ([tempModel.is_paly isEqualToString:@"0"] && isPGC) {
        // 不能观看的 PGC 课程
        showTipDialog(GO_TO_PC_BUY_PGC);
        return;
    }
    
    if ([tempModel.is_paly isEqualToString:@"0"] && !isPGC) {
        [self setBuyVipView];
        return;
    }else{
        #pragma mark - 播放代理
        if ([self.delegate respondsToSelector:@selector(zf_controlView:playAction:)]) {
            
            self.videoUrl = tempModel.video_url;
            [self resetPlayTime:tempModel];
            
            //把 权限数据传到播放器
            [self.delegate zf_controlView:self permission:tempModel];
            [self.delegate zf_controlView:self playAction:nil];
            [self zf_playerShowOrHideControlView];
            [self hiddenLookCountTipLabel];
            //时间提示
            [self makeTimeViewAndConstraints];
            self.resolutionBtn.hidden = NO;
            
            if (self.detailModel.isFullScreen && !self.fullScreen) {
                //全屏
                [self fullScreenBtnClick:self.fullScreenBtn];
            }
        }
    }
}




#pragma mark - 观看进度  设置播放进度
- (void)getProgress:(DetailModel *)detailModel  sender:(UIButton *)sender {
    
    NSString *videoId = isEmpty(detailModel.video_id) ?self.playerModel.videoId :detailModel.video_id;
    
    NSInteger type = isEmpty(detailModel.video_id) ?self.playerModel.videoType :[detailModel.video_type integerValue];
    
    if (isEmpty(videoId)) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (NO == self.getProgress) {
            self.getProgress = YES;
            [self resetPlayTime:nil];
            [self playVideoBySeekTime:sender fullScreen:YES];
        }
    });
    
    [[UserInfoServiceMediator sharedInstance] seeAndDownloadByVideoId:videoId
                                                          VideoDetail:detailModel
                                                            videoType:type
                                                                token:nil
                                                            searchkey:nil
                                                       searchIdentify:nil
                                                           completion:^(FWServiceResponse *response) {
                                                               
       if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
           HKPermissionVideoModel *model = [HKPermissionVideoModel mj_objectWithKeyValues:response.data];
           [self resetPlayTime:model];
           if (NO == self.getProgress) {
               self.getProgress = YES;
               [self playVideoBySeekTime:sender fullScreen:YES];
           }
       }
   } failBlock:^(NSError *error) {
       
   }];
    
    if (self.getProgress) {
        [self playVideoBySeekTime:sender fullScreen:NO];
    }
}



#pragma mark - 1-重新设置进度播放    2-全屏播放
//- (void)playVideoBySeekTime:(UIButton *)sender
- (void)playVideoBySeekTime:(UIButton *)sender fullScreen:(BOOL)fullScreen {
    // 下载完成
    if ([self.delegate respondsToSelector:@selector(zf_controlView:playAction:)]) {
        [self.delegate zf_controlView:self playAction:sender];
        [self zf_playerShowOrHideControlView];
        [self hiddenLookCountTipLabel];
        //时间提示
        [self makeTimeViewAndConstraints];
        self.resolutionBtn.hidden = NO;
        if (fullScreen && !self.fullScreen) {
            //全屏
            [self fullScreenBtnClick:self.fullScreenBtn];
        }
    }
}



#pragma mark - 重置开始播放时间
- (void)resetPlayTime:(HKPermissionVideoModel *)model {
    
    DetailModel *detailM = [DetailModel new];
    if (self.videoStatus == HKDownloadFinished) {
        // 已下载
        detailM.video_id = self.playerModel.videoId;
        detailM.video_type = [NSString stringWithFormat:@"%d",self.playerModel.videoType];
    }else{
        detailM = self.detailModel;
    }
    NSString *date = [DateChange DateFromNetWorkString:model.play_time.updated_at];
    //本地时间记录
    HKSeekTimeModel *seekTimeM = [HKPlayerLocalRateTool querySeekModel:detailM];
    int day = [DateChange compareDate:seekTimeM.seekTimeUpdate withDate:date];
    if (day>=0) {
        // seekTimeUpdate 时间更近
        self.playerModel.seekTime = (seekTimeM == nil) ?0 :seekTimeM.seekTime;
    }else{
        self.playerModel.seekTime = model.play_time.time;
    }
}


- (void)setVideoId:(NSString *)videoId {
    _videoId = videoId;
}

#pragma mark - 查询下载状态
- (void)queryDownloadStatus {
    
    if (self.checkVideoStatus == CheckVideoStatusOnce) {
        HKDownloadModel *modeltemp = [[HKDownloadModel alloc] init];
        modeltemp.videoId = self.videoId;
        modeltemp.videoType = self.videoType;
        self.videoStatus = [[HKDownloadManager shareInstance] queryStatus:modeltemp];
    }
}
    
    



@end


