//
//  HKMusicPlayVC.m
//  GKAudioPlayerDemo
//
//  Created by Ivan li on 2018/3/18.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKMusicPlayVC.h"
#import "GKWYMusicControlView.h"
#import "GKPlayer.h"
#import "VideoModel.h"
#import "GKWYMusicTool.h"
#import "GKWYMusicLyricView.h"

#import "GKWYMusicCoverView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "HKMusicDetailModel.h"

#import "HKPermissionVideoModel.h"
#import "HKVIPCategoryVC.h"
#import "HKAudioTeachView.h"
#import "HKTeacherCourseVC.h"
#import "UIBarButtonItem+Extension.h"

#define Lost_link @"网络断开连接"



@interface HKMusicPlayVC ()<GKWYMusicControlViewDelegate, GKPlayerDelegate, GKWYMusicCoverViewDelegate,HKAudioTeachViewDelegate>

/*****************UI**********************/

//* 歌词视图
//@property (nonatomic, strong) GKWYMusicLyricView *lyricView;

//@property (nonatomic, strong) GKWYMusicListView *listView;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) GKWYMusicCoverView *coverView;

@property (nonatomic, strong) GKWYMusicControlView *controlView;


/**********************data*************************/

@property (nonatomic, strong) UIImage *coverImage;
/** 音乐原始播放列表 */
@property (nonatomic, strong) NSArray *musicList;
/** 当前播放的列表 */
@property (nonatomic, strong) NSArray *playList;
@property (nonatomic, strong) VideoModel *model;
//@property (nonatomic, strong) NSDictionary *songDic;
/** 乱序后的列表 */
@property (nonatomic, strong) NSArray *outOrderList;

@property (nonatomic, assign) HKPlayerPlayStyle playStyle; // 循环类型

@property (nonatomic, assign) BOOL isAutoPlay;    // 是否自动播放
@property (nonatomic, assign) BOOL isDraging;     // 是否正在拖拽
@property (nonatomic, assign) BOOL isSeeking;     // 是否在快进快退
@property (nonatomic, assign) BOOL isChanged;     // 是否正在切换歌曲
@property (nonatomic, assign) BOOL isCoverScroll; // 是否转盘在滑动

@property (nonatomic, assign) NSTimeInterval duration;      // 总时间
@property (nonatomic, assign) NSTimeInterval currentTime;   // 当前时间
@property (nonatomic, assign) NSTimeInterval positionTime;  // 锁屏时的滑杆时间
/** 当前播放时间 */
@property (nonatomic, assign) NSTimeInterval currentPlayTime;

@property (nonatomic, strong) NSTimer *seekTimer;  // 快进、快退定时器
/** 是否立即播放 */
@property (nonatomic, assign) BOOL ifNowPlay;

@property (nonatomic, strong)HKMusicDetailModel *detailModel;

@property (nonatomic, strong)GKPlayer *Player;

@property (nonatomic, strong)HKPermissionVideoModel *permissionModel;
/** 教师 视图 */
@property (nonatomic, strong)HKAudioTeachView  *teachView;



@end

@implementation HKMusicPlayVC

+ (instancetype)sharedInstance {
    static HKMusicPlayVC *playerVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerVC = [HKMusicPlayVC new];
    });
    return playerVC;
}



#pragma mark - Life Cycle
- (instancetype)init {
    if (self = [super init]) {
        
        [self.view addSubview:self.bgImageView];
        [self.view addSubview:self.coverView];
        //[self.view addSubview:self.lyricView];
        [self.view addSubview:self.controlView];
        [self.view addSubview:self.teachView];
        
        [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_equalTo(210);
        }];
        
        [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).offset(KNavBarHeight64+((IS_IPHONE6PLUS ||IS_IPHONE_X) ?PADDING_25*2 :0));
            make.bottom.equalTo(self.controlView.mas_top);
        }];
        
        //        [self.lyricView mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.left.right.equalTo(self.view);
        //            make.top.equalTo(self.navigationController.navigationBar.mas_bottom);
        //            make.bottom.equalTo(self.controlView.mas_top).offset(20);
        //        }];
        //[self.coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLyricView)]];
        //[self.lyricView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCoverView)]];
    }
    return self;
}


- (void)dealloc {
    [self seekTimeInvalidated];
    [self.coverView releaseTimer];
    [self removeNotifications];
}


- (void)didReceiveMemoryWarning {
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self addNotifications];
    // 设置播放器的代理
    self.Player.delegate = self;
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    [self.navigationController.navigationBar lt_setBackgroundColor:NAVBAR_Color];
    
    if (self.isPlaying) {
        [self stopMusic];
    }
    [self recordAudioPlayTime];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [HKBookPlayer hiddenWindowBooKView:NO];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
}


/** 记录播放时长 */
- (void)recordAudioPlayTime{
    
    NSInteger second = (self.currentPlayTime/1000);
    NSString *audioId = self.currentMusicId;
    if (second >0 && !isEmpty(audioId)) {
        //播放时长，单位：秒
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:audioId,@"audio_id",[NSString stringWithFormat:@"%ld",second],@"time",nil];
        
        [HKHttpTool POST:AUDIO_PLAY_TIME_STATS parameters:parameters success:^(id responseObject) {
            if (HKReponseOK) {
                
            }
        } failure:^(NSError *error) {
            
        }];
    }
}



#pragma mark - Public Methods
- (void)setupMusicList:(NSArray *)list {
    self.musicList = list;
    
    switch (self.playStyle) {
        case HKPlayerPlayStyleLoop:
        {
            self.outOrderList = nil;
            [self setCoverList:list];
        }
            break;
        case HKPlayerPlayStyleOne:
        {
            self.outOrderList = nil;
            [self setCoverList:list];
        }
            break;
        case HKPlayerPlayStyleRandom:
        {
            self.outOrderList = [self randomArray:list];
            [self setCoverList:self.outOrderList];
        }
            break;
            
        default:
            break;
    }
}


- (void)playMusicWithIndex:(NSInteger)index list:(NSArray *)list {
    
    self.playList = list;
    VideoModel *model = list[index];
    
    [self.coverView setupMusicList:list idx:index];
    self.currentMusicId = model.audio_id;
    self.model = model;
    
    [self getMusicInfo];
}



- (void)loadMusicWithIndex:(NSInteger)index list:(NSArray *)list {
    self.musicList = list;
    
    VideoModel *model = list[index];
    
    if (![model.audio_id isEqualToString:self.currentMusicId]) {
        
        [self.coverView setupMusicList:list idx:index];
        self.currentMusicId = model.audio_id;
        self.ifNowPlay = NO;
        
        // 记录播放的id
        //[[NSUserDefaults standardUserDefaults] setValue:model.audio_id forKey:kPlayerLastPlayIDKey];
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"WYPlayerChangeMusicNotification" object:nil];
        self.model = model;
        [self getMusicInfo];
    }
}

- (void)playMusic {
    // 首先检查网络状态
    if ([HkNetworkManageCenter shareInstance].networkStatus <=0) {
        showTipDialog(Lost_link);
        // 设置播放状态为暂停
        [self.controlView setupPauseBtn];
        return;
    }else {
        if (self.Player == nil) {
            return;
        }
        
        if (isEmpty(self.Player.playUrlStr)) { // 没有播放地址
            // 需要重新请求
            if (isLogin()) {
                [self getMusicInfo];
            }else{
                
            }
        }else {
            if (self.Player.playState != GKPlayerStatusPaused) {
                [self.Player play];
            }else {
                [self.Player resume];
            }
            self.ifNowPlay = YES;
        }
    }
}



- (void)pauseMusic {
    if (self.Player) {
        [self.Player pause];
    }
}



- (void)stopMusic {
    if (self.Player) {
        [self.Player stop];
    }
}



- (void)playNextMusic {
    
    return;
    // 重置封面
    [self.coverView resetCover];
    
    // 播放
    if (self.playStyle == HKPlayerPlayStyleLoop) {
        NSArray *musicList = self.musicList;
        
        __block NSUInteger currentIndex = 0;
        [musicList enumerateObjectsUsingBlock:^(VideoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.audio_id isEqualToString:self.model.audio_id]) {
                currentIndex = idx;
                *stop = YES;
            }
        }];
        
        [self playNextMusicWithList:musicList index:currentIndex];
    }else if (self.playStyle == HKPlayerPlayStyleOne) {
        if (self.isAutoPlay) {  // 循环播放自动播放完毕
            NSArray *musicList = self.musicList;
            __block NSUInteger currentIndex = 0;
            [musicList enumerateObjectsUsingBlock:^(VideoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.audio_id isEqualToString:self.model.audio_id]) {
                    currentIndex = idx;
                    *stop = YES;
                }
            }];
            
            // 重置列表
            [self.coverView resetMusicList:musicList idx:currentIndex];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //                [self.Player play];
                [self playMusic];
            });
        }else {  // 循环播放切换歌曲
            NSArray *musicList = self.musicList;
            
            __block NSUInteger currentIndex = 0;
            [musicList enumerateObjectsUsingBlock:^(VideoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.audio_id isEqualToString:self.model.audio_id]) {
                    currentIndex = idx;
                    *stop = YES;
                }
            }];
            
            [self playNextMusicWithList:musicList index:currentIndex];
        }
    }else {
        if (!self.outOrderList) {
            self.outOrderList = [self randomArray:self.musicList];
        }
        NSArray *musicList = self.outOrderList;
        
        // 找出乱序后当前播放歌曲的索引
        __block NSInteger currentIndex = 0;
        [musicList enumerateObjectsUsingBlock:^(VideoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.audio_id isEqualToString:self.model.audio_id]) {
                currentIndex = idx;
                *stop = YES;
            }
        }];
        
        [self playNextMusicWithList:musicList index:currentIndex];
    }
}



- (void)playNextMusicWithList:(NSArray *)musicList index:(NSInteger)currentIndex {
    // 列表已经打乱顺序，直接播放下一首即可
    if (currentIndex < musicList.count - 1) {
        currentIndex ++;
    }else {
        currentIndex = 0;
    }
    
    // 切换到下一首
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.coverView scrollChangeIsNext:YES Finished:^{
            [self playMusicWithIndex:currentIndex list:musicList];
        }];
    });
}



- (void)playPrevMusic {
    // 重置封面
    [self.coverView resetCover];
    
    // 播放
    if (self.playStyle == HKPlayerPlayStyleLoop) {
        NSArray *musicList = self.musicList;
        
        __block NSUInteger currentIndex = 0;
        [musicList enumerateObjectsUsingBlock:^(VideoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.audio_id isEqualToString:self.model.audio_id]) {
                currentIndex = idx;
                *stop = YES;
            }
        }];
        
        if (currentIndex > 0) {
            currentIndex --;
        }else if (currentIndex == 0) {
            currentIndex = musicList.count - 1;
        }
        
        [self playPrevMusicWithList:musicList index:currentIndex];
        
    }else if (self.playStyle == HKPlayerPlayStyleOne) {
        NSArray *musicList = self.musicList;
        
        __block NSUInteger currentIndex = 0;
        [musicList enumerateObjectsUsingBlock:^(VideoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.audio_id isEqualToString:self.model.audio_id]) {
                currentIndex = idx;
                *stop = YES;
            }
        }];
        
        [self playPrevMusicWithList:musicList index:currentIndex];
    }else {
        if (!self.outOrderList) {
            self.outOrderList = [self randomArray:self.musicList];
        }
        NSArray *musicList = self.outOrderList;
        
        // 找出乱序后当前播放歌曲的索引
        __block NSInteger currentIndex = 0;
        [musicList enumerateObjectsUsingBlock:^(VideoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.audio_id isEqualToString:self.model.audio_id]) {
                currentIndex = idx;
                *stop = YES;
            }
        }];
        
        [self playPrevMusicWithList:musicList index:currentIndex];
    }
}

- (void)playPrevMusicWithList:(NSArray *)musicList index:(NSInteger)currentIndex {
    // 列表已经打乱顺序，直接播放上一首一首即可
    if (currentIndex > 0) {
        currentIndex --;
    }else if (currentIndex == 0) {
        currentIndex = self.musicList.count - 1;
    }
    
    // 切换到下一首
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.coverView scrollChangeIsNext:NO Finished:^{
            [self playMusicWithIndex:currentIndex list:musicList];
        }];
    });
}

- (NSArray *)randomArray:(NSArray *)arr {
    NSArray *randomArr = [arr sortedArrayUsingComparator:^NSComparisonResult(VideoModel *obj1, VideoModel *obj2) {
        int seed = arc4random_uniform(2);
        if (seed) {
            return [obj1.audio_id compare:obj2.audio_id];
        }else {
            return [obj2.audio_id compare:obj1.audio_id];
        }
    }];
    
    return randomArr;
}

#pragma mark - Private Methods
- (void)setupUI {
    
    [self createLeftBarButton];
    self.view.backgroundColor  = COLOR_FFFFFF_3D4752;
    // 获取播放方式，并设置
    //self.playStyle = [[NSUserDefaults standardUserDefaults] integerForKey:kPlayerPlayStyleKey];
    self.controlView.style = GKWYPlayerPlayStyleOne;//self.playStyle;
}

- (void)createLeftBarButton {
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem BarButtonItemWithBackgroudImageName:@"nac_back_white"
                                                                          highBackgroudImageName:@"nac_back_white"
                                                                                          target:self
                                                                                          action:@selector(backAction)];
}



- (void)showCoverView {
    self.coverView.hidden           = NO;
    self.controlView.topView.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        //self.lyricView.alpha            = 0.0;
        self.coverView.alpha            = 1.0;
        self.controlView.topView.alpha  = 1.0;
    }completion:^(BOOL finished) {
        //self.lyricView.hidden           = YES;
        //[self.lyricView showSystemVolumeView];
        self.coverView.hidden           = NO;
        self.controlView.topView.hidden = NO;
    }];
}


- (void)getMusicInfo {
    [self setupTitleWithModel:self.model];
    
    if (self.isPlaying) {
        self.isPlaying = NO;
        if (self.Player) {
            [self.Player stop];
        }
    }
    [self.controlView setupInitialData];
    // 背景图
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:self.model.cover_url]] placeholderImage:[UIImage imageNamed:@"cm2_fm_bg-ip6"]];
    
    // 初始化数据
    //self.lyricView.lyrics = nil;
    // 重新设置锁屏控制界面
    [self setupLockScreenControlInfo];
    [self setupLockScreenMediaInfoNull];
    
    [self getMusicDetailInfo];
    [self getMusicURL];
}


/** 获取 音频URL */
- (void)getMusicURL {
    
    if (!isLogin()) {return;}
    WeakSelf;
    [HKHttpTool POST:AUDIO_PLAY parameters:@{@"audio_id":self.model.audio_id} success:^(id responseObject) {
        //is_paly：0-不可观看 1-可观看；class_type：播放受限时请求VIP列表接口要携带
        StrongSelf;
        if (HKReponseOK) {
            // 设置播放地址
            //            NSString *tempUrl = @"https://m3u8.huke88.com/audio/hls/2018-03-14/87DCE218-52E6-666E-DCE2-4F378157980B.m3u8?pm3u8/0/deadline/1523605425&e=1523605425&token=HUwgVvJnrW6fXOzqd_myfnE3FFoFLWJnNktg7ThD:1NEYvOg0HqQh_3KAFhOT95Amk5M=";
            
            NSString *name = @"MusicName";
            HKPermissionVideoModel *model = [HKPermissionVideoModel mj_objectWithKeyValues:responseObject[@"data"]];
            NSDictionary *dict = @{@"model":model};
            HK_NOTIFICATION_POST_DICT(name, strongSelf, dict);
            
        }
    } failure:^(NSError *error) {
        
    }];
}




- (void)playMusicNotifications:(NSNotification*)noti {
    
    NSDictionary *dict = noti.userInfo;
    HKPermissionVideoModel *model = dict[@"model"];
    
    if (self) {
        if ([model.is_paly isEqualToString:@"0"]) {
            [self pushToVipWithModel:model];
        }else{
            self.ifNowPlay = YES;
            if (self.Player) {
                self.permissionModel = model;
                self.Player.playUrlStr = model.video_url;
                if (self.ifNowPlay) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.Player play];
                    });
                }
            }
        }
    }
}




/** 详情 */
- (void)getMusicDetailInfo {
    
    [HKHttpTool POST:AUDIO_DETAIL parameters:@{@"audio_id":self.model.audio_id} success:^(id responseObject) {
        if (HKReponseOK) {
            self.detailModel = [HKMusicDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.teachView.userInfo = self.detailModel.teacher_info;
        }
    } failure:^(NSError *error) {
        
    }];
}




#pragma mark - 跳转购买VIP
- (void)pushToVipWithModel:(HKPermissionVideoModel*)model {
    
    WeakSelf;
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        label.text = @"温馨提示";
        label.textColor = [UIColor blackColor];
    })
    .LeeAddContent(^(UILabel *label) {
        label.text = @"您的权限不足,无法收听视频哦~";
        label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        action.title = @"暂不升级";
        action.titleColor = COLOR_333333;
        action.backgroundColor = [UIColor whiteColor];
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        action.title = @"升级权限";
        action.titleColor = COLOR_ff7c00;
        action.backgroundColor = [UIColor whiteColor];
        action.clickBlock = ^{
            
            if (!isEmpty(model.class_type)) {
                HKVIPCategoryVC *VC = [HKVIPCategoryVC new];
                VC.class_type = model.class_type;
                [weakSelf pushToOtherController:VC];
            }
        };
    })
    .LeeHeaderColor([UIColor whiteColor])
    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
    .LeeShow();
}






- (void)setupTitleWithModel:(VideoModel *)model {
    //self.title = model.title;
    [self setTitle:model.title color:[UIColor whiteColor]];
}


- (void)addNotifications {
    [self userLoginAndLogotObserver];
    
    HK_NOTIFICATION_ADD_OBJ(@"MusicName",(playMusicNotifications:), self);
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    // 播放打断
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionInterruption:) name:AVAudioSessionInterruptionNotification object:nil];
}


- (void)removeNotifications {
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    HK_NOTIFICATION_REMOVE();
}



- (void)shareAction {
    
}


- (void)setupLockScreenControlInfo {
    
//    WeakSelf;
//    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
//    // 锁屏播放
//    [commandCenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//        if (!weakSelf.isPlaying) {
//            [weakSelf playMusic];
//        }
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
//    // 锁屏暂停
//    [commandCenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//        if (weakSelf.isPlaying) {
//            [weakSelf pauseMusic];
//        }
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
//
//    [commandCenter.stopCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//        [weakSelf pauseMusic];
//
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
//
//    // 喜欢按钮
//    MPFeedbackCommand *likeCommand = commandCenter.likeCommand;
//    likeCommand.enabled        = NO;
//    likeCommand.active         = self.model.isLike;
//    likeCommand.localizedTitle = self.model.isLike ? @"取消喜欢" : @"喜欢";
//    [likeCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//
//        [weakSelf lovedCurrentMusic];
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
//    // 上一首
//    MPFeedbackCommand *dislikeCommand = commandCenter.dislikeCommand;
//    dislikeCommand.enabled = NO;
//    dislikeCommand.localizedTitle = @"上一首";
//    [dislikeCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//
//        NSLog(@"上一首");
//        [weakSelf playPrevMusic];
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
//
//    // 播放和暂停按钮（耳机控制）
//    MPRemoteCommand *playPauseCommand = commandCenter.togglePlayPauseCommand;
//    playPauseCommand.enabled = YES;
//    [playPauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//
//        if (weakSelf.isPlaying) {
//            NSLog(@"暂停");
//            [weakSelf pauseMusic];
//        }else {
//            NSLog(@"播放");
//            [weakSelf playMusic];
//        }
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
//
//    // 上一曲
//    MPRemoteCommand *previousCommand = commandCenter.previousTrackCommand;
//    previousCommand.enabled = NO;
//    [previousCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//
//        [weakSelf playPrevMusic];
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
//
//
//
//    // 下一曲
//    MPRemoteCommand *nextCommand = commandCenter.nextTrackCommand;
//    nextCommand.enabled = NO;
//    [nextCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//
//        weakSelf.isAutoPlay = NO;
//        [weakSelf playNextMusic];
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
//
//    // 快进
//    MPRemoteCommand *forwardCommand = commandCenter.seekForwardCommand;
//    forwardCommand.enabled = YES;
//    [forwardCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//
//        MPSeekCommandEvent *seekEvent = (MPSeekCommandEvent *)event;
//        if (seekEvent.type == MPSeekCommandEventTypeBeginSeeking) {
//            [weakSelf seekingForwardStart];
//        }else {
//            [weakSelf seekingForwardStop];
//        }
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
//
//    // 快退
//    MPRemoteCommand *backwardCommand = commandCenter.seekBackwardCommand;
//    backwardCommand.enabled = YES;
//    [backwardCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//
//        MPSeekCommandEvent *seekEvent = (MPSeekCommandEvent *)event;
//        if (seekEvent.type == MPSeekCommandEventTypeBeginSeeking) {
//            [weakSelf seekingBackwardStart];
//        }else {
//            [weakSelf seekingBackwardStop];
//        }
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
//
//    // 拖动进度条
//    if ([UIDevice currentDevice].systemVersion.doubleValue >= 9.0) {
//        [commandCenter.changePlaybackPositionCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//
//            MPChangePlaybackPositionCommandEvent *positionEvent = (MPChangePlaybackPositionCommandEvent *)event;
//
//            if (positionEvent.positionTime != weakSelf.positionTime) {
//                weakSelf.positionTime = positionEvent.positionTime;
//
//                weakSelf.currentTime = weakSelf.positionTime ;//* 1000;
//
//                weakSelf.Player.seekTime = weakSelf.currentTime;
//                //weakSelf.Player.progress = (float)weakSelf.currentTime / weakSelf.duration;
//            }
//            return MPRemoteCommandHandlerStatusSuccess;
//        }];
//    }
}



- (void)setupLockScreenMediaInfo {
//    // 1. 获取当前播放的歌曲的信息
//    if (!self.detailModel) {
//        return;
//    }
//
//    // 2. 获取锁屏界面中心
//    MPNowPlayingInfoCenter *playingCenter = [MPNowPlayingInfoCenter defaultCenter];
//    // 3. 设置展示的信息
//    NSMutableDictionary *playingInfo = [NSMutableDictionary new];
//    playingInfo[MPMediaItemPropertyAlbumTitle] = self.detailModel.audio_info.title; //songDic[@"albumName"];
//    playingInfo[MPMediaItemPropertyTitle]      = self.detailModel.audio_info.title;//songDic[@"songName"];
//    playingInfo[MPMediaItemPropertyArtist]  = self.detailModel.teacher_info.name; //songDic[@"artistName"];
//
//    MPMediaItemArtwork *artwork = nil;
//    if (!self.bgImageView.image) {
//        artwork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"lockscreen_bg"]];
//    }else{
//        artwork = [[MPMediaItemArtwork alloc] initWithImage:self.bgImageView.image];
//    }
//    playingInfo[MPMediaItemPropertyArtwork] = artwork;
//
//    // 当前播放的时间
//    playingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = [NSNumber numberWithFloat:(self.duration * self.controlView.value)]; /// 1000];
//    // 进度的速度
//    playingInfo[MPNowPlayingInfoPropertyPlaybackRate] = [NSNumber numberWithFloat:1.0];
//    // 总时间
//    playingInfo[MPMediaItemPropertyPlaybackDuration] = [NSNumber numberWithFloat:self.duration ];/// 1000];
//    if ([UIDevice currentDevice].systemVersion.doubleValue >= 10.0) {
//        playingInfo[MPNowPlayingInfoPropertyPlaybackProgress] = [NSNumber numberWithFloat:self.controlView.value];
//    }
//    playingCenter.nowPlayingInfo = playingInfo;
}



- (void)setupLockScreenMediaInfoNull {
    
//    // 2. 获取锁屏界面中心
//    MPNowPlayingInfoCenter *playingCenter = [MPNowPlayingInfoCenter defaultCenter];
//    // 3. 设置展示的信息
//    NSMutableDictionary *playingInfo = [NSMutableDictionary new];
//    playingInfo[MPMediaItemPropertyAlbumTitle] = self.model.title;
//    playingInfo[MPMediaItemPropertyTitle]      = self.model.title;
//    playingInfo[MPMediaItemPropertyArtist]     = self.model.title;
//    
//    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"lockscreen_bg"]];
//    playingInfo[MPMediaItemPropertyArtwork] = artwork;
//    
//    // 当前播放的时间
//    playingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = [NSNumber numberWithFloat:(self.duration * self.controlView.value) ];/// 1000];
//    // 进度的速度
//    playingInfo[MPNowPlayingInfoPropertyPlaybackRate] = [NSNumber numberWithFloat:1.0];
//    // 总时间
//    playingInfo[MPMediaItemPropertyPlaybackDuration] = [NSNumber numberWithFloat:self.duration ];/// 1000];
//    if ([UIDevice currentDevice].systemVersion.doubleValue >= 10.0) {
//        playingInfo[MPNowPlayingInfoPropertyPlaybackProgress] = [NSNumber numberWithFloat:self.controlView.value];
//    }
//    playingCenter.nowPlayingInfo = playingInfo;
}



- (void)lovedCurrentMusic {
    [self.musicList enumerateObjectsUsingBlock:^(VideoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.audio_id isEqualToString:self.model.audio_id]) {
            obj.isLike = !obj.isLike;
            self.model = obj;
            *stop      = YES;
        }
    }];
    
    [GKWYMusicTool saveMusicList:self.musicList];
    self.controlView.is_love = self.model.isLike;
    
    [self setupLockScreenControlInfo];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WYMusicLovedMusicNotification" object:nil];
}


#pragma mark - 快进快退方法

// 快进开始
- (void)seekingForwardStart {
    if (!self.isPlaying) return;
    self.isSeeking = YES;
    
    self.currentTime = self.controlView.value * self.duration;
    
    self.seekTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(seekingForwardAction) userInfo:nil repeats:YES];
}

// 快进结束
- (void)seekingForwardStop {
    if (!self.isPlaying) return;
    self.isSeeking = NO;
    [self seekTimeInvalidated];
    
    self.Player.seekTime = self.currentTime;
    //self.Player.progress = (float)self.currentTime / self.duration;
}

- (void)seekingForwardAction {
    if (self.currentTime >= self.duration) {
        [self seekTimeInvalidated];
    }else {
        self.currentTime += 1000;
        
        self.controlView.value = self.duration == 0 ? 0 : (float)self.currentTime / self.duration;
        
        self.controlView.currentTime = [GKTool timeStrWithSecTime:self.currentTime];
    }
}

// 快退开始
- (void)seekingBackwardStart {
    if (!self.isPlaying) return;
    
    self.isSeeking   = YES;
    self.currentTime = self.controlView.value * self.duration;
    self.seekTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(seekingBackwardAction) userInfo:nil repeats:YES];
}


// 快退结束
- (void)seekingBackwardStop {
    if (!self.isPlaying) return;
    
    self.isSeeking = NO;
    [self seekTimeInvalidated];
    self.Player.seekTime = self.currentTime;
    //self.Player.progress = (float)self.currentTime / self.duration;
}


- (void)seekingBackwardAction {
    if (self.currentTime <= 0) {
        [self seekTimeInvalidated];
    }else {
        self.currentTime-= 1000;
        self.controlView.value = self.duration == 0 ? 0 : (float)self.currentTime / self.duration;
        self.controlView.currentTime = [GKTool timeStrWithSecTime:self.currentTime];
    }
}


- (void)seekTimeInvalidated {
    if (self.seekTimer) {
        [self.seekTimer invalidate];
        self.seekTimer = nil;
    }
}


#pragma mark - Notifications

- (void)audioSessionInterruption:(NSNotification *)notify {
    NSDictionary *interuptionDict = notify.userInfo;
    
    NSInteger interruptionType = [interuptionDict[AVAudioSessionInterruptionTypeKey] integerValue];
    NSInteger interruptionOption = [interuptionDict[AVAudioSessionInterruptionOptionKey] integerValue];
    
    if (interruptionType == AVAudioSessionInterruptionTypeBegan) {
        // 收到播放中断的通知，暂停播放
        if (self.isPlaying) {
            [self pauseMusic];
            self.isPlaying = NO;
        }
    }else {
        // 中断结束，判断是否需要恢复播放
        if (interruptionOption == AVAudioSessionInterruptionOptionShouldResume) {
            if (!self.isPlaying) {
                [self playMusic];
                self.isPlaying = YES;
            }
        }
    }
}


#pragma mark - 代理
#pragma mark - GKPlayerDelegate
- (void)gkPlayer:(GKPlayer *)player statusChanged:(GKPlayerStatus)status {
    switch (status) {
        case GKPlayerStatusBuffering:
        {
            //[self.controlView showPlayBtnLoadingAnim];
            //[self.controlView hideLoadingAnim];
            
            self.isPlaying = YES;
            [self.coverView playedWithAnimated:YES];
        }
            break;
        case GKPlayerStatusPlaying:
        {
            //[self.controlView hideLoadingAnim];
            //[self.controlView hidePlayBtnLoadingAnim];
            
            [self.controlView setupPlayBtn];
            self.isPlaying = YES;
            [self.coverView playedWithAnimated:YES];
        }
            break;
        case GKPlayerStatusPaused:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.controlView setupPauseBtn];
            });
            self.isPlaying = NO;
            
            if (self.isChanged) {
                self.isChanged = NO;
            }else {
                [self.coverView pausedWithAnimated:YES];
            }
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
        }
            break;
        case GKPlayerStatusStopped:
        {
            NSLog(@"播放停止了");
            [self.controlView setupPauseBtn];
            self.isPlaying = NO;
            
            if (self.isChanged) {
                self.isChanged = NO;
            }else {
                [self.coverView pausedWithAnimated:YES];
            }
        }
            break;
        case GKPlayerStatusEnded:
        {
            NSLog(@"播放结束了");
            if (self.isPlaying) {
                [self.controlView setupPauseBtn];
                self.isPlaying = NO;
                
                [self.coverView pausedWithAnimated:YES];
                
                self.controlView.currentTime = self.controlView.totalTime;
                
                //                // 播放结束，自动播放下一首
                //                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //                    self.isAutoPlay = YES;
                //                    [self playNextMusic];
                //                });
            }else {
                [self.controlView setupPauseBtn];
                self.isPlaying = NO;
                [self.coverView pausedWithAnimated:YES];
            }
        }
            break;
        case GKPlayerStatusError:
        {
            NSLog(@"播放出错了");
            [self.controlView setupPauseBtn];
            self.isPlaying = NO;
            [self.coverView pausedWithAnimated:YES];
        }
            break;
            
        default:
            break;
    }
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"WYMusicPlayStateChanged" object:nil];
}


#pragma mark - 缓冲状态
- (void)gkPlayer:(GKPlayer *)player loadState:(GKPlayerLoadState)loadState {
    
    switch (loadState) {
        case GKPlayerLoadStateUnknown:
            //加载状态变成了未知状态
            break;
        case GKPlayerLoadStatePrepare:
        {
            //准备加载状态
            [self.controlView showPlayBtnLoadingAnim];
            [self.controlView hideLoadingAnim];
        }
            break;
        case GKPlayerLoadStatePlayable:
            // 加载状态变成了缓存数据足够开始播放，但是视频并没有缓存完全
            [self.controlView hideLoadingAnim];
            [self.controlView hidePlayBtnLoadingAnim];
            break;
            
        case GKPlayerLoadStatePlaythroughOK:
        {
            // 加载完成，即将播放，停止加载的动画，并将其移除
            [self.controlView hideLoadingAnim];
            [self.controlView hidePlayBtnLoadingAnim];
        }
            break;
        case GKPlayerLoadStateStalled:
            // 可能由于网速不好等因素导致了暂停，重新添加加载的动画
            [self.controlView showPlayBtnLoadingAnim];
            [self.controlView hideLoadingAnim];
            break;
        default:
            break;
    }
}



- (void)gkPlayer:(GKPlayer *)player currentTime:(NSTimeInterval)currentTime
       totalTime:(NSTimeInterval)totalTime bufferProgress:(float)bufferProgress
        progress:(float)progress {
    if (self.isDraging) return;
    if (self.isSeeking) return;
    
    self.currentPlayTime = currentTime;
    self.controlView.currentTime = [GKTool timeStrWithSecTime:currentTime];
    self.controlView.value       = progress;
    
    // 更新锁屏界面
    [self setupLockScreenMediaInfo];
    // 滚动歌词
    if (!self.isPlaying) return;
    
    //[self.lyricView scrollLyricWithCurrentTime:currentTime totalTime:totalTime];
}


- (void)gkPlayer:(GKPlayer *)player duration:(NSTimeInterval)duration {
    self.controlView.totalTime = [GKTool timeStrWithSecTime:duration];
    self.duration = duration;
}


#pragma mark - GKWYMusicVolumeViewDelegate
- (void)volumeSlideTouchBegan {
    //    self.gk_fullScreenPopDisabled = YES;
}

- (void)volumeSlideTouchEnded {
    //    self.gk_fullScreenPopDisabled = NO;
}

#pragma mark - GKWYMusicControlViewDelegate
- (void)controlView:(GKWYMusicControlView *)controlView didClickLove:(UIButton *)loveBtn {
    [self lovedCurrentMusic];
    /*
     if (self.model.isLike) {
     [GKMessageTool showSuccess:@"已添加到我喜欢的音乐" toView:self.view imageName:@"cm2_play_icn_loved" bgColor:[UIColor blackColor]];
     }else {
     [GKMessageTool showText:@"已取消喜欢" toView:self.view bgColor:[UIColor blackColor]];
     }
     */
}

- (void)controlView:(GKWYMusicControlView *)controlView didClickDownload:(UIButton *)downloadBtn {
    NSLog(@"下载");
}

- (void)controlView:(GKWYMusicControlView *)controlView didClickComment:(UIButton *)commentBtn {
    NSLog(@"评论");
}

- (void)controlView:(GKWYMusicControlView *)controlView didClickMore:(UIButton *)moreBtn {
    NSLog(@"更多");
}

- (void)controlView:(GKWYMusicControlView *)controlView didClickLoop:(UIButton *)loopBtn {
    /*
     if (self.playStyle == HKPlayerPlayStyleLoop) {  // 循环->单曲
     self.playStyle = HKPlayerPlayStyleOne;
     self.outOrderList = nil;
     
     [self setCoverList:self.musicList];
     }else if (self.playStyle == HKPlayerPlayStyleOne) { // 单曲->随机
     self.playStyle = HKPlayerPlayStyleRandom;
     self.outOrderList = [self randomArray:self.musicList];
     
     [self setCoverList:self.outOrderList];
     }else { // 随机-> 循环
     self.playStyle = HKPlayerPlayStyleLoop;
     self.outOrderList = nil;
     
     [self setCoverList:self.musicList];
     }
     self.controlView.style = self.playStyle;
     
     [[NSUserDefaults standardUserDefaults] setInteger:self.playStyle forKey:kPlayerPlayStyleKey];
     */
}

- (void)setCoverList:(NSArray *)musicList {
    __block NSUInteger currentIndex = 0;
    [musicList enumerateObjectsUsingBlock:^(VideoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.audio_id isEqualToString:self.model.audio_id]) {
            currentIndex = idx;
            *stop = YES;
        }
    }];
    
    // 重置列表
    [self.coverView resetMusicList:musicList idx:currentIndex];
}

- (void)controlView:(GKWYMusicControlView *)controlView didClickPrev:(UIButton *)prevBtn {
    if (self.isCoverScroll) return;
    self.isChanged = YES;
    
    if (self.isPlaying) {
        [self.Player stop];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playPrevMusic];
    });
}

- (void)controlView:(GKWYMusicControlView *)controlView didClickPlay:(UIButton *)playBtn {
    
    if (!isLogin()) {
        [self setLoginVC];
        return;
    }else{
        
        if (!self.Player.playUrlStr) { // 没有播放地址
            // 需要重新请求
            [self getMusicURL];
        }else{
            if (self.isPlaying) {
                [self pauseMusic];
            }else {
                [self playMusic];
            }
        }
        playBtn.selected = !playBtn.selected;
        if (playBtn.selected) {
            [controlView setupPlayBtn];
        }else {
            [controlView setupPauseBtn];
        }
    }
}

- (void)controlView:(GKWYMusicControlView *)controlView didClickNext:(UIButton *)nextBtn {
    
    if (!isLogin()) {
        return;
    }
    if (self.isCoverScroll) return;
    
    self.isAutoPlay = NO;
    
    if (self.isPlaying) {
        [self.Player stop];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isChanged  = YES;
        [self playNextMusic];
    });
}

- (void)controlView:(GKWYMusicControlView *)controlView didClickList:(UIButton *)listBtn {
    
    /*
     self.listView.gk_size = CGSizeMake(self.view.gk_width, 440);
     self.listView.listArr = self.musicList;
     
     [GKCover coverFrom:self.navigationController.view contentView:self.listView style:GKCoverStyleTranslucent showStyle:GKCoverShowStyleBottom animStyle:GKCoverAnimStyleBottom notClick:NO showBlock:^{
     self.gk_interactivePopDisabled = YES;
     } hideBlock:^{
     self.gk_interactivePopDisabled = NO;
     }];
     */
    
}

- (void)controlView:(GKWYMusicControlView *)controlView didSliderTouchBegan:(float)value {
    if (!isLogin()) {
        return;
    }
    self.isDraging = YES;
    //    // 防止手势冲突
    //    self.gk_fullScreenPopDisabled = YES;
}

- (void)controlView:(GKWYMusicControlView *)controlView didSliderTouchEnded:(float)value {
    if (!isLogin()) {
        return;
    }
    self.isDraging = NO;
    
    self.controlView.currentTime = [GKTool timeStrWithSecTime:(self.duration * value)];
    self.Player.seekTime = self.duration * value;
    
    if (!self.Player.isPlaying) {
        [self.Player play];
    }
    
    //self.Player.progress = value;
    
    // 滚动歌词到对应位置
    //[self.lyricView scrollLyricWithCurrentTime:(self.duration * value) totalTime:self.duration];
}

- (void)controlView:(GKWYMusicControlView *)controlView didSliderValueChange:(float)value {
    if (!isLogin()) {
        return;
    }
    self.isDraging = YES;
    self.controlView.currentTime = [GKTool timeStrWithSecTime:(self.duration * value)];
}

- (void)controlView:(GKWYMusicControlView *)controlView didSliderTapped:(float)value {
    if (!isLogin()) {
        return;
    }
    self.controlView.currentTime = [GKTool timeStrWithSecTime:(self.duration * value)];
    self.Player.seekTime = self.duration * value;
    //self.Player.progress = value;
    
    // 滚动歌词到对应位置
    //[self.lyricView scrollLyricWithCurrentTime:(self.duration * value) totalTime:self.duration];
}

#pragma mark - GKWYMusicCoverViewDelegate
- (void)scrollDidScroll {
    self.isCoverScroll = YES;
}

- (void)scrollWillChangeModel:(VideoModel *)model {
    
    [self setupTitleWithModel:model];
}

- (void)scrollDidChangeModel:(VideoModel *)model {
    
    //NSLog(@"结束");
    self.isCoverScroll = NO;
    if (self.isChanged) return;
    
    [self setupTitleWithModel:model];
    
    if ([model.audio_id isEqualToString:self.model.audio_id]) {
        if (self.isPlaying) {
            [self.coverView playedWithAnimated:YES];
        }
    }else {
        __block NSInteger index = 0;
        
        [self.playList enumerateObjectsUsingBlock:^(VideoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.audio_id isEqualToString:model.audio_id]) {
                index = idx;
            }
        }];
        self.isChanged = YES;
        [self playMusicWithIndex:index list:self.playList];
    }
}



#pragma mark - 懒加载
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-210)];
        
        // 添加模糊效果
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        effectView.frame = _bgImageView.bounds;
        [_bgImageView addSubview:effectView];
        
        UIView *view = [UIView new];
        view.backgroundColor = COLOR_000000;
        view.alpha = 0.5;
        view.frame = _bgImageView.bounds;
        [_bgImageView addSubview:view];
    }
    return _bgImageView;
}

- (GKWYMusicCoverView *)coverView {
    if (!_coverView) {
        _coverView = [GKWYMusicCoverView new];
        _coverView.delegate = self;
    }
    return _coverView;
}


- (GKWYMusicControlView *)controlView {
    if (!_controlView) {
        _controlView = [GKWYMusicControlView new];
        _controlView.delegate = self;
    }
    return _controlView;
}



- (GKPlayer*)Player {
    if (!_Player) {
        _Player = [[GKPlayer alloc]init];
    }
    return _Player;
}


- (HKAudioTeachView*)teachView {
    if (!_teachView) {
        WeakSelf;
        _teachView = [[HKAudioTeachView alloc]initWithFrame:CGRectMake(0, KNavBarHeight64, SCREEN_WIDTH, PADDING_25*2)];
        _teachView.delegate = self;
        _teachView.backgroundColor = [COLOR_979797 colorWithAlphaComponent:0.2];
        _teachView.avatorClickBlock = ^{
            
            HKTeacherCourseVC *vc = [[HKTeacherCourseVC alloc] init];
            vc.teacher_id = weakSelf.detailModel.teacher_info.teacher_id;//userModel.teacher_id.length? userModel.teacher_id : userModel.ID;
            vc.followBlock = ^(BOOL is_follow, NSString *teacher_id) {
                
            };
            [weakSelf pushToOtherController:vc];
        };
    }
    return _teachView;
}


#pragma mark - HKAudioTeachViewDelegate 代理
- (void)focusTeacher:(id)sender {
    isLogin() ? nil : [self setLoginVC];
}


/*
 
 
 #pragma mark - GKWYMusicListViewDelegate
 - (void)listViewDidClose {
 [GKCover hideView];
 }
 
 
 - (void)listView:(GKWYMusicListView *)listView didSelectRow:(NSInteger)row {
 [self playMusicWithIndex:row list:listView.listArr];
 }
 
 - (void)listView:(GKWYMusicListView *)listView didLovedWithRow:(NSInteger)row {
 VideoModel *model = self.musicList[row];
 model.isLike = !model.isLike;
 
 [GKWYMusicTool saveMusicList:self.musicList];
 if ([model.audio_id isEqualToString:self.model.audio_id]) {
 self.model = model;
 self.controlView.is_love = model.isLike;
 }
 
 listView.listArr = self.musicList;
 
 [self setupLockScreenControlInfo];
 
 [[NSNotificationCenter defaultCenter] postNotificationName:@"WYMusicLovedMusicNotification" object:nil];
 }
 */



/*
 - (GKWYMusicListView *)listView {
 if (!_listView) {
 _listView = [GKWYMusicListView new];
 _listView.delegate = self;
 }
 return _listView;
 }
 */


/*
 - (void)showLyricView {
 self.lyricView.hidden = NO;
 [self.lyricView hideSystemVolumeView];
 
 [UIView animateWithDuration:0.5 animations:^{
 self.lyricView.alpha            = 1.0;
 
 self.coverView.alpha            = 0.0;
 self.controlView.topView.alpha  = 0.0;
 }completion:^(BOOL finished) {
 self.lyricView.hidden           = NO;
 self.coverView.hidden           = YES;
 self.controlView.topView.hidden = YES;
 }];
 }
 */


/*
 - (GKWYMusicLyricView *)lyricView {
 if (!_lyricView) {
 _lyricView = [GKWYMusicLyricView new];
 _lyricView.backgroundColor = [UIColor clearColor];
 
 //        __weak typeof(self) weakSelf = self;
 
 _lyricView.volumeViewSliderBlock = ^(BOOL isBegan) {
 //            weakSelf.gk_fullScreenPopDisabled = isBegan;
 };
 
 _lyricView.hidden = YES;
 }
 return _lyricView;
 }
 */

@end


