//
//  ZFHKNormalLandScapeControlView.m
//  ZFHKNormalPlayer
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

#import "ZFHKNormalLandScapeControlView.h"
#import "UIView+ZFHKNormalFrame.h"
#import "ZFHKNormalUtilities.h"
#import "ZFHKNormalPlayer.h"
#import "ZFHNomalCustom.h"
#import "ZFHKNormalPlayerResolutionView.h"
#import "UIView+SNFoundation.h"
#import "LBLelinkKitManager.h"
#import "ZFHKNormalPlayerNotesListView.h"
#import "UIView+HKLayer.h"
#import "ZFHKPlayerNotesAlertView.h"
#import "QiniuSDK.h"
#import "UIView+HKLayer.h"
#import "TXLiteAVPlayerManager.h"
#import "ZFHKNormalPlayerCourseListView.h"
#import "HKStatusBarView.h"

@interface ZFHKNormalLandScapeControlView () <ZFHKNormalSliderViewDelegate,ZFHKNormalPlayerMoreSettingViewDelegate,ZFHKNormalPlayerResolutionViewDelegate,CAAnimationDelegate>
/// 顶部工具栏
@property (nonatomic, strong) UIView *topToolView;
@property (nonatomic, strong) HKStatusBarView *statusBarView; //iPhone横屏自定义状态栏

/// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 底部工具栏
@property (nonatomic, strong) UIView *bottomToolView;
/// 播放或暂停按钮
@property (nonatomic, strong) UIButton *playOrPauseBtn;
/// 播放的当前时间
@property (nonatomic, strong) UILabel *currentTimeLabel;
/// 滑杆
@property (nonatomic, strong) ZFHKNormalSliderView *slider;
/// 视频总时间
@property (nonatomic, strong) UILabel *totalTimeLabel;
/// 锁定屏幕按钮
@property (nonatomic, strong) UIButton *lockBtn;

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, strong) UIButton *fullScreenBtn;
@property (nonatomic, strong) UIButton *courseListBtn;//课程目录
@property (nonatomic, strong) UIButton *nextCourseBtn;//下一节按钮

//编辑按钮
@property (nonatomic, strong) UIButton *editBtn;
//笔记提示标签
@property (nonatomic , strong) UILabel * noteTipLabel;

///-----倍速
@property (nonatomic, strong) NSArray *resolutionArray;
/** 当前选中的分辨率btn按钮 */
@property (nonatomic, weak  ) UIButton *resoultionCurrentBtn;
/// 切换倍速开关
@property (nonatomic, strong) UIButton *resolutionBtn;

/** 顶部 图文按钮 */
@property (nonatomic, strong) UIButton *topGraphicBtn;
/** 更多设置按钮 */
@property (nonatomic, strong) UIButton *moreSettingBtn;
/** 跳转VIP按钮 */
@property (nonatomic, strong) UIButton *bottomVipBtn;

/** 投屏按钮 */
@property (nonatomic, strong) UIButton *airPlayBtn;
/** 音频按钮 */
@property (nonatomic, strong) UIButton *audioBtn;

/// 阴影蒙层
@property (nonatomic,strong) UIView *shadowCoverView;

@property (nonatomic,strong)ZFHKNormalPlayerResolutionView *playerResolutionView;

@property (nonatomic,assign) BOOL isHiddenPlayerResolutionView;
/** 快进按钮 */
@property (nonatomic, strong) UIButton *fastPlayBtn;
/** 快进按钮 */
@property (nonatomic, strong) UIButton *backPlayBtn;

@property (nonatomic, strong) UILabel *forwardLB;

@property (nonatomic, strong)ZFHKNormalPlayerMaterialTipView *materialTipView;

@property (nonatomic,assign) BOOL isNeedLayout;

@property (nonatomic , strong) ZFHKPlayerNotesAlertView * notesAlertView;
@property (nonatomic, assign)ZFHKNormalPlayerPlaybackState playState; // 保存播放状态
@property (nonatomic , assign) BOOL isScreenshot; //当前是系统截屏还是按键截屏
@property (nonatomic , assign) NSInteger currentTime;

@property (nonatomic,assign) BOOL isHiddenNotesView; //是否隐藏笔记
@property (nonatomic,assign) BOOL isHiddenCourseView; //是否隐藏课程列表
@property (nonatomic , strong) UIImageView * topShadowView;
@property (nonatomic , strong) UIImageView * bottomShadowView;

@property (nonatomic,assign)BOOL is24H;

@end

@implementation ZFHKNormalLandScapeControlView

- (void)dealloc {
    [self immediateHiddenForwardLB];
    TTVIEW_RELEASE_SAFELY(_forwardLB);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    LOG_ME;
}

- (UIImageView *)topShadowView{
    if (_topShadowView == nil) {
        _topShadowView = [[UIImageView alloc] init];
        _topShadowView.contentMode =  UIViewContentModeScaleAspectFill;
        _topShadowView.image = [UIImage imageNamed:@"shadow_video_2_33"];
        _topToolView.backgroundColor = [UIColor clearColor];
    }
    return _topShadowView;
}

- (UIImageView *)bottomShadowView{
    if (_bottomShadowView == nil) {
        _bottomShadowView = [[UIImageView alloc] init];
        _bottomShadowView.contentMode =  UIViewContentModeScaleAspectFill;
        _bottomShadowView.image = [UIImage imageNamed:@"shadow_video_bottom_2_33"];
        _bottomShadowView.backgroundColor = [UIColor clearColor];
    }
    return _bottomShadowView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.shadowCoverView];
        [self addSubview:self.topToolView];
        [self.topToolView addSubview:self.topShadowView];
        [self.topToolView addSubview:self.backBtn];
        [self.topToolView addSubview:self.titleLabel];
        
        
        [self addSubview:self.bottomToolView];
        [self.bottomToolView addSubview:self.bottomShadowView];
        [self.bottomToolView addSubview:self.playOrPauseBtn];
        [self.bottomToolView addSubview:self.currentTimeLabel];

        [self.bottomToolView addSubview:self.slider];
        [self.bottomToolView addSubview:self.totalTimeLabel];
        [self addSubview:self.lockBtn];
        
        [self addSubview:self.bottomVipBtn];
        
        [self.bottomToolView addSubview:self.fullScreenBtn];
        [self.bottomToolView addSubview:self.courseListBtn];
        [self.bottomToolView addSubview:self.nextCourseBtn];
        
        [self.topToolView addSubview:self.resolutionBtn];
        [self.topToolView addSubview:self.topGraphicBtn];
        [self.topToolView addSubview:self.moreSettingBtn];
        
        [self.topToolView addSubview:self.airPlayBtn];
        [self.topToolView addSubview:self.audioBtn];
        
        [self addSubview:self.fastPlayBtn];
        [self addSubview:self.backPlayBtn];
        [self addSubview:self.editBtn];
        [self addSubview:self.noteTipLabel];
        
        // 设置子控件的响应事件
        [self makeSubViewsAction];
        [self resetControlView];

        /// statusBarFrame changed
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layOutControllerViews) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
        /** 截图监听通知 */
        HK_NOTIFICATION_ADD_OBJ(UIApplicationUserDidTakeScreenshotNotification, (screenshotAction), nil);
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (IS_IPHONE) {
                self.statusBarView.hidden = YES;
                [self.topToolView addSubview:self.statusBarView];
            }
        });
    }
    return self;
}


-(ZFHKPlayerNotesAlertView *)notesAlertView{
    if (_notesAlertView == nil) {
        _notesAlertView = [ZFHKPlayerNotesAlertView viewFromXib];
        _notesAlertView.tag = 101;
        _notesAlertView.alpha = 0.0;
        @weakify(self);
        _notesAlertView.didCloseBlock = ^{
            @strongify(self);
            if (self.isScreenshot) {
                //判断是不是第一次使用按键截屏
                BOOL showScreenshotAlert = [[NSUserDefaults standardUserDefaults] boolForKey:@"showScreenshotAlert"];
                if (!showScreenshotAlert) {
                    [self hideAlertView];
                    [self showScreenshotAlertView];
                }else{
                    if (self.playState == ZFHKNormalPlayerPlayStatePlaying) {
                        [self.player.currentPlayerManager play];
                    }
                    [self hideAlertView];
                }
            }else{
                if (self.playState == ZFHKNormalPlayerPlayStatePlaying) {
                    [self.player.currentPlayerManager play];
                }
                [self hideAlertView];
            }
        };
        
        _notesAlertView.didTxtNoteBtnBlock = ^{//文字笔记
            [MobClick event: detailpage_note_show_addnotes];
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(ZFHKNormalLandScapeControlView:addTxtNotes:currentTime:videoModel:)]) {
                [self.delegate ZFHKNormalLandScapeControlView:self addTxtNotes:self.notesAlertView.imgV.image currentTime:self.currentTime videoModel:self.videoDetailModel];
                [self hideAlertView];
            }
        };
        
        _notesAlertView.didScreenNoteBtnBlock = ^{//截屏笔记
            [MobClick event: detailpage_note_show_savepic];
            @strongify(self)
            [self upLoadNotesData:self.notesAlertView.imgV.image];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self hideAlertView];
            });
        };
    }
    return _notesAlertView;
}

- (void)upLoadNotesData:(UIImage *)img{//获取上传的token和key
    if (img == nil) return;
    NSData * data = UIImagePNGRepresentation(img);
    @weakify(self);
    [HKHttpTool POST:@"/note/generate-upload-screenshot-token" parameters:nil success:^(id responseObject) {
        @strongify(self);
        if ([CommonFunction detalResponse:responseObject]) {
            NSString *token = responseObject[@"data"][@"token"];
            NSString *key = responseObject[@"data"][@"saveKey"];
            if ([HkNetworkManageCenter shareInstance].networkStatus > 0) {
                [self upLoadImgData:data byToken:token byKey:key];
            }else{
//                showTipDialog(NETWORK_ALREADY_LOST);
                showWarningDialog(NETWORK_ALREADY_LOST, self, 3);
            }
        }else{
            showWarningDialog(responseObject[@"msg"], self, 3);
//            showTipDialog(responseObject[@"msg"]);
        }
    } failure:^(NSError *error) {

    }];
}

- (void)upLoadImgData:(NSData *)data byToken:(NSString *)token byKey:(NSString *)key{//获取上传路径
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    [upManager putData:data key:key token:token
    complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (info.error) {
            //showTipDialog(info.error.localizedFailureReason);
            showWarningDialog(info.error.localizedFailureReason, self, 3);
        }else{
            NSLog(@"%@", info);
            NSLog(@"%@", resp);
            [self upLoadServer:key];
        }
    } option:nil];
}

- (void)upLoadServer:(NSString *)key{
    
    if (key.length==0 || self.videoDetailModel.video_id.length == 0 ) {
        //showTipDialog(@"参数不正确");
        showWarningDialog(@"参数不正确", self, 3);
        return;
    }
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[NSString stringWithFormat:@"%ld",self.currentTime] forKey:@"seconds"];
    [dic setValue:key forKey:@"screenshot"];
    [dic setValue:self.videoDetailModel.video_id forKey:@"video_id"];
    [dic setValue:self.videoDetailModel.video_titel forKey:@"title"];
    [dic setValue:[NSNumber numberWithBool:YES] forKey:@"is_private"];
    
    [HKHttpTool POST:@"/note/upsert-note" parameters:dic success:^(id responseObject) {
        if ([CommonFunction detalResponse:responseObject]) {
            NSLog(@"%@",responseObject);
            //showTipDialog(@"已保存，可在我的tab-我的笔记中查看");
            showWarningDialog(@"已保存，可在我的tab-我的笔记中查看", self, 3);
        }else{
            //showTipDialog(responseObject[@"msg"]);
            showWarningDialog(responseObject[@"msg"], self, 3);
        }
    } failure:^(NSError *error) {

    }];
}


- (void)showScreenshotAlertView{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showScreenshotAlert"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [LEEAlert alert].config
            .LeeAddTitle(^(UILabel *label) {
                label.text = @"开启截屏笔记";
                label.font = HK_FONT_SYSTEM_BOLD(15);
                label.textColor = COLOR_030303;
            })
            .LeeHeaderInsets(UIEdgeInsetsMake(15, 30, 10, 30))
            .LeeAddContent(^(UILabel *label) {
                NSString *text = @"截图笔记仅在全屏下显示。记录的笔记可以在我的-笔记中随时查看。是否开启此功能？";
                label.font = HK_FONT_SYSTEM(15);
                label.textColor = COLOR_030303;
                label.attributedText = [NSMutableAttributedString changeLineAndTextSpaceWithTotalString:text LineSpace:5 textSpace:0];
                label.textAlignment = NSTextAlignmentLeft;
            })
            .LeeItemInsets(UIEdgeInsetsMake(10, 0, 0, 0))
            .LeeAddCustomView(^(LEECustomView *custom) {
                UILabel * descLabel = [[UILabel alloc] init];
                descLabel.text = @"我的-设置中可以随时关闭";
                descLabel.font = [UIFont systemFontOfSize:12];
                descLabel.textAlignment = NSTextAlignmentLeft;
                descLabel.textColor = [UIColor colorWithHexString:@"#A8AFB8"];
                descLabel.size = CGSizeMake(200, 40);
                custom.view = descLabel;
                custom.isAutoWidth = YES;
                custom.positionType = LEECustomViewPositionTypeLeft;
            })
            .LeeAddAction(^(LEEAction *action) {
                
                action.type = LEEActionTypeCancel;
                action.title = @"关闭";
                action.titleColor = COLOR_555555;
                action.backgroundColor = [UIColor whiteColor];
                action.font = HK_FONT_SYSTEM(15);
                action.clickBlock = ^{
                    if (self.playState == ZFHKNormalPlayerPlayStatePlaying) {
                        [self.player.currentPlayerManager play];
                    }
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"NotAllowScreenShot"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                };
            })
            .LeeAddAction(^(LEEAction *action) {
                
                action.type = LEEActionTypeDefault;
                action.title = @"开启";
                action.titleColor = COLOR_0076FF;
                action.font = HK_FONT_SYSTEM(15);
                action.backgroundColor = [UIColor whiteColor];
                action.clickBlock = ^{
                    if (self.playState == ZFHKNormalPlayerPlayStatePlaying) {
                        [self.player.currentPlayerManager play];
                    }
                    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"NotAllowScreenShot"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                };
            })
            .LeeMaxWidth(318)
            .LeeHeaderColor([UIColor whiteColor])
            .LeeShouldAutorotate(YES)
            .LeeCloseAnimationDuration(0)
            .LeeShow();
}


- (void)makeSubviews {
    
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.bounds.size.width;
    CGFloat min_view_h = self.bounds.size.height;
    
    min_x = 0;
    min_y = 0;
    min_w = min_view_w;
    min_h = iPhoneX ? 110 : 80;
    self.topToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.statusBarView.frame = CGRectMake(0, 0, min_w, 20);
    
    min_h = 73;
    min_h = iPhoneX ? 100 : 73;
    min_x = 0;
    min_y = min_view_h - min_h;
    min_w = min_view_w;
    self.bottomToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    [self.bottomShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomToolView).offset(30);
        make.left.right.bottom.equalTo(self.bottomToolView);
    }];
    
    min_x = (iPhoneX && self.player.orientationObserver.fullScreenMode == ZFHKNormalFullScreenModeLandscape) ? 60: 15;
    min_x = 15;
    min_y = 35;
    
    CGFloat min_right = (iPhoneX && self.player.orientationObserver.fullScreenMode == ZFHKNormalFullScreenModeLandscape) ? 60: 20;
    
    [self.topShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topToolView).offset(-30);
        make.left.right.top.equalTo(self.topToolView);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topToolView).offset(min_y);
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.topToolView.mas_safeAreaLayoutGuideLeft).offset(min_x);
        } else {
            make.left.equalTo(self.topToolView).offset(min_x);
        }
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.backBtn.mas_trailing).offset(15);
        make.centerY.equalTo(self.backBtn.mas_centerY);
        make.width.mas_lessThanOrEqualTo(IS_IPHONE5S ?300 :400);
    }];
    
    [self.moreSettingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBtn);
        make.right.equalTo(self.topToolView.mas_right).offset(-min_right);
    }];
    
    [self.resolutionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moreSettingBtn.mas_left).offset(-15);
        make.centerY.equalTo(self.backBtn);
        make.size.mas_equalTo(CGSizeMake(36, 17));
    }];
    
    [self.topGraphicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.resolutionBtn.mas_left).offset(-15);
        make.centerY.equalTo(self.backBtn);
    }];
    
    
    // bottomToolView
    [self.playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backBtn);
        make.bottom.equalTo(self.bottomToolView).offset(-25);
    }];
    
    if (self.videoDetailModel.next_video_info.video_id.length) {
        [self.nextCourseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.playOrPauseBtn.mas_right).offset(5);
            make.centerY.equalTo(self.playOrPauseBtn);
        }];
    }else{
        [self.nextCourseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.playOrPauseBtn.mas_right).offset(5);
            make.centerY.equalTo(self.playOrPauseBtn);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
    }

    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nextCourseBtn.mas_right).offset(5);
        make.centerY.equalTo(self.nextCourseBtn);
    }];
    
    if (self.courseDataArray.count) {
        [self.courseListBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bottomToolView.mas_right).offset(-min_right);
            make.centerY.equalTo(self.playOrPauseBtn);
        }];
    }else{
        [self.courseListBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bottomToolView.mas_right).offset(-min_right);
            make.centerY.equalTo(self.playOrPauseBtn);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
    }

    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.courseListBtn.mas_left).offset(-10);
        make.centerY.equalTo(self.playOrPauseBtn);
    }];

    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.fullScreenBtn.mas_left).offset(-10);
        make.centerY.equalTo(self.playOrPauseBtn);
    }];


    [self.bottomVipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.right.equalTo(self.mas_right).offset(-min_right);
        make.size.mas_equalTo(CGSizeMake(81, 25));
    }];

    min_x = (iPhoneX && self.player.orientationObserver.fullScreenMode == ZFHKNormalFullScreenModeLandscape) ? 50: 18;
    self.lockBtn.frame = CGRectMake(min_x, 0, 50, 50);
    self.lockBtn.zf_centerY = self.zf_centerY - 25;


    self.editBtn.frame = CGRectMake(min_x, 0, 50, 50);
    self.editBtn.centerY = self.centerY + 25;

    self.noteTipLabel.centerY = self.centerY + 25;
    self.noteTipLabel.left = self.editBtn.right + 5;
    self.noteTipLabel.size = CGSizeMake(150, 20);

    [self setSliderFrame];

    self.shadowCoverView.frame = self.bounds;

    self.fastPlayBtn.size = CGSizeMake(50, 50);
    self.backPlayBtn.size = CGSizeMake(50, 50);

    self.fastPlayBtn.centerY = self.centerY - 25;

    self.fastPlayBtn.zf_right = iPhoneX ? self.zf_right - 82: self.zf_right-47;

    self.backPlayBtn.centerY = self.centerY + 25;
    self.backPlayBtn.zf_right = iPhoneX ? self.zf_right - 82: self.zf_right-47;
}


- (void)setSliderFrame {
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playOrPauseBtn.mas_centerY);
        make.left.equalTo(self.currentTimeLabel.mas_right).offset(10);
        make.right.equalTo(self.totalTimeLabel.mas_left).offset(-10);
        make.height.mas_equalTo(30);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.isShow) {
        self.topToolView.zf_y = -self.topToolView.zf_height;
        self.bottomToolView.zf_y = self.zf_height;
    } else {
        if (self.player.isLockedScreen) {
            self.topToolView.zf_y = -self.topToolView.zf_height;
            self.bottomToolView.zf_y = self.zf_height;
        } else {
            self.topToolView.zf_y = 0;
            self.bottomToolView.zf_y = iPhoneX ? self.zf_height - self.bottomToolView.zf_height-10 : self.zf_height - self.bottomToolView.zf_height;
        }
    }
    [self makeSubviews];

    [self.airPlayBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.resolutionBtn);
        make.right.equalTo(self.audioBtn.mas_left).offset(-15);
    }];

    [self.audioBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.resolutionBtn);
        if (isEmpty(self.videoDetailModel.pictext_url)) {
            make.right.equalTo(self.resolutionBtn.mas_left).offset(-15);
        }else{
            make.right.equalTo(self.topGraphicBtn.mas_left).offset(-15);
        }
    }];
}



- (void)orientationDidChanged {
    [self removePlayerResolutionView];
    [self removeMoreSettingView];
    [self removeNotesView];
    [self removeCourseView];
}



- (void)makeSubViewsAction {
    [self.backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playOrPauseBtn addTarget:self action:@selector(playPauseButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.lockBtn addTarget:self action:@selector(lockButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.editBtn addTarget:self action:@selector(editBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layOutControllerViews {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - ZFHKNormalSliderViewDelegate

- (void)sliderTouchBegan:(float)value {
    self.slider.isdragging = YES;
}

- (void)sliderTouchEnded:(float)value {
    if (self.player.totalTime > 0) {
        @weakify(self)
        [self.player seekToTime:self.player.totalTime*value completionHandler:^(BOOL finished) {
            @strongify(self)
            if (finished) {
            }
            self.slider.isdragging = NO;
        }];
        if (self.seekToPlay) {
            [self.player.currentPlayerManager play];
        }
    } else {
        self.slider.isdragging = NO;
    }
    if (self.sliderValueChanged) self.sliderValueChanged(value);
}

- (void)sliderValueChanged:(float)value {
    if (self.player.totalTime == 0) {
        self.slider.value = 0;
        return;
    }
    self.slider.isdragging = YES;
    self.currentTime = self.player.totalTime * value;
    NSString *currentTimeString = [ZFHKNormalUtilities convertTimeSecond:self.player.totalTime*value];
    self.currentTimeLabel.text = currentTimeString;
    if (self.sliderValueChanging) self.sliderValueChanging(value,self.slider.isForward);
}

- (void)sliderTapped:(float)value {
    if (self.player.totalTime > 0) {
        self.slider.isdragging = YES;
        @weakify(self)
        [self.player seekToTime:self.player.totalTime*value completionHandler:^(BOOL finished) {
            @strongify(self)
//            if (finished) {
                [self.player.currentPlayerManager play];
//            }
            self.slider.isdragging = NO;
        }];
        
        //v2.18
        if (self.sliderValueChanged) self.sliderValueChanged(value);
    } else {
        self.slider.isdragging = NO;
        self.slider.value = 0;
    }
}

#pragma mark -

/// 重置ControlView
- (void)resetControlView {
    self.slider.value                = 0;
    self.slider.bufferValue          = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.currentTime                 = 0.0;
    self.totalTimeLabel.text         = @"00:00";
    self.backgroundColor             = [UIColor clearColor];
    self.playOrPauseBtn.selected     = YES;
    self.titleLabel.text             = @"";
    self.topToolView.alpha           = 1;
    self.bottomToolView.alpha        = 1;
    self.isShow                      = NO;
    // 虎课
    self.bottomVipBtn.hidden = YES;
    self.permissionModel = nil;
    self.videoDetailModel = nil;
    self.isHiddenMoreSettingView = NO;
    self.isHiddenNotesView = NO;
    self.isHiddenCourseView = NO;
    [self removeCourseView];
    self.topGraphicBtn.hidden = YES;
    self.shadowCoverView.hidden = NO;
    
    [self hiddenForwardBtn:YES];
    self.isNeedLayout = NO;
    if (_playerResolutionView) {
        _playerResolutionView.hidden = YES;
    }
}

- (void)showControlView {
    self.lockBtn.alpha               = 1;
    self.isShow                      = YES;
    if (self.player.isLockedScreen) {
        self.topToolView.zf_y        = -self.topToolView.zf_height;
        self.bottomToolView.zf_y     = self.zf_height;
    } else {
        self.topToolView.zf_y        = 0;
        //self.bottomToolView.zf_y     = self.zf_height - self.bottomToolView.zf_height;
        self.bottomToolView.zf_y     = iPhoneX ? self.zf_height - self.bottomToolView.zf_height-10 : self.zf_height - self.bottomToolView.zf_height;
    }
    self.lockBtn.zf_left             = iPhoneX ? 50: 18;
    self.player.statusBarHidden      = NO;
    [self.statusBarView showStatusBar:YES];
    if (self.player.isLockedScreen) {
        self.topToolView.alpha       = 0;
        self.bottomToolView.alpha    = 0;
    } else {
        self.topToolView.alpha       = 1;
        self.bottomToolView.alpha    = 1;
    }
    // 锁屏 隐藏VIP按钮
    self.bottomVipBtn.hidden = YES;
    self.shadowCoverView.hidden = NO;
    
    [self showForwardBtn:YES];
}

- (void)hideControlView {
    self.isShow                      = NO;
    self.topToolView.zf_y            = -self.topToolView.zf_height;
    self.bottomToolView.zf_y         = self.zf_height;
    self.lockBtn.zf_left             = iPhoneX ? -82: -47;
    self.player.statusBarHidden      = YES;
    [self.statusBarView showStatusBar:NO];
    self.topToolView.alpha           = 0;
    self.bottomToolView.alpha        = 0;
    self.lockBtn.alpha               = 0;

    //self.resolutionBtn.selected = YES;
    if (self.lockBtn.selected) {
        self.bottomVipBtn.hidden = YES;
    }else{
        self.bottomVipBtn.hidden = [self.permissionModel.is_vip isEqualToString:@"0"] ?NO :YES;
    }
    self.shadowCoverView.hidden = YES;

    [self hiddenForwardBtn:YES];

    [self hiddenForwardLB];
}

- (BOOL)shouldResponseGestureWithPoint:(CGPoint)point withGestureType:(ZFHKNormalPlayerGestureType)type touch:(nonnull UITouch *)touch {
        
    UIView *notesAlertView = [self viewWithTag:101];
    if (notesAlertView) {
        //存在 ZFHKNormalPlayerMoreSettingView
        CGRect sliderRect = [self convertRect:notesAlertView.frame toView:self];
        if (CGRectContainsPoint(sliderRect, point)) {
            //手势点击 ZFHKNormalPlayerMoreSettingView
            return NO;
        }else{
            if (!self.isHiddenMoreSettingView) {
                [self hiddenMoreSettingView];
                self.isHiddenMoreSettingView = YES;
            }
        }
    }
    
    UIView *moreSettingView = [self viewWithTag:100];
    if (moreSettingView) {
        //存在 ZFHKNormalPlayerMoreSettingView
        CGRect sliderRect = [self convertRect:moreSettingView.frame toView:self];
        if (CGRectContainsPoint(sliderRect, point)) {
            //手势点击 ZFHKNormalPlayerMoreSettingView
            return NO;
        }else{
            if (!self.isHiddenMoreSettingView) {
                [self hiddenMoreSettingView];
                self.isHiddenMoreSettingView = YES;
            }
        }
    }
    
    if (_playerResolutionView) {
        CGRect sliderRect = [self convertRect:_playerResolutionView.frame toView:self];
        if (CGRectContainsPoint(sliderRect, point)) {
            return NO;
        }else{
            if (!self.isHiddenPlayerResolutionView) {
                [self hiddenPlayerResolutionView];
                self.isHiddenPlayerResolutionView = YES;
            }
        }
    }
    if (_notesView) {
        CGRect notesVRect = [self convertRect:_notesView.frame toView:self];
        if (CGRectContainsPoint(notesVRect, point)) {
            return NO;
        }else{
            if (!self.isHiddenNotesView) {
                [self hiddenNotesView];
                self.isHiddenNotesView = YES;
            }
        }
    }
    
    if (_courseListView) {
        CGRect notesVRect = [self convertRect:_courseListView.frame toView:self];
        if (CGRectContainsPoint(notesVRect, point)) {
            return NO;
        }else{
            if (!self.isHiddenCourseView) {
                [self hiddenCourseListView];
                self.isHiddenCourseView = YES;
            }
        }
    }
    
    CGRect sliderRect = [self.bottomToolView convertRect:self.slider.frame toView:self];
    if (CGRectContainsPoint(sliderRect, point)) {
        return NO;
    }
    if (self.player.isLockedScreen && type != ZFHKNormalPlayerGestureTypeSingleTap) { // 锁定屏幕方向后只相应tap手势
        return NO;
    }
    
    if(NO == _fastPlayBtn.hidden) {
        if (touch.view == _fastPlayBtn || touch.view == _backPlayBtn) {
            return NO;
        }
    }
    return YES;
}

- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer presentationSizeChanged:(CGSize)size {
    self.lockBtn.hidden = self.player.orientationObserver.fullScreenMode == ZFHKNormalFullScreenModePortrait;
    self.editBtn.hidden = self.player.orientationObserver.fullScreenMode == ZFHKNormalFullScreenModePortrait;
}

- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
//    if (!self.slider.isdragging) {
        self.currentTime = currentTime;
        NSString *currentTimeString = [ZFHKNormalUtilities convertTimeSecond:currentTime];
        self.currentTimeLabel.text = currentTimeString;
        NSString *totalTimeString = [ZFHKNormalUtilities convertTimeSecond:totalTime];
        self.totalTimeLabel.text = totalTimeString;
        self.slider.value = videoPlayer.progress;
//    }
//    if (totalTime > 1 && !self.isNeedLayout) {
//        [self setNeedsLayout];
//        [self layoutIfNeeded];
//        self.isNeedLayout = YES;
//        [self setNeedsLayout];
//        [self layoutIfNeeded];
//    }
}

- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer bufferTime:(NSTimeInterval)bufferTime {
    self.slider.bufferValue = videoPlayer.bufferProgress;
}

- (void)showTitle:(NSString *)title fullScreenMode:(ZFHKNormalFullScreenMode)fullScreenMode {
    self.titleLabel.text = title;
    self.player.orientationObserver.fullScreenMode = fullScreenMode;
//    self.lockBtn.hidden = fullScreenMode == ZFHKNormalFullScreenModePortrait;
}

/// 调节播放进度slider和当前时间更新
- (void)sliderValueChanged:(CGFloat)value currentTimeString:(NSString *)timeString {
    self.slider.value = value;
    self.currentTimeLabel.text = timeString;
    self.slider.isdragging = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.sliderBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
}

/// 滑杆结束滑动
- (void)sliderChangeEnded {
    self.slider.isdragging = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.sliderBtn.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - action

- (void)backBtnClickAction:(UIButton *)sender {
    self.lockBtn.selected = NO;
    self.player.lockedScreen = NO;
    self.lockBtn.selected = NO;
    if (self.player.orientationObserver.supportInterfaceOrientation & ZFHKNormalInterfaceOrientationMaskPortrait) {
        [self.player enterFullScreen:NO animated:YES];
    }
    if (self.backBtnClickCallback) {
        self.backBtnClickCallback();
    }
}

- (void)fullScreenBtnClickAction{
    if (self.videoDetailModel.has_feature_notes) {
        [self showNotesView];
        [MobClick event:detailpage_note_select];
    }else{
        self.lockBtn.selected = NO;
        self.player.lockedScreen = NO;
        self.lockBtn.selected = NO;
        if (self.player.orientationObserver.supportInterfaceOrientation & ZFHKNormalInterfaceOrientationMaskPortrait) {
            [self.player enterFullScreen:NO animated:YES];
        }
        if (self.backBtnClickCallback) {
            self.backBtnClickCallback();
        }
    }
}

- (void)courseListBtnClickAction{
    [self showCourseListView];
}

- (void)playPauseButtonClickAction:(UIButton *)sender {
    BOOL showed = [HKNSUserDefaults boolForKey:@"showdoubleTap"];
    if (!showed) {
        showWarningDialog(@"双击屏幕即可暂停视频", self, 3);
        
        [HKNSUserDefaults setBool:1 forKey:@"showdoubleTap"];
        [HKNSUserDefaults synchronize];
    }
    
    [self playOrPause];
}

/// 根据当前播放状态取反
- (void)playOrPause {
    self.playOrPauseBtn.selected = !self.playOrPauseBtn.isSelected;
    self.playOrPauseBtn.isSelected? [self.player.currentPlayerManager play]: [self.player.currentPlayerManager pause];
    [self lbPlayOrPause];
}


- (void)lbPlayOrPause {
    if ([LBLelinkKitManager sharedManager].isLBlink) {
        if ([[LBLelinkKitManager sharedManager].videoUrl isEqualToString:self.permissionModel.video_url]) {
            if (LBLelinkPlayStatusPlaying == [LBLelinkKitManager sharedManager].currentPlayStatus) {
                if (NO ==  self.playOrPauseBtn.isSelected) {
                    [[LBLelinkKitManager sharedManager].lelinkPlayer pause];
                }else{
                    //[[LBLelinkKitManager sharedManager].lelinkPlayer resumePlay];
                }
            } else {
                if (YES ==  self.playOrPauseBtn.isSelected) {
                    [[LBLelinkKitManager sharedManager].lelinkPlayer resumePlay];
                }
            }
        }
    }
}


- (void)playBtnSelectedState:(BOOL)selected {
    self.playOrPauseBtn.selected = selected;
}

- (void)lockButtonClickAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.player.lockedScreen = sender.selected;
    if (sender.selected == YES) {
        [self hiddenForwardBtn:sender.selected];
    }else{
        [self showForwardBtn:YES];
    }
    
    [MobClick event:um_videodetailpage_fulllplayer_lock];
}

- (void)editBtnClickAction{
    self.isScreenshot = NO;
    [self screenshotNotes];
    [MobClick event: detailpage_note_click];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showNoteTipLabel"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)screenshotNotes{
    [MobClick event: detailpage_note_show];

    self.playState = self.player.currentPlayerManager.playState;
    NSLog(@"点击添加笔记按钮");
    if (self.playState == ZFHKNormalPlayerPlayStatePlaying) {
        [self.player.currentPlayerManager pause];
    }
    
    TXLiteAVPlayerManager * manager = (TXLiteAVPlayerManager *)self.player.currentPlayerManager;
    
    //- (void)thumbnailTXImageAtCurrentTime:(void(^)(UIImage * image))Imgblock
    
//    UIImage * image = [self.player.currentPlayerManager thumbnailImageAtCurrentTime];
    //弹出来笔记弹窗
//    [self showNotesAlertView:image];
    [manager.vodPlayer snapshot:^(UIImage * image) {
        if (image) {
            //弹出来笔记弹窗
            [self showNotesAlertView:image];
        }
    }];
    
}

- (void)screenshotAction{
    self.isScreenshot = YES;
    BOOL NotAllowScreenShot = [[NSUserDefaults standardUserDefaults] boolForKey:@"NotAllowScreenShot"];
    if (NotAllowScreenShot) return;
    [self screenshotNotes];
}

#pragma mark - getter

- (UIView *)topToolView {
    if (!_topToolView) {
        _topToolView = [[UIView alloc] init];
        //UIImage *image = ZFHKNormalPlayer_Image(@"ZFPlayer_top_shadow");
        //_topToolView.layer.contents = (id)image.CGImage;
    }
    return _topToolView;
}

-(HKStatusBarView *)statusBarView{
    if (_statusBarView == nil) {
        _statusBarView = [[HKStatusBarView alloc] init];
    }
    return _statusBarView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:imageName(@"nac_back_white") forState:UIControlStateNormal];
        [_backBtn setHKEnlargeEdge:35];
    }
    return _backBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    }
    return _titleLabel;
}

- (UIView *)bottomToolView {
    if (!_bottomToolView) {
        _bottomToolView = [[UIView alloc] init];
        //UIImage *image = ZFHKNormalPlayer_Image(@"ZFPlayer_bottom_shadow");
        //_bottomToolView.layer.contents = (id)image.CGImage;
    }
    return _bottomToolView;
}

- (UIButton *)playOrPauseBtn {
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrPauseBtn setImage:imageName(@"ic_start_v2_19") forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:imageName(@"hkplayer_stop_v2_19") forState:UIControlStateSelected];
        [_playOrPauseBtn setHKEnlargeEdge:30];
        
        
    }
    return _playOrPauseBtn;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        //_currentTimeLabel.font = [UIFont systemFontOfSize:10.0f];
        _currentTimeLabel.font = HK_TIME_FONT(10);
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        [_currentTimeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _currentTimeLabel;
}

- (ZFHKNormalSliderView *)slider {
    if (!_slider) {
        _slider = [[ZFHKNormalSliderView alloc] init];
        _slider.delegate = self;
//        _slider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
//        _slider.bufferTrackTintColor  = HKColorFromHex(0xFFD305, 0.5);
//        _slider.minimumTrackTintColor = HKColorFromHex(0xFFD305, 1.0);
        
        _slider.maximumTrackTintColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
        _slider.bufferTrackTintColor  = [[UIColor whiteColor]colorWithAlphaComponent:0.6];
        _slider.minimumTrackTintColor = HKColorFromHex(0xFFD305, 1.0);
        
        [_slider setThumbImage:imageName(@"hkplayer_slider_v2_19") forState:UIControlStateNormal];
        _slider.sliderHeight = 3;
        
    }
    return _slider;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        //_totalTimeLabel.font = [UIFont systemFontOfSize:10.0f];
        _totalTimeLabel.font = HK_TIME_FONT(10);
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        [_totalTimeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _totalTimeLabel;
}

- (UIButton *)lockBtn {
    if (!_lockBtn) {
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockBtn setBackgroundImage:imageName(@"ic_lock_2_33") forState:UIControlStateNormal];
        [_lockBtn setBackgroundImage:imageName(@"ic_lock_sel_2_33") forState:UIControlStateSelected];
        [_lockBtn setHKEnlargeEdge:25];
    }
    return _lockBtn;
}

- (UIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //[_editBtn setBackgroundImage:<#(nullable UIImage *)#> forState:<#(UIControlState)#>]
        [_editBtn setBackgroundImage:[UIImage imageNamed:@"ic_note_2_33"] forState:UIControlStateNormal];
        [_editBtn setHKEnlargeEdge:25];
        _editBtn.hidden = YES;
    }
    return _editBtn;
}


- (UIButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn addTarget:self action:@selector(fullScreenBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _fullScreenBtn;
}


- (UIButton *)courseListBtn {
    if (!_courseListBtn) {
        _courseListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_courseListBtn addTarget:self action:@selector(courseListBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
        [_courseListBtn setTitle:@"目录" forState:UIControlStateNormal];
        [_courseListBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_courseListBtn addCornerRadius:0 addBoderWithColor:[UIColor whiteColor] BoderWithWidth:1.5];
        [_courseListBtn setImage:nil forState:UIControlStateNormal];
        [_courseListBtn setContentEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 10)];
        _courseListBtn.titleLabel.font = HK_TIME_FONT(10);
    }
    return _courseListBtn;
}


- (UIButton *)nextCourseBtn {
    if (!_nextCourseBtn) {
        _nextCourseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextCourseBtn addTarget:self action:@selector(nextCourseBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
        [_nextCourseBtn setImage:[UIImage hkdm_imageWithNameLight:@"ic_next_2_37" darkImageName:@"ic_next_2_37"] forState:UIControlStateNormal];
    }
    return _nextCourseBtn;
}



- (void)nextCourseBtnClickAction{
    //将当前选中的状态重置
    
    [self resetCourseStatus];
    
    if (self.didNextBlock) {
        [MobClick event: detailpage_screening_nextclass];
        self.didNextBlock(self.videoDetailModel);
    }
}

- (void)resetCourseStatus{
    NSInteger type = [self.videoDetailModel.video_type integerValue];
        
    //  软件入门，职业路径
    if ((HKVideoType_LearnPath == type) || (HKVideoType_Practice == type ) || (HKVideoType_JobPath == type) || (HKVideoType_JobPath_Practice == type )) {
        // 遍历找出正在播放的视频
        for (int i = 0; i < self.courseDataArray.count; i++) {
            HKCourseModel *courseDetial = self.courseDataArray[i];
            for (int j = 0; j < courseDetial.children.count; j++) {
                HKCourseModel *childCourseDetial = courseDetial.children[j];
                // 当前观看的视频
//                if ([childCourseDetial.videoId isEqualToString:self.videoDetailModel.video_id]) {
                    childCourseDetial.currentWatching = NO;
//                }
                
                // 软件入门练习题
                for (int k = 0; k < childCourseDetial.children.count; k++) {
                    HKCourseModel *exercise = childCourseDetial.children[k];
                    // 当前观看的视频
//                    if ([exercise.videoId isEqualToString:self.videoDetailModel.video_id]) {
                        exercise.currentWatching = NO; // 当前正在观看的练习题
//                        childCourseDetial.isPlayingExpandExcercises = YES; // 子练习题正在播放
//                    }
                }
            }
        }
    }else if ( HKVideoType_Series == type || HKVideoType_UpDownCourse == type || HKVideoType_PGC == type) {
        if ( HKVideoType_PGC == type ) {
            [self.courseDataArray enumerateObjectsUsingBlock:^(HKCourseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                // 当前正在观看
                if ([obj.video_id isEqualToString:self.videoDetailModel.video_id]) {
                    obj.currentWatching = NO;
                }
            }];
        }else{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            for (int i = 0; i < self.courseDataArray.count; i++) {
                HKCourseModel *courseDetial = self.courseDataArray[i];
                // 正在观看的系列课
                if ([courseDetial.video_id isEqualToString:self.videoDetailModel.video_id]) {
                    courseDetial.currentWatching = NO;
                    indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                }
            }
        }
    }

}

        

- (UIButton*)topGraphicBtn {
    if (!_topGraphicBtn) {
        _topGraphicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //[_topGraphicBtn setTitle:@"图文教程" forState:UIControlStateNormal];
        [_topGraphicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _topGraphicBtn.titleLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ?12 :11];
        
        [_topGraphicBtn setImage:imageName(@"hkplayer_pic_v2_15") forState:UIControlStateNormal];
        [_topGraphicBtn setImage:imageName(@"hkplayer_pic_v2_15") forState:UIControlStateHighlighted];
        
        //[_topGraphicBtn setBackgroundImage:imageName(@"hkplayer_rectangle_bg") forState:UIControlStateNormal];
        //[_topGraphicBtn setBackgroundImage:imageName(@"hkplayer_rectangle_bg") forState:UIControlStateHighlighted];
        //[_topGraphicBtn setBackgroundImage:imageName(@"hkplayer_rectangle_bg") forState:UIControlStateSelected];
        [_topGraphicBtn addTarget:self action:@selector(topGraphicBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topGraphicBtn setEnlargeEdgeWithTop:PADDING_25 right:PADDING_5 bottom:0 left:PADDING_25];
        _topGraphicBtn.hidden = YES;
    }
    return _topGraphicBtn;
}


- (void)topGraphicBtnClick:(UIButton*)sender {
    if (self.landScapeGraphicBtnClickCallback) {
        self.landScapeGraphicBtnClickCallback(sender, self.videoDetailModel.pictext_url);
        [MobClick event:um_videodetailpage_fulllplayer_graphic];
    }
}


- (UIButton*)moreSettingBtn {
    if (!_moreSettingBtn) {
        _moreSettingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreSettingBtn setImage:imageName(@"hkplayer_more") forState:UIControlStateNormal];
        [_moreSettingBtn setImage:imageName(@"hkplayer_more") forState:UIControlStateSelected];
        [_moreSettingBtn setEnlargeEdgeWithTop:20 right:15 bottom:20 left:10];
        [_moreSettingBtn addTarget:self action:@selector(moreSettingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreSettingBtn;
}



- (UIButton*)bottomVipBtn {
    
    if (!_bottomVipBtn) {
        _bottomVipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomVipBtn setTitle:@"超值充值VIP" forState:UIControlStateNormal];
        [_bottomVipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bottomVipBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7] forState:UIControlStateHighlighted];
        _bottomVipBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
        [_bottomVipBtn addTarget:self action:@selector(bottomVipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomVipBtn sizeToFit];
        [_bottomVipBtn setHKEnlargeEdge:15];
        _bottomVipBtn.hidden = YES;
        
        [_bottomVipBtn setImage:imageName(@"arrow_right_white") forState:UIControlStateNormal];
        [_bottomVipBtn setImage:imageName(@"arrow_right_white") forState:UIControlStateHighlighted];
        [_bottomVipBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleRight imageTitleSpace:4];
        
        UIImage *image = [UIImage createImageWithColor:[COLOR_000000 colorWithAlphaComponent:0.4] size:CGSizeMake(81, 25)];
        [_bottomVipBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_bottomVipBtn setBackgroundImage:image forState:UIControlStateHighlighted];
        _bottomVipBtn.layer.cornerRadius = 5;
        _bottomVipBtn.clipsToBounds = YES;
    }
    return _bottomVipBtn;
}


/// 记忆播放 倍数设置
- (void)moreSettingBtnClick:(UIButton*)btn {
    [self showMoreSettingView];
    [MobClick event:um_videodetailpage_fulllplayer_setting];
}


- (void)bottomVipBtnClick:(UIButton*)btn {
    if (self.landScapeVipBtnClickCallback) {
        self.landScapeVipBtnClickCallback(btn);
        [MobClick event:um_videodetailpage_fulllplayer_buy];
    }
}


- (UIButton *)airPlayBtn {
    if (!_airPlayBtn) {
        _airPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_airPlayBtn setImage:imageName(@"hkplay_airplay_tv") forState:UIControlStateNormal];
        [_airPlayBtn setImage:imageName(@"hkplay_airplay_tv") forState:UIControlStateSelected];
        [_airPlayBtn addTarget:self action:@selector(airPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_airPlayBtn setHKEnlargeEdge:30];
    }
    return _airPlayBtn;
}


- (void)airPlayBtnClick:(UIButton*)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ZFHKNormalLandScapeControlView:airPlayBtn:)]) {
        [self.delegate ZFHKNormalLandScapeControlView:self airPlayBtn:btn];
        [MobClick event:um_videodetailpage_fulllplayer_caststreen];
    }
}


- (UIButton *)audioBtn {
    if (!_audioBtn) {
        _audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_audioBtn setImage:imageName(@"hkplayer_audio_v2.15") forState:UIControlStateNormal];
        [_audioBtn setImage:imageName(@"hkplayer_audio_v2.15") forState:UIControlStateSelected];
        [_audioBtn addTarget:self action:@selector(audioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_audioBtn setHKEnlargeEdge:10];
    }
    return _audioBtn;
}


- (void)audioBtnClick:(UIButton*)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ZFHKNormalLandScapeControlView:audioBtn:)]) {
        [self.delegate ZFHKNormalLandScapeControlView:self audioBtn:btn];
        [MobClick event:um_videodetailpage_fulllplayer_audio];
    }
}



- (UIButton *)resolutionBtn {
    if (!_resolutionBtn) {
        _resolutionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resolutionBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        
        [_resolutionBtn addTarget:self action:@selector(resolutionBtnClick:isHiddenView:) forControlEvents:UIControlEventTouchUpInside];
        _resolutionBtn.backgroundColor = [UIColor clearColor];
        
        //[_resolutionBtn setBackgroundImage:imageName(@"hkplayer_rate_nomal") forState:UIControlStateNormal];
        //[_resolutionBtn setBackgroundImage:imageName(@"hkplayer_rate_selected") forState:UIControlStateSelected];
        [_resolutionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_resolutionBtn setTitleColor:COLOR_27323F forState:UIControlStateSelected];
        [_resolutionBtn setEnlargeEdgeWithTop:PADDING_25 right:PADDING_10 bottom:0 left:PADDING_10];
        
        NSString *title = [ZFHKNormalPlayerPlayRate normalPlayerPlayRate];
        [_resolutionBtn setTitle:title forState:UIControlStateNormal];
        
        CGRect rect = CGRectMake(0, 0, 36, 17);
        [_resolutionBtn setRoundedCorners:UIRectCornerAllCorners radius:0 rect:rect lineWidth:1.5];
    }
    return _resolutionBtn;
}


/** isHiddenView yes - 点击播放界面 隐藏分辨率View  */
- (void)resolutionBtnClick:(UIButton *)sender isHiddenView:(BOOL)isHiddenView {
    
    [self showPlayerResolutionView];
    //sender.selected = !sender.selected;
    //友盟倍速统计事件
    [MobClick event:um_videodetailpage_fulllplayer_speed];
}



/**
 *  同步全屏点击切换分别率按钮
 */
- (void)changeResolutionCurrent:(NSInteger)index {
    NSString *title = [ZFHKNormalPlayerPlayRate normalPlayerPlayRateWithIndex:index];
    [self.resolutionBtn setTitle:title forState:UIControlStateNormal];
}



#pragma mark - -- 虎课自定义部分
- (void)setPermissionModel:(HKPermissionVideoModel *)permissionModel {
    _permissionModel = permissionModel;
    if ([permissionModel.is_vip isEqualToString:@"0"] ) {
        self.bottomVipBtn.hidden = NO;
    }
}

- (void)setVideoDetailModel:(DetailModel *)videoDetailModel {
    _videoDetailModel = videoDetailModel;
    if (!isEmpty(videoDetailModel.pictext_url)) {
        self.topGraphicBtn.hidden = NO;
    }
    if (videoDetailModel) {
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
    if (self.videoDetailModel.has_feature_notes) {
        //精选笔记
        [_fullScreenBtn setTitle:@"精选笔记" forState:UIControlStateNormal];
        [_fullScreenBtn setTitleColor:[UIColor colorWithHexString:@"#FFD606"] forState:UIControlStateNormal];
        [_fullScreenBtn addCornerRadius:0 addBoderWithColor:[UIColor colorWithHexString:@"#FFD606"] BoderWithWidth:1.5];
        [_fullScreenBtn setImage:nil forState:UIControlStateNormal];
        [_fullScreenBtn setContentEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 10)];
        _fullScreenBtn.titleLabel.font = HK_TIME_FONT(10);
    }else{
        [_fullScreenBtn setImage:imageName(@"ic_shrink_v2_5") forState:UIControlStateNormal];
        [_fullScreenBtn setTitle:@"" forState:UIControlStateNormal];
        [_fullScreenBtn addCornerRadius:0 addBoderWithColor:[UIColor clearColor] BoderWithWidth:1.5];
        [_fullScreenBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_fullScreenBtn setHKEnlargeEdge:35];
        [self removeNotesView];
    }
}



- (void)showMoreSettingView {
    
    [self removeMoreSettingView];
    CGFloat min_view_h = self.bounds.size.height;
    CGFloat min_view_w = self.bounds.size.width;
    CGFloat min_w = 200;
    self.moreSettingView.frame = CGRectMake(min_view_w, 0, min_w, min_view_h);
    [self addSubview:self.moreSettingView];
    [UIView animateWithDuration:0.2 animations:^{
        self.moreSettingView.zf_x = min_view_w - min_w;
    }];

//    if (self.isDownloadFinsh || (!self.permissionModel.tx_video_url.length && !self.permissionModel.tx_file_id.length)) {
//        [self.moreSettingView hiddenChangeLine];
//    }
}


- (void)showNotesView {
    [self removeNotesView];
    CGFloat min_view_h = self.bounds.size.height;
    CGFloat min_view_w = self.bounds.size.width;
    CGFloat min_w = 290;
    self.notesView.frame = CGRectMake(min_view_w, 0, min_w, min_view_h);
    self.notesView.videoDetailModel = self.videoDetailModel;
    [self addSubview:self.notesView];
    [UIView animateWithDuration:0.2 animations:^{
        self.notesView.zf_x = min_view_w - min_w;
    }];
}

- (void)showCourseListView{
    [self removeCourseView];
    CGFloat min_view_h = self.bounds.size.height;
    CGFloat min_view_w = self.bounds.size.width;
    CGFloat min_w = 350;
    self.courseListView.frame = CGRectMake(min_view_w, 0, min_w, min_view_h);
    self.courseListView.videlDetailModel = self.videoDetailModel;
    self.courseListView.index = self.index;
    self.courseListView.dataSource = self.courseDataArray;
    [self addSubview:self.courseListView];
    [UIView animateWithDuration:0.2 animations:^{
        self.courseListView.zf_x = min_view_w - min_w;
    }];
}

-  (void)showNotesAlertView:(UIImage *)img{
    [self removeNotesAlertView];
    CGFloat min_view_h = self.bounds.size.height;
    CGFloat min_view_w = self.bounds.size.width;
    self.notesAlertView.frame = CGRectMake(0, 0, min_view_w, min_view_h);
    self.notesAlertView.imgV.image = img;
    [self addSubview:self.notesAlertView];
    [UIView animateWithDuration:0.1 animations:^{
        self.notesAlertView.alpha = 1;
    }];
}

- (void)hiddenMoreSettingView {
    [UIView animateWithDuration:0.3 animations:^{
        self.moreSettingView.zf_x = self.zf_width;
    } completion:^(BOOL finished) {
        [self removeMoreSettingView];
    }];
}

- (void)hiddenNotesView {
    [UIView animateWithDuration:0.3 animations:^{
        self.notesView.zf_x = self.zf_width;
    } completion:^(BOOL finished) {
        [self removeNotesView];
    }];
}

- (void)hiddenCourseListView{
    [UIView animateWithDuration:0.3 animations:^{
        self.courseListView.zf_x = self.zf_width;
    } completion:^(BOOL finished) {
        [self removeCourseView];
    }];
}

- (void)hideAlertView{
    [UIView animateWithDuration:0.1 animations:^{
        self.notesAlertView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeNotesAlertView];
    }];
}


- (void)removeMoreSettingView {
    self.isHiddenMoreSettingView = NO;
    TTVIEW_RELEASE_SAFELY(_moreSettingView);
}

- (void)removeNotesView{
    self.isHiddenNotesView = NO;
    TTVIEW_RELEASE_SAFELY(_notesView);
}

- (void)removeCourseView{
    self.isHiddenCourseView = NO;
    TTVIEW_RELEASE_SAFELY(_courseListView);
}


- (void)removeNotesAlertView{
    TTVIEW_RELEASE_SAFELY(_notesAlertView);
}


- (ZFHKNormalPlayerMoreSettingView*) moreSettingView {
    if (!_moreSettingView) {
        _moreSettingView = [[ZFHKNormalPlayerMoreSettingView alloc]init];
        _moreSettingView.delegate = self;
        _moreSettingView.tag = 100;
    }
    return _moreSettingView;
}

- (ZFHKNormalPlayerNotesListView*) notesView {
    if (!_notesView) {
        _notesView = [[ZFHKNormalPlayerNotesListView alloc]init];
        @weakify(self);
        _notesView.didPlayTimeBtnBlock = ^(int time) {
            CGFloat value = time/self.player.totalTime;
            @strongify(self);
            if (self.player.totalTime > 0) {
                [self.player seekToTime:time completionHandler:^(BOOL finished) {
                    if (finished) {
                    }
                    self.slider.isdragging = NO;
                }];
                if (self.seekToPlay) {
                    [self.player.currentPlayerManager play];
                }
            } else {
                self.slider.isdragging = NO;
            }
            if (self.sliderValueChanged) self.sliderValueChanged(value);
        };
    }
    return _notesView;
}

- (ZFHKNormalPlayerCourseListView *)courseListView{
    if (!_courseListView) {
        _courseListView = [[ZFHKNormalPlayerCourseListView alloc] init];
        WeakSelf
        _courseListView.didCourseBlock = ^(NSString * _Nonnull changeCourseId, NSString * _Nonnull sectionId, NSString * _Nonnull frontCourseId) {
            if (weakSelf.didCourseBlock) {
                weakSelf.didCourseBlock(changeCourseId, sectionId, frontCourseId);
            }
        };
    }
    return _courseListView;
}


#pragma mark ZFHKNormalPlayerMoreSettingView delegate

- (void)zfHKNormalPlayerMoreSettingView:(ZFHKNormalPlayerMoreSettingView*)view state:(NSInteger)state {
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



- (void)zfHKNormalPlayerMoreSettingView:(ZFHKNormalPlayerMoreSettingView*)view feedBack:(NSString*)feedBack {

    if (self.landScapeFeedBackBtnClickCallback) {
        self.landScapeFeedBackBtnClickCallback();
    }
}

/** 七牛线路 */
- (void)zfHKNormalPlayerMoreSettingView:(ZFHKNormalPlayerMoreSettingView*)view qiniuLineBtn:(UIButton*)qiniuLineBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ZFHKNormalLandScapeControlView:qiniuLineBtn:)]) {
        [self.delegate ZFHKNormalLandScapeControlView:self qiniuLineBtn:qiniuLineBtn];
    }
}


/** 腾讯线路 */
- (void)zfHKNormalPlayerMoreSettingView:(ZFHKNormalPlayerMoreSettingView*)view txLineBtn:(UIButton*)txLineBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ZFHKNormalLandScapeControlView:txLineBtn:)]) {
        [self.delegate ZFHKNormalLandScapeControlView:self txLineBtn:txLineBtn];
    }
}


- (void)showLandScapeControlViewAirPlayBtn:(BOOL)hidden {
    self.airPlayBtn.hidden = hidden;
    self.audioBtn.hidden = hidden;
}


- (UIView*)shadowCoverView {
    if (!_shadowCoverView) {
        _shadowCoverView = [UIView new];
        _shadowCoverView.backgroundColor = [UIColor clearColor];
        //_shadowCoverView.alpha = 0.45;
    }
    return _shadowCoverView;
}



- (void)showLandScapeShadowCoverView {
    if (_shadowCoverView) {
        _shadowCoverView.hidden = NO;
    }
}

- (ZFHKNormalPlayerResolutionView*)playerResolutionView {
    if (!_playerResolutionView) {
        _playerResolutionView = [[ZFHKNormalPlayerResolutionView alloc]initWithIsportrait:NO];
        _playerResolutionView.hidden = YES;
        _playerResolutionView.delegate = self;
        _playerResolutionView.tag = 200;
    }
    return _playerResolutionView;
}


- (void)showPlayerResolutionView {
    
    NSString *text = self.resolutionBtn.titleLabel.text;
    NSInteger index = [ZFHKNormalPlayerPlayRate normalPlayerPlayRateIndexWithRateStr:text];
    
    [self removePlayerResolutionView];
    self.playerResolutionView.hidden = NO;
    [self.playerResolutionView selectResolutionWithRateIndex:index];
    
    CGFloat min_view_h = self.height;
    CGFloat min_view_w = self.width;
    CGFloat min_w = self.width*0.17;
    self.playerResolutionView.frame = CGRectMake(min_view_w, 0, min_w, min_view_h);
    [self addSubview:self.playerResolutionView];
    [UIView animateWithDuration:0.2 animations:^{
        self.playerResolutionView.zf_x = min_view_w - min_w;
    }];
}



- (void)hiddenPlayerResolutionView {
    if (_playerResolutionView) {
        [UIView animateWithDuration:0.3 animations:^{
            _playerResolutionView.zf_x = self.zf_width;
        } completion:^(BOOL finished) {
          [self removePlayerResolutionView];
        }];
    }
}


- (void)removePlayerResolutionView {
    self.isHiddenPlayerResolutionView = NO;
    TTVIEW_RELEASE_SAFELY(_playerResolutionView);
}


////ZFHKNormalPlayerResolutionViewDelegate
- (void)zFHKNormalPlayerResolutionView:(nullable UIView*)view resolutionBtn:(UIButton*)resolutionBtn {
    
    [self.resolutionBtn setTitle:resolutionBtn.titleLabel.text forState:UIControlStateNormal];
    if (self.delegate && [self.delegate respondsToSelector:@selector(zfHKNormalLandScapeControlView: resolutionBtn: rate: index:)]) {
        [ZFHKNormalPlayerPlayRate saveNormalPlayerPlayRate:(resolutionBtn.tag - 200)+1];
        // 这里开启倍速功能
        CGFloat rate = ((resolutionBtn.tag - 200) * 0.25) + 0.75;
        if (rate > 2.0) rate = 3.0;
        [self.delegate zfHKNormalLandScapeControlView:self resolutionBtn:resolutionBtn rate:rate index:(resolutionBtn.tag - 200)];
        [self umRateEvent:resolutionBtn.tag - 200];
    }
}


/// 友盟统计
- (void)umRateEvent:(NSInteger)index {
    switch (index) {
        case 0:
            [MobClick event:um_videodetailpage_fulllplayer_speed0_75];
            break;
        case 1:
            [MobClick event:um_videodetailpage_fulllplayer_speed1_0X];
            break;
        case 2:
            [MobClick event:um_videodetailpage_fulllplayer_speed1_25X];
            break;
        case 3:
            [MobClick event:um_videodetailpage_fulllplayer_speed1_5X];
            break;
        case 4:
            [MobClick event:um_videodetailpage_fulllplayer_speed2_0X];
            break;
        default:
            break;
    }
}




- (void)showMaterialTipView {
    if (nil == self.materialTipView) {
        ZFHKNormalPlayerMaterialTipView *tipView = [[ZFHKNormalPlayerMaterialTipView alloc]init];
        self.materialTipView = tipView;
    }
    [self addSubview:self.materialTipView];
    [self.materialTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(94);
        make.right.equalTo(self.mas_right).offset(-(IS_IPHONE_X ?PADDING_20*2 :PADDING_15));
        make.size.mas_equalTo(CGSizeMake(157, 65));
    }];
}




- (UIButton *)fastPlayBtn {
    if (!_fastPlayBtn) {
        _fastPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fastPlayBtn setBackgroundImage:imageName(@"ic_forward_2_33") forState:UIControlStateNormal];
//        [_fastPlayBtn setBackgroundImage:imageName(@"ic_forward_2_33") forState:UIControlStateHighlighted];
        [_fastPlayBtn addTarget:self action:@selector(fastPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_fastPlayBtn sizeToFit];
        [_fastPlayBtn setHKEnlargeEdge:20];
        _fastPlayBtn.hidden = YES;
    }
    return _fastPlayBtn;
}



- (UIButton *)backPlayBtn {
    if (!_backPlayBtn) {
        _backPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backPlayBtn setBackgroundImage:imageName(@"ic_rewind_2_33") forState:UIControlStateNormal];
//        [_backPlayBtn setBackgroundImage:imageName(@"ic_rewind_2_33") forState:UIControlStateHighlighted];
        [_backPlayBtn addTarget:self action:@selector(backPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backPlayBtn sizeToFit];
        [_backPlayBtn setHKEnlargeEdge:20];
        _backPlayBtn.hidden = YES;
    }
    return _backPlayBtn;
}


- (UILabel*)forwardLB {
    if (!_forwardLB) {
        _forwardLB = [UILabel labelWithTitle:CGRectZero title:@"+5s" titleColor:[UIColor whiteColor] titleFont:nil titleAligment:NSTextAlignmentCenter];
        _forwardLB.font = HK_FONT_SYSTEM_WEIGHT(25, UIFontWeightSemibold);
        _forwardLB.backgroundColor = [UIColor clearColor];
        _forwardLB.hidden = YES;
    }
    return _forwardLB;
}



- (void)fastPlayBtnClick:(UIButton*)btn {
    if (self.landScapeFastForwardBtnClickCallback) {
        [self showForwardLB:NO];
        self.landScapeFastForwardBtnClickCallback(btn);
        [MobClick event:um_videodetailpage_fulllplayer_fast5];
    }
}


- (void)backPlayBtnClick:(UIButton*)btn {
    if (self.landScapeBackForwardBtnClickCallback) {
        [self showForwardLB:YES];
        self.landScapeBackForwardBtnClickCallback(btn);
        [MobClick event:um_videodetailpage_fulllplayer_return5];
    }
}



- (void)showForwardLB:(BOOL)isBack {
    
    [self immediateHiddenForwardLB];
    if (nil == _forwardLB) {
        [self addSubview:self.forwardLB];
    }
    
    self.forwardLB.text = isBack ?@"-5s" :@"+5s";
    self.forwardLB.size = CGSizeMake(70, 40);
    self.forwardLB.center = self.center;
    [self.forwardLB setNeedsLayout];
    [self.forwardLB layoutIfNeeded];
        
    [self forwardLBOpacityAnimation];
}



- (void)immediateHiddenForwardLB {
    if (_forwardLB) {
        [_forwardLB.layer removeAllAnimations];
    }
}


- (void)hiddenForwardLB {
    if (_forwardLB) {
        _forwardLB.hidden = YES;
        TTVIEW_RELEASE_SAFELY(_forwardLB);
    }
}



- (void)forwardLBOpacityAnimation  {
    // 透明动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.f];
    animation.removedOnCompletion = YES;
    animation.duration = 1.5;
    animation.delegate = self;
    if (_forwardLB) {
        [_forwardLB.layer addAnimation:animation forKey:@"opacity"];
        _forwardLB.layer.opacity = 0.0;
        _forwardLB.hidden = NO;
    }
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self hiddenForwardLB];
}



- (void)hiddenForwardBtn:(BOOL)isHidden {
    
    
    
    
    self.fastPlayBtn.hidden = isHidden;
    self.backPlayBtn.hidden = isHidden;
    self.editBtn.hidden = isHidden;
    
    self.fastPlayBtn.zf_right = iPhoneX ? self.zf_right + 82: self.zf_right+47;
    self.backPlayBtn.zf_right = iPhoneX ? self.zf_right + 82: self.zf_right + 47;
    self.editBtn.zf_left = iPhoneX ? -82: -47;
    self.noteTipLabel.hidden = YES;
}


- (void)showForwardBtn:(BOOL)isShow {
    
    if (self.player.isLockedScreen) {
        [self hiddenForwardBtn:YES];
    }else{
        self.fastPlayBtn.hidden = !isShow;
        self.backPlayBtn.hidden = !isShow;
        self.editBtn.hidden = !isShow;
        
        self.fastPlayBtn.zf_right = iPhoneX ? self.zf_right - 82: self.zf_right - 47;
        self.backPlayBtn.zf_right = iPhoneX ? self.zf_right - 82: self.zf_right - 47;
        self.editBtn.zf_left = iPhoneX ? 50: 18;
        
        
        BOOL show = [[NSUserDefaults standardUserDefaults] boolForKey:@"showNoteTipLabel"];
        if (show) {
            self.noteTipLabel.hidden = YES;
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.noteTipLabel.hidden = NO;
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showNoteTipLabel"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            });
            
        }
    }
}


- (void)showOrhiddenTopToolView:(BOOL)isShow {
    self.resolutionBtn.hidden = !isShow;
    if (!self.topGraphicBtn.hidden) {
        
    }
    if (!isEmpty(self.videoDetailModel.pictext_url)) {
        // 有的视频 无图文
        self.topGraphicBtn.hidden = !isShow;
    }
    self.moreSettingBtn.hidden = !isShow;
    self.airPlayBtn.hidden = !isShow;
    self.audioBtn.hidden = !isShow;
}

-(UILabel *)noteTipLabel{
    if (_noteTipLabel == nil) {
        _noteTipLabel = [UILabel labelWithTitle:CGRectZero title:@"点击记录课程图片笔记~" titleColor:[UIColor colorWithHexString:@"#FFD305"] titleFont:@"12" titleAligment:NSTextAlignmentCenter];
        [_noteTipLabel addCornerRadius:3 addBoderWithColor:[UIColor colorWithHexString:@"#FFD305"]];
        _noteTipLabel.hidden = YES;
    }
    return _noteTipLabel;
}


- (BOOL)is24H{
    if(!_is24H){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateStyle:NSDateFormatterNoStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
        NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
        _is24H = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
    }
    return _is24H;
}


@end





