//
//  ZFHKNormalPlayerControlView+Category.m
//  Code
//
//  Created by Ivan li on 2019/3/12.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "ZFHKNormalPlayerControlView+Category.h"
#import "ZFHNomalCustom.h"
#import "HKAirPlayCoverView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ZFHKNormalUtilities.h"
#import "HKPlaytipByWWANTool.h"
#import "LBLelinkKitManager.h"


@implementation ZFHKNormalPlayerControlView (Category)


/**
 @return Yes 已下载
 */
- (BOOL)isDownloadFinsh:(DetailModel *)detailModel {
    
    if (isEmpty(detailModel.video_id)) {
        return NO;
    }
    HKDownloadModel *model = [[HKDownloadManager shareInstance] queryWidthID:detailModel.video_id videoType:[detailModel.video_type intValue]];
    self.downloadModel = model;
    if (HKDownloadFinished == model.status) {
        return YES;
    }
    return NO;
}



/**
 已下载的视频 NSURL
 
 @return NSURL
 */
- (NSURL *)downloadFilePath {
    
    if (self.downloadFinsh) {
        // 1.6前的cache文件 存放在缓存文件下，存储不够时 视频会被清除
        //if (self.downloadModel.saveInCache)
        
        // 1.7 document文件
        NSString *videoId = self.videoDetailModel.video_id;
        int videoType = [self.videoDetailModel.video_type intValue];
        
        NSString *url = [NSString stringWithFormat:@"http://127.0.0.1:12345/download/%@/movie.m3u8",videoId];
        // 1.8版本
        BOOL isDirectory1_7 = NO;
        BOOL exist1_7 = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/download/%@/movie.m3u8",HKDocumentPath, videoId] isDirectory:&isDirectory1_7];
        if (!exist1_7) {
            url = [NSString stringWithFormat:@"http://127.0.0.1:12345/download/%@_%d/movie.m3u8",videoId, videoType];
        }        
        return [NSURL URLWithString:url];
    }
    return nil;
}



/**
 开启本地服务
 */
- (void)startLocalServer:(void(^)())sucess fail:(void(^)())fail {
    
    // 1.6前的cache文件 存放在缓存文件下，存储不够时 视频会被清除
    //if (model.saveInCache) {webPath =  kLibraryCache}
    
    [self stopLocalServer];
    // 设置服务器路径
    [self.httpServer setDocumentRoot:HKDocumentPath];
    NSError *err = nil;
    if ([self.httpServer start:&err]) {
        NSLog(@"开启HTTP服务器 端口:%hu",[self.httpServer listeningPort]);
        sucess();
    }else{
        fail();
    }
}



/**
 终止本地服务
 */
- (void)stopLocalServer {
    if ([self.httpServer isRunning]) {
        [self.httpServer stop:YES];
    }
}



/**
 重置开始播放时间
 @return
 */
- (NSInteger)resetPlayTime:(HKPermissionVideoModel *)model {
    
    NSInteger second = 0;
    NSString *date = [DateChange DateFromNetWorkString:model.play_time.updated_at];
    //本地时间记录
    HKSeekTimeModel *seekTimeM = [HKPlayerLocalRateTool querySeekModel:self.videoDetailModel];
    if (!seekTimeM) {
        second = model.play_time.time;
    }else{
        int day = [DateChange compareDate:seekTimeM.seekTimeUpdate withDate:date];
        if (day>=0) {//date小于或者等于本地的时间
            // seekTimeUpdate 时间更近
            second = (seekTimeM == nil) ?0 :seekTimeM.seekTime;
        }else{
            second = model.play_time.time;
        }
    }
    
    
    if (self.notesSeekTime>0) {
        self.playerSeekTime = self.notesSeekTime;
        return self.notesSeekTime;
    }
    self.playerSeekTime = second;
    return second;
}



/**
 
 显示无 VIP 提示label
 (3.5后自动消失)
 
 @param model 权限
 */
- (void)showPlayerVipTipLbWithModel:(HKPermissionVideoModel *)model {
    
    if (!isEmpty(model.vip_name) && [model.is_vip isEqualToString:@"0"] && !self.videoDetailModel.fromTrainCourse) {
        //0 非VIP
        [MobClick event:UM_RECORD_VEDIO_PLAYBOTTOM];
        [self addSubview:self.playerVipTipLB];
        [self.playerVipTipLB setModel:model];
        
        [self.playerVipTipLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            //make.left.lessThanOrEqualTo(self).offset(20);
            //make.right.lessThanOrEqualTo(self).offset(-20);
            make.centerX.equalTo(self);
            make.width.mas_lessThanOrEqualTo(self);
            make.top.equalTo(self.backBtn.mas_bottom).offset(15);
            make.height.mas_equalTo(22);
        }];
    }
}



- (void)playtipByWWAN:(void(^)())sureAction  cancelAction: (void(^)())cancelAction {
    
    [HKPlaytipByWWANTool nomarlVideoPlaytipByWWAN:sureAction cancelAction:cancelAction];
}




/**
 显示 VIP购买 视频分享view
 */
- (void)showBuyVipShareView {
    [MobClick event: @"C072001"];//观看受限弹窗曝光 
    [self insertSubview:self.vipShareView belowSubview:self.backBtn];
    [self remakeBuyVipShareViewConstraints];
    self.isLandScapeShowBackBtn = YES;
    self.backBtn.hidden = NO;
}


///更新 VIP 购买 收藏 视图约束
- (void)remakeBuyVipShareViewConstraints {
    UIView *view = [self viewWithTag:2000];
    view.frame = self.bounds;
//    if (view) {
//        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self).offset(iPhoneX ?-15 :0);
//            make.left.bottom.right.equalTo(self);
//            //make.height.mas_equalTo((iPhoneX ?15 :0) + self.height);
//        }];
//    }
}



/**
 移除 VIP购买 视频分享view
 */
- (void)removeBuyVipShareView {
    TTVIEW_RELEASE_SAFELY(self.vipShareView);
}


/** 点击分享 */
- (void)zfHKNormalPlayerBuyVipView:(nullable UIView*)view shareAction:(nonnull id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(zfHKNormalPlayerControlView:shareAction:videoDetailModel:permissionVideoModel:)]) {
        if (self.player.isFullScreen) {
            [self setPlayerPortrait];
        }
        [self.delegate zfHKNormalPlayerControlView:view shareAction:sender videoDetailModel:self.videoDetailModel permissionVideoModel:self.permissionModel];
    }
}


/** 点击购买VIP */
- (void)zfHKNormalPlayerBuyVipView:(nullable UIView*)view buyVipAction:(UIButton*)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(zfHKNormalPlayerControlView:buyVipAction:videoDetailModel:permissionModel:)]) {
        if (self.player.isFullScreen) {
            [self setPlayerPortrait];
        }
        [self.delegate zfHKNormalPlayerControlView:view buyVipAction:sender videoDetailModel:self.videoDetailModel permissionModel:self.permissionModel];
    }
}


/** 强制设置竖屏 */
- (void)setPlayerPortrait {
    if (self.player.orientationObserver.supportInterfaceOrientation & ZFHKNormalInterfaceOrientationMaskPortrait) {
        [self.player enterFullScreen:NO animated:YES];
    }
}


/** 素材下载提示 */
- (void)showMaterialTipView {
    
    if ([self.videoDetailModel.is_show_tips isEqualToString:@"1"]) {        
        [self.landScapeControlView showMaterialTipView];
        self.videoDetailModel.is_show_tips = @"0";
    }
}

/** 进度提示  下一节视频 代理 */
- (void)hkPlayTimeTipAction:(HKPermissionVideoModel *)model {
    if (self.delegate && [self.delegate respondsToSelector:@selector(zfHKNormalPlayerControlView:nextVideoModel:)]) {
        [self.delegate zfHKNormalPlayerControlView:self nextVideoModel:self.videoDetailModel];
    }
}

#pragma mark - 记录播放进度
- (void)recordVideoProgress:(NSInteger)currentTime  videoId:(NSString*)videoId  totalTime:(NSInteger)totalTime{
    
    if (isEmpty(videoId)) {
        return;
    }
    
    //video_id   视频id    //video_time 学习的时长，单位:s   //is_end   是否观看完毕 0否 1是      //total_time  视频总时长，单位:s
    //if ((currentTime > 10) && 10 <(totalTime - currentTime)) {
    if ((currentTime > 10)) {
        // 10秒之内不记录
        BOOL isend = 0;
        if ((totalTime - currentTime)<= 15) {
            isend = 1;
        }else{
            isend = 0;
        }
        
        NSDictionary *dict = @{@"video_time":@(currentTime),@"video_id":videoId,@"total_time":@(totalTime),@"is_end":@(isend)};
        [HKHttpTool POST:VIDEO_SET_PLAY_VIDEO_TIME parameters:dict success:^(id responseObject) {
            NSLog(@"-------");
        } failure:^(NSError *error) {
            
        }];
    }
}

#pragma mark - 播放时长
- (void)recordPlayTimeAndVideoProgress {
    [self releaseNextVideoCountDownView];
}




/** 销毁 倒计时进入下一节课 *///
- (void)releaseNextVideoCountDownView {
    /// 倒计时 下一节课
    UIView *view = [self viewWithTag:300];
    if (view) {
        [self.nextVideoCountDownView killTimer];
    }
}


#pragma mark - 记录播放进度
- (void)recordVideoProgress {
    
    //记录本地播放进度
    NSInteger currentTime = lround(self.player.currentTime);
    
    NSInteger totalTime = lround(self.player.totalTime);
    
    NSString *videoId = self.videoDetailModel.video_id;
    
    [HKPlayerLocalRateTool savePlayerCurrentTime:currentTime
                                       totalTime:totalTime
                                         videoId:videoId
                                       videoType:[self.videoDetailModel.video_type intValue]
                                  isFromDownload:NO
                                     detailModel:self.videoDetailModel];
    //记录播放进度到后台
    [self recordVideoProgress:currentTime videoId:videoId totalTime:totalTime];
}


/** 计算 时间 字符串 宽度 */
- (float)timeWordWidth {
    
    float width = 0;
    if (self.playerSeekTime >0) {
        NSString *time = nil;
        if (self.playerSeekTime >59) {
            NSInteger min = self.playerSeekTime/60;
            NSInteger sec = self.playerSeekTime%60;
            if (sec>0) {
                time = [NSString stringWithFormat:@"%ld分%ld秒",min,sec];
            }else {
                time = [NSString stringWithFormat:@"%ld分",min];
            }
        }else{
            time = [NSString stringWithFormat:@"%ld秒",self.playerSeekTime];
        }
        width = [time sizeWithFont:HK_FONT_SYSTEM(12) maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
        // 网络视频才可以 跳转下一节 ,从下载列表来的 不能跳转
        if ([self.videoDetailModel.video_down_status isEqualToString:@"1"]) {
//            NSString * nextId = self.videoDetailModel.next_video_info.video_id;
//            if (!isEmpty(nextId) && ![nextId isEqualToString:@"0"]) {
//                width += 60;
//            }
        }
    }
    return width;
}



#pragma mark  设置倒计时 提示

/** 到计时提示 播放下一节视频 */
- (void)showNextTimeTipView {
        
    NSString *videoId = self.videoDetailModel.next_video_info.video_id;
    if (!isEmpty(videoId) && ![videoId isEqualToString:@"0"]) {
        //[self addSubview:self.nextVideoCountDownView];
        [self insertSubview:self.nextVideoCountDownView belowSubview:self.backBtn];
        self.nextVideoCountDownView.isFullScreen = self.player.isFullScreen;
        self.isLandScapeShowBackBtn = YES;
        self.backBtn.hidden = NO;
        @weakify(self);
        self.nextVideoCountDownView.backActionBlock = ^{
            @strongify(self);
            [self backAction];
        };
        
        [self.nextVideoCountDownView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
}


- (void)playNextVideo:(id)sender iskillTime:(BOOL)iskillTime {
    //iskillTime -- yes   只是关闭定时器。 NO --  关闭定时器 并 跳转
    if (iskillTime) {
        
    }else{
        if([self.delegate respondsToSelector:@selector(zfHKNormalPlayerControlView:countDownNextVideoModel:)]){
            [self.delegate zfHKNormalPlayerControlView:self countDownNextVideoModel:self.videoDetailModel];
        }
    }
    TTVIEW_RELEASE_SAFELY(self.nextVideoCountDownView);
}


- (void)playNextVideo:(ZFHKPlayerCountDownView*)countDownView repeatBtn:(UIButton*)repeatBtn {
    TTVIEW_RELEASE_SAFELY(self.nextVideoCountDownView);
    [self repeatPlay];
}



#pragma mark - 播放完 推荐视频
- (void)showSimilarVideoView {
    // 推荐教程
    if ([self.videoDetailModel.video_type isEqualToString:@"0"] ) {
        if (0 == self.similarVideoArray.count) {
            [self requestSimilarVideo];
        }else{
            [self setSimilarVideoView];
        }
    }
}



- (void)setSimilarVideoView {
    if (self.player.isFullScreen) {
        [self setFullScreenSimilarVideoView];
    }else{
        [self setSingleSimilarVideoView];
    }
    self.repeatBtn.hidden = YES;
    self.isLandScapeShowBackBtn = YES;
    self.backBtn.hidden = NO;
}


/** 屏幕方向变化 推荐视频显示 */
- (void)setDeviceChangeSimilarVideoView {
    if (self.isPlayEnd) {
        if (self.similarVideoArray.count) {
            if (self.player.isFullScreen) {
                if(self.portraitSimilarVideoView) {
                    self.portraitSimilarVideoView.hidden = YES;
                }
                [self setFullScreenSimilarVideoView];
                self.landScapeSimilarVideoView.hidden = NO;
            }else{
                
                self.landScapeSimilarVideoView.hidden = YES;
                [self setSingleSimilarVideoView];
                self.portraitSimilarVideoView.hidden = NO;
            }
        }
    }
}




/** 请求相似视频*/
- (void)requestSimilarVideo {
    
    if (isEmpty(self.videoDetailModel.video_id)) {
        return;
    }
    WeakSelf;
    NSDictionary *dict = @{@"video_id":self.videoDetailModel.video_id};
    [HKHttpTool POST:VIDEO_GET_RECOMMEND_VIDEO parameters:dict success:^(id responseObject) {
        StrongSelf;
        if (HKReponseOK) {
            NSString *key = @"list";
            if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                if([[responseObject[@"data"] allKeys] containsObject:key]) {
                    strongSelf.similarVideoArray = [VideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
                    [strongSelf setSimilarVideoView];
                }
            }
        }
    } failure:^(NSError *error) {
        
    }];
}



/** 竖屏 推荐视频 */
- (void)setSingleSimilarVideoView {
    
    if (self.similarVideoArray.count>0) {
        
        TTVIEW_RELEASE_SAFELY(self.portraitSimilarVideoView);
        if (self.portraitSimilarVideoView) {
            self.portraitSimilarVideoView.hidden = NO;
            //[self addSubview:self.portraitSimilarVideoView];
            [self insertSubview:self.portraitSimilarVideoView belowSubview:self.backBtn];
            
            self.portraitSimilarVideoView.frame = CGRectMake(0, 0, self.width, self.height);

//            [self.portraitSimilarVideoView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.edges.equalTo(self);
//            }];
//
            self.portraitSimilarVideoView.model = self.similarVideoArray[0];
        }
    }
}


/** 全屏 推荐视频 */
- (void)setFullScreenSimilarVideoView {
    
    if (self.similarVideoArray.count>0) {
        TTVIEW_RELEASE_SAFELY(self.landScapeSimilarVideoView);
        
        if (self.landScapeSimilarVideoView) {
            //[self addSubview:self.landScapeSimilarVideoView];
            [self insertSubview:self.landScapeSimilarVideoView belowSubview:self.backBtn];
            self.landScapeSimilarVideoView.hidden = NO;
            
            
            self.landScapeSimilarVideoView.frame = CGRectMake(0, 0, self.width, self.height);
//            [self.landScapeSimilarVideoView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.top.left.equalTo(self);
//                make.size.mas_equalTo(CGSizeMake(self.width, self.height));
//            }];
            
            self.landScapeSimilarVideoView.dataArray = self.similarVideoArray;
        }
    }
}


- (void)ZFHKPlayerPortraitSimilarVideoView:(UIView*)view similarVideo:(VideoModel*)model {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(zfHKNormalPlayerControlView:portraitSimilarVideoView:)]) {
        [self.delegate zfHKNormalPlayerControlView:view portraitSimilarVideoView:model];
        self.repeatBtn.hidden = NO;
        self.backBtn.hidden = NO;
        [MobClick event:UM_RECORD_DETAIL_PAGE_PLAY_FINISHED_RECOMMED];
        
        [self.similarVideoArray removeAllObjects];
        TTVIEW_RELEASE_SAFELY(self.portraitSimilarVideoView);
        TTVIEW_RELEASE_SAFELY(self.landScapeSimilarVideoView);
    }
}

- (void)ZFHKPlayerPortraitSimilarVideoView:(UIView*)view repeatVideo:(VideoModel*)model {
    //重播
    [self repeatPlay];
    self.backBtn.hidden = NO;
}


/** cell 点击 */
- (void)zfHKPlayerLandScapeSimilarVideoView:(UICollectionView*)collectionView videoModel:(VideoModel*)model {
    if (self.delegate && [self.delegate respondsToSelector:@selector(zfHKNormalPlayerControlView:landScapeSimilarVideoView:)]) {
        
        [self.delegate zfHKNormalPlayerControlView:self landScapeSimilarVideoView:model];
        self.repeatBtn.hidden = NO;
        //self.backBtn.hidden = YES;
        
        [self.similarVideoArray removeAllObjects];
        TTVIEW_RELEASE_SAFELY(self.portraitSimilarVideoView);
        TTVIEW_RELEASE_SAFELY(self.landScapeSimilarVideoView);
        [MobClick event:UM_RECORD_DETAIL_PAGE_PLAY_FINISHED_RECOMMED];
    }
}

/** 重播 */
- (void)zfHKPlayerLandScapeSimilarVideoView:(UIView*)view repeatBtnClick:(id)sender {
    [self repeatPlay];
    self.backBtn.hidden = YES;
}


// 软件入门 播放完了 弹窗
- (void)showPlayEndAchieveDialog {
    
    NSString *videoId = self.videoDetailModel.next_video_info.video_id;
    if (isEmpty(videoId)) {
        NSInteger type = [self.videoDetailModel.video_type intValue];
        if (HKVideoType_LearnPath == type) {
            [self setPlayerPortrait];
            if (self.delegate && [self.delegate respondsToSelector:@selector(zfHKNormalPlayerControlView:playEnd:videoModel:)]) {
                [self.delegate zfHKNormalPlayerControlView:self playEnd:YES videoModel:self.videoDetailModel];
            }
        }
    }
    
//    if ([self.videoDetailModel.is_last_video isEqualToString:@"1"]) {
//        NSInteger type = [self.videoDetailModel.video_type intValue];
//        if (HKVideoType_LearnPath == type) {
//            [self setPlayerPortrait];
//            if (self.delegate && [self.delegate respondsToSelector:@selector(zfHKNormalPlayerControlView:playEnd:videoModel:)]) {
//                [self.delegate zfHKNormalPlayerControlView:self playEnd:YES videoModel:self.videoDetailModel];
//            }
//        }
//    }
    
    // 目录课播放结束
    [self showPathCoursePlayerEndView];
}


/// 目录课播放结束 视图
- (void)showPathCoursePlayerEndView {
    
    NSString *videoId = self.videoDetailModel.next_video_info.video_id;
    if (isEmpty(videoId)) {
        NSInteger type = [self.videoDetailModel.video_type intValue];
        if (HKVideoType_LearnPath == type || HKVideoType_JobPath == type || HKVideoType_UpDownCourse == type || HKVideoType_Series == type ||HKVideoType_PGC == type ) {
            // 无下一节课程
            [self showPlayerEndView];
            self.repeatBtn.hidden = YES;
        }
    }
}


- (void)showPlayerEndView {
    
    [self insertSubview:self.playerEndView belowSubview:self.backBtn];
    self.isLandScapeShowBackBtn = YES;
    self.backBtn.hidden = NO;

    self.playerEndView.hidden = NO;
    @weakify(self);
    self.playerEndView.backActionBlock = ^{
        @strongify(self);
        [self backAction];
    };
    self.playerEndView.repeatActionBlock = ^(UIView *view) {
        @strongify(self);
        [self repeatPlay];
        TTVIEW_RELEASE_SAFELY(view);
    };
    
//    [self.playerEndView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsZero);
//    }];
}



/** 音频切换 */
- (void)zfHKNormalPortraitControlView:(UIView *)view  audioBtn:(UIButton*)audioBtn {
    [self setAudioPlayInfo];
    [MobClick event:UM_RECORD_DETAILPAGE_AUDIO];
}

- (void)ZFHKNormalLandScapeControlView:(UIView *)view  audioBtn:(UIButton*)audioBtn {
    [self setAudioPlayInfo];
    [MobClick event:UM_RECORD_DETAILPAGE_AUDIO];
}


/** 设置音频 播放的 基本信息 */
- (void)setAudioPlayInfo {
    //self.videoDetailModel.cover_image = self.coverImageView.image;
    //self.player.currentPlayerManager.videoDetailModel = self.videoDetailModel;
    self.player.currentPlayerManager.isAudioplay = !self.player.currentPlayerManager.isAudioplay;
    [self showAirPlayBtn:self.player.currentPlayerManager.isAudioplay];
    
    [self hideControlViewWithAnimated:NO];
}


- (void)showAirPlayBtn:(BOOL)hidden {
    //后台播放
    self.player.pauseWhenAppResignActive = (hidden ?NO :YES);
    [self.portraitControlView showPortraitControlViewAirPlayBtn:hidden];
    [self.landScapeControlView showLandScapeControlViewAirPlayBtn:hidden];
}


/// 退出音频
- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer quitAudioPlay:(BOOL)quitAudioPlay {
    self.player.currentPlayerManager.isAudioplay = !self.player.currentPlayerManager.isAudioplay;
    [self showAirPlayBtn:self.player.currentPlayerManager.isAudioplay];
}


#pragma mark --  投屏
- (void)zfHKNormalPortraitControlView:(UIView *)view airPlayBtn:(UIButton*)airPlayBtn {
    
    [MobClick event:DETAILPAGE_SCREENING];
    if (self.delegate && [self.delegate respondsToSelector:@selector(zfHKNormalPlayerControlView:airPlayBtn:isFullScreen:)]) {
        [self.delegate zfHKNormalPlayerControlView:self airPlayBtn:airPlayBtn isFullScreen:NO];
    }
}


- (void)ZFHKNormalLandScapeControlView:(UIView *)view airPlayBtn:(UIButton*)airPlayBtn {
    [MobClick event:DETAILPAGE_SCREENING];
    [self airPlayButtonAction];
}

- (void)ZFHKNormalLandScapeControlView:(UIView *)view addTxtNotes:(UIImage *)img currentTime:(NSInteger)time videoModel:(DetailModel *)videoModel{
    if ([self.delegate respondsToSelector:@selector(zfHKNormalPlayerControlView:addTxtNote:isFullScreen:currentTime:videoModel:)]) {
        if (self.player.isFullScreen) {
            [self setPlayerPortrait];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //[self.delegate zfHKNormalPlayerControlView:self addTxtNote:img isFullScreen:YES];
            [self.delegate zfHKNormalPlayerControlView:self addTxtNote:img isFullScreen:YES currentTime:time videoModel:videoModel];
        });
    }
}

- (void)airPlayButtonAction {
    if ([LBLelinkKitManager sharedManager].isAirPlay) {
        [self changeConnectAirPlay];
    }else{
        //[[LBLelinkKitManager sharedManager].currentConnection disConnect];
        if (self.delegate && [self.delegate respondsToSelector:@selector(zfHKNormalPlayerControlView:airPlayBtn:isFullScreen:)]) {
            if (self.player.isFullScreen) {
                [self setPlayerPortrait];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.delegate zfHKNormalPlayerControlView:self airPlayBtn:nil isFullScreen:YES];
            });
        }
    }
}

/** 断开 投屏设备 */
- (void)disConnectDevice:(HKAirPlayCoverView*)airPlayCoverView {
    
    if (NO == [LBLelinkKitManager sharedManager].isConnected) {
        //恢复声音
        [self.player.currentPlayerManager setVolume:self.player.volume];
        TTVIEW_RELEASE_SAFELY(airPlayCoverView);
        return;
    }
    if ([LBLelinkKitManager sharedManager].isAirPlay) {
        [self changeConnectAirPlay];
    }else{
        [[LBLelinkKitManager sharedManager] stopLelinkPlayer];
        [[LBLelinkKitManager sharedManager].currentConnection disConnect];
    }
}

/** 切换 或 断开 AirPlay */
- (void)changeConnectAirPlay {
    [self.volumView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            [obj sendActionsForControlEvents:UIControlEventTouchUpInside];
            *stop = YES;
        }
    }];
}


#pragma mark -- HKAirPlayCoverViewDelegate
- (void)hKAirPlayCoverView:(HKAirPlayCoverView*)airPlayCoverView quitBtn:(UIButton*)quitBtn {
    [self disConnectDevice:airPlayCoverView];
}

- (void)hKAirPlayCoverView:(HKAirPlayCoverView*)airPlayCoverView changeDeviceBtn:(UIButton*)changeDeviceBtn {
    //[self airPlayButtonAction];
    if ([LBLelinkKitManager sharedManager].isAirPlay) {
        [self changeConnectAirPlay];
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(zfHKNormalPlayerControlView:airPlayBtn:isFullScreen:)]) {
            if (self.player.isFullScreen) {
                [self setPlayerPortrait];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.delegate zfHKNormalPlayerControlView:self airPlayBtn:nil isFullScreen:NO];
            });
        }
    }
}

- (void)hKAirPlayCoverView:(HKAirPlayCoverView*)airPlayCoverView backBtn:(UIButton*)backBtn {
    
    [self backAction];
}

- (void)hKAirPlayCoverView:(HKAirPlayCoverView*)airPlayCoverView repeatBtn:(UIButton*)repeatBtn {
    
}


/**
 返回前一页 (全屏时 返回竖屏)
 */
- (void)backAction {
    if (self.player.isFullScreen) {
        if (self.player.orientationObserver.supportInterfaceOrientation & ZFHKNormalInterfaceOrientationMaskPortrait) {
            [self.player enterFullScreen:NO animated:YES];
        }
    }else{
        if (self.backBtnClickCallback) {
            self.backBtnClickCallback();
        }
    }
}



/** 七牛线路 */
- (void)ZFHKNormalLandScapeControlView:(UIView*)view qiniuLineBtn:(UIButton*)qiniuLineBtn {
    
    NSURL *url = [NSURL URLWithString:self.permissionModel.video_url];
    [self replaceCurrentURL:url];
}
    

/** 腾讯线路 */
- (void)ZFHKNormalLandScapeControlView:(UIView*)view txLineBtn:(UIButton*)txLineBtn {
    
    NSURL *url = [NSURL URLWithString:self.permissionModel.tx_video_url];
    [self replaceCurrentURL:url];
}


- (void)replaceCurrentURL:(NSURL*)url {
    if (self.isDownloadFinsh) {
        return;
    }
    self.player.currentPlayerManager.seekTime = self.player.currentTime;
    self.player.currentPlayerManager.assetURL = url;
}



#pragma mark ZFHKNormalPlayerErrorViewDelegate
/** 重试 */
- (void)zFHKNormalPlayerErrorView:(nullable UIView*)view retryBtn:(UIButton*)retryBtn {
    
    if ([ZFHKNormalReachabilityManager sharedManager].networkReachabilityStatus == ZFHKNormalReachabilityStatusNotReachable) {
        //无网络
        [self.player.currentPlayerManager play];
    }else{
        [self.player.currentPlayerManager reloadPlayer];
    }
    if (self.player.isFullScreen) {
        self.backBtn.hidden = YES;
        self.isLandScapeShowBackBtn = NO;
    }
}

/** 切换线路 */
- (void)zFHKNormalPlayerErrorView:(nullable UIView*)view switchLineBtn:(UIButton*)switchLineBtn {
    
    NSURL *url = nil;
    NSInteger line = [HKNSUserDefaults integerForKey:HKVideoPlayerPlayLine];
    if (0 == line || 1 == line ) {
        line = 2;
        url = [NSURL URLWithString:self.permissionModel.tx_video_url];
    }else{
        line = 1;
        url = [NSURL URLWithString:self.permissionModel.video_url];
    }
    [HKNSUserDefaults setInteger:line forKey:HKVideoPlayerPlayLine];
    [HKNSUserDefaults synchronize];
    [self replaceCurrentURL:url];
    if (self.player.isFullScreen) {
        self.backBtn.hidden = YES;
        self.isLandScapeShowBackBtn = NO;
    }
}

@end






