//
//  HKLiveCoursePlayerCell.m
//  Code
//
//  Created by hanchuangkeji on 2018/10/17.222
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKLiveCoursePlayer.h"
#import "TXLiteAVPlayerManager.h"
#import "LBLelinkKitManager.h"
#import "HKPlayBackPlayerControlView+Category.h"

@interface HKLiveCoursePlayer() <HKPlayBackPlayerControlViewDelegate>
@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong)TXLiteAVPlayerManager  *playerManager;
@property (nonatomic , strong) NSTimer * timer;
@property (nonatomic , assign) int timeCount;
@end

@implementation HKLiveCoursePlayer

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化播放器
        [self initPlayer];
        [self addPlayInfoView];
        
    }

    return self;
}

- (void)addPlayInfoView {
    
    HKLivePlayerInfoView *playInfoView = [HKLivePlayerInfoView viewFromXib];
    [self addSubview:playInfoView];
    [playInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    self.playInfoView = playInfoView;
    
    WeakSelf;
    playInfoView.backBtnClickBlock = ^{
        !weakSelf.backBtnClickBlock? : weakSelf.backBtnClickBlock();
    };
    
    playInfoView.shareBtnClickBlock = ^{
        !weakSelf.shareBtnClickBlock? : weakSelf.shareBtnClickBlock();
    };
    
    playInfoView.middleBtnClickBlock = ^{
        !weakSelf.middleBtnClickBlock? : weakSelf.middleBtnClickBlock();
        weakSelf.timeCount = 0;
        [self.timer setFireDate:[NSDate distantPast]];//开启
    };
    
    playInfoView.livingBtnClickBlock = ^{
        !weakSelf.livingBtnClickBlock? : weakSelf.livingBtnClickBlock();
    };
    
    playInfoView.countdownEndDataBlock = ^{
        !weakSelf.countdownEndDataBlock? : weakSelf.countdownEndDataBlock();
    };
}

- (void)setModel:(HKLiveDetailModel *)model {
    _model = model;
    
    [self.containerView setImageWithURLString:model.course.currentCover placeholder:[ZFUtilities imageWithColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1] size:CGSizeMake(1, 1)]];
    
    self.playInfoView.model = model;
}


- (UIImageView *)containerView {
    if (!_containerView) {
        _containerView = [UIImageView new];
        _containerView.contentMode = UIViewContentModeScaleAspectFill;
        _containerView.clipsToBounds = YES;
    }
    return _containerView;
}

- (void)initPlayer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeClick) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate distantFuture]];//关闭
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
//    ZFIJKPlayerManager *playerManager = [[ZFIJKPlayerManager alloc] init];
    /// 播放器相关
    
    self.player = [ZFPlayerController playerWithPlayerManager:self.playerManager containerView:self.containerView];
    self.player.controlView = self.controlView;
    /// 设置退到后台继续播放
    self.player.pauseWhenAppResignActive = YES;
    WeakSelf;
    /// 播放完成
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        [weakSelf.player.currentPlayerManager replay];
    };
    
    self.player.playerReadyToPlay = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
        weakSelf.timeCount = 0;
        [weakSelf.timer setFireDate:[NSDate distantFuture]];
        [weakSelf.controlView setPlayerSeekTime];
        //NSLog(@"^^^^^^^^^^^^^^^ 开始播放了");
    };
    self.player.playerPlayStateChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, ZFPlayerPlaybackState playState) {
        
        !weakSelf.playerPlayStateChanged? : weakSelf.playerPlayStateChanged(playState);
        
        if (playState == ZFPlayerPlayStateUnknown || playState == ZFPlayerPlayStatePlayFailed || playState == ZFPlayerPlayStatePlayStopped) {
            //NSLog(@"^^^^^^^^^^^^^^^ 播放状态 %lud", (unsigned long)playState);
            weakSelf.timeCount = 0;
            [weakSelf.timer setFireDate:[NSDate distantFuture]];
            [weakSelf.timer invalidate];
            weakSelf.timer = nil;
        }
    };
    
    self.player.notification.willResignActive = ^(ZFPlayerNotification * _Nonnull registrar) {
        
        if (weakSelf.player.isViewControllerDisappear) return;
        if (weakSelf.player.pauseWhenAppResignActive && weakSelf.player.currentPlayerManager.isPlaying) {
            if ([LBLelinkKitManager sharedManager].isAirPlay &&
                    ![LBLelinkKitManager sharedManager].isMirroring){
                //[weakSelf.player.currentPlayerManager play];
            }else{
                weakSelf.player.pauseByEvent = YES;
            }
        }
        if (weakSelf.player.isFullScreen && !weakSelf.player.isLockedScreen) weakSelf.player.orientationObserver.lockedScreen = YES;
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        if (!weakSelf.player.pauseWhenAppResignActive) {
            [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
        }
    };
}

- (void)timeClick{
    self.timeCount++;
    //NSLog(@"^^^^^^^^^^^^^^^ %d",self.timeCount);
    if ([self.controlView isDownloadFinsh:self.permissionModel]) return;
    if (self.timeCount == 5) {
        showTipDialog(@"网络不佳，请耐心等待哦 \n 或者尝试更换网络");
    }
}

- (HKPlayBackPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [HKPlayBackPlayerControlView new];
        _controlView.delegate = self;
        _controlView.fastViewAnimated = YES;
    }
    return _controlView;
}

#pragma mark <HKPlayBackPlayerControlViewDelegate>
- (void)backBtnClick {
    !self.backBtnClickBlock? : self.backBtnClickBlock();
}

- (void)hk_controlView:(UIView *)view resolutionAction:sender rate:(CGFloat)rate {
    !self.resolutionActionBlock? : self.resolutionActionBlock(rate);
}

/** 投屏 */
- (void)hk_playBackPlayerControlView:(UIView *)view airPlayBtn:(UIButton*)airPlayBtn fullScreen:(BOOL)fullScreen {
    
    if (self.airPlayGuideVCBlock) {
        self.airPlayGuideVCBlock(fullScreen);
    }
}




- (TXLiteAVPlayerManager*)playerManager {
    if (!_playerManager) {
        _playerManager = [[TXLiteAVPlayerManager alloc] init];
    }
    return _playerManager;
}

-(void)setPermissionModel:(HKPermissionVideoModel *)permissionModel{
    _permissionModel = permissionModel;
    NSLog(@"%@",permissionModel.mj_keyValues);    
//    self.playerManager.permissionM = permissionModel;
    self.controlView.permissionModel = permissionModel;
}

-(void)setSeekTime:(NSInteger)seekTime{
    _seekTime = seekTime;
    self.player.currentPlayerManager.seekTime = seekTime;
}
@end
