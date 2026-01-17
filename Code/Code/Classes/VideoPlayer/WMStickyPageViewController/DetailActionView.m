//
//  DetailActionView.m
//  Code
//
//  Created by Ivan li on 2017/10/9.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "DetailActionView.h"
#import "DetailModel.h"
#import "MBProgressHUD+Ali.h"
#import "HKDownloadModel.h"
#import "HKDownloadManager.h"
#import "BaseVideoViewController.h"
#import "UIView+HKLayer.h"

@implementation DetailActionView



- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}


-(UILabel *)materialLabel{
    if (_materialLabel == nil) {
        _materialLabel = [UILabel labelWithTitle:CGRectZero title:@"含素材" titleColor:[UIColor colorWithHexString:@"#FF7820"] titleFont:@"8" titleAligment:NSTextAlignmentCenter];
        _materialLabel.backgroundColor = [UIColor colorWithHexString:@"#FFF0E6"];
        [_materialLabel addCornerRadius:8];
    }
    return _materialLabel;
}

- (void)createUI {
    [self addSubview:self.downloadBtn];
    [self addSubview:self.collectBtn];
    [self addSubview:self.shareBtn];
    [self addSubview:self.materialLabel];

    
    WeakSelf;
    void(^beginBlock)() = ^() {
        [weakSelf mayNotRealBegin];
    };
    self.beginBlock = beginBlock;
    //收藏 通知
    HK_NOTIFICATION_ADD(HKCollectVideoNotification, collectVideoNotification:);
    self.backgroundColor = COLOR_FFFFFF_3D4752;
}


- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    if (self.detailModel.fromTrainCourse || self.detailModel.is_series) {
        [self trainDetailConstraints];
    }else{
        if([self.detailModel.video_type intValue] == HKVideoType_PGC){
            //名师机构
            [self pgcConstraints];
        }else{
            [self otherTypeConstraints];
        }
    }
    [self setBtnTitleEdgeInsets:self.shareBtn];
    [self setBtnTitleEdgeInsets:self.downloadBtn];
    [self setBtnTitleEdgeInsets:self.collectBtn];
    
    if ([self.detailModel.is_show_tips isEqualToString:@"1"]) {
        [self.materialLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 16));
            make.top.equalTo(self.downloadBtn.mas_bottom).offset(10);
            make.centerX.equalTo(self.downloadBtn).offset(3);
        }];
    }
}



/// PGC 约束
- (void)pgcConstraints {
    [@[self.collectBtn,self.downloadBtn,self.shareBtn] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:PADDING_20*2
                                                                        leadSpacing:PADDING_35 tailSpacing:PADDING_35];
    
    [@[self.collectBtn,self.downloadBtn,self.shareBtn] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(PADDING_15);
        make.size.mas_equalTo(CGSizeMake(PADDING_20*2, PADDING_20*2));
    }];
}


/// pgc 以外的视频 约束
- (void)otherTypeConstraints {
    [@[self.collectBtn,self.downloadBtn,self.shareBtn] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:PADDING_20*2
                                                                                          leadSpacing:PADDING_35 tailSpacing:PADDING_35];
    
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(PADDING_15);
        make.size.mas_equalTo(CGSizeMake(PADDING_20*2, PADDING_20*2));
    }];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(16);
        make.size.mas_equalTo(CGSizeMake(PADDING_20*2, PADDING_20*2));
    }];
    [self.downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(12.5);
        make.size.mas_equalTo(CGSizeMake(PADDING_20*2, PADDING_20*2));
    }];
}


/// 训练营 约束
- (void)trainDetailConstraints {
    // 隐藏下载按钮
    self.downloadBtn.hidden = YES;
    [@[self.collectBtn,self.shareBtn] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
                                                                 withFixedItemLength:PADDING_20*2
                                                                         leadSpacing:PADDING_35 tailSpacing:PADDING_35];
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(PADDING_15);
        make.size.mas_equalTo(CGSizeMake(PADDING_20*2, PADDING_20*2));
    }];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(16);
        make.size.mas_equalTo(CGSizeMake(PADDING_20*2, PADDING_20*2));
    }];
}



#pragma mark - 设置按钮文字图片偏移
- (void)setBtnTitleEdgeInsets:(UIButton*)btn {
    
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height+PADDING_10,-30, 0, -10)];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, PADDING_10, btn.titleLabel.frame.size.height+3, 0);
}



- (UIButton*)customBtnWithTitle:(NSString *)title
                          image:(UIImage *)image
                    selectImage:(UIImage *)selectImage
                            tag:(NSInteger )tag
                backgroundColor:(UIColor*)backgroundColor {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = tag;
    [btn.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_A8ABBE_7B8196 forState:UIControlStateNormal];
    [btn setTitleColor:[COLOR_A8ABBE_7B8196 colorWithAlphaComponent:0.8] forState:UIControlStateSelected];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:IS_IPHONE6PLUS ? 12:11]];
    
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selectImage forState:UIControlStateSelected];
    btn.backgroundColor = backgroundColor;
    return  btn;
}



- (UIButton *)downloadBtn {
    
    if (!_downloadBtn) {
        
        UIImage *normalImage = [UIImage hkdm_imageWithNameLight:@"loadVideo_vip" darkImageName:@"loadVideo_vip_dark"];
        _downloadBtn = [self customBtnWithTitle:@"下载"
                                           image:normalImage
                                     selectImage:imageName(@"loadVideo_red")
                                             tag:20 backgroundColor:nil];
        [_downloadBtn addTarget:self action:@selector(loadAndCollectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadBtn;
}



- (UIButton *)collectBtn {
    
    if (!_collectBtn) {
        UIImage *normalImage = [UIImage hkdm_imageWithNameLight:@"star_gray" darkImageName:@"star_gray_dark"];
        _collectBtn =  [self customBtnWithTitle:@"收藏"
                                          image:normalImage
                                    selectImage:imageName(@"collection_red")
                                            tag:22
                                backgroundColor:nil];
        [_collectBtn addTarget:self action:@selector(loadAndCollectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectBtn;
}


- (UIButton*)shareBtn {
    if (!_shareBtn) {
        
        UIImage *normalImage = [UIImage hkdm_imageWithNameLight:@"share_gray" darkImageName:@"share_gray_dark"];
        _shareBtn = [self customBtnWithTitle:@"分享"
                                       image:normalImage
                                 selectImage:nil
                                         tag:24
                             backgroundColor:nil];
        [_shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

- (void)setframeAnimation:(UIButton *)btn  {
    CAKeyframeAnimation *anima = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    NSValue *value1 = [NSNumber numberWithFloat:1.0];
    NSValue *value2 = [NSNumber numberWithFloat:1.2];
    NSValue *value3 = [NSNumber numberWithFloat:1.0];
    anima.values = @[value1,value2,value3];
    anima.duration = 0.2;
    [btn.layer addAnimation:anima forKey:@"scale"];
}



- (void)shareAction:(UIButton *)btn {
    
    [MobClick event:UM_RECORD_DETAIL_PAGE_SHARE];
    [self setframeAnimation:btn];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (NSEC_PER_SEC * 0.2)), dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(shareVideo:)]) {
            [self.delegate shareVideo:self.detailModel];
        }
    });
}



- (void)loadAndCollectAction:(UIButton *)btn {
    [self setframeAnimation:btn];
    
    NSInteger tag = [btn tag];
    if (20 == tag) {
        [MobClick event:UM_RECORD_DETAIL_PAGE_DOWN];
        [self queryDownloadStatusBlock:^(HKDownloadStatus status, HKVideoType videoType) {
            if (status == HKDownloadFinished) {
                showTipDialog(@"已下载完成");
            }
            self.loadVideoBlock ? self.loadVideoBlock(self.downloadModel,self.detailModel, status): nil;
        }];
        
    }else{
        
        [MobClick event:UM_RECORD_DETAIL_PAGE_COLLECT];
        self.collectVideoBlock ? self.collectVideoBlock(self.detailModel): nil;
        if (isLogin()) {
            [self collectOrQuitVideo:self.collectState];
        }
    }
}



/** 根据 vip 类型 重新 设置下载按钮图标 */
- (void)setDownloadBtnNormalImage {
    
    NSInteger vipClass = [self.detailModel.vip_class intValue];
    UIImage *normalImage = [UIImage hkdm_imageWithNameLight:@"loadVideo_vip" darkImageName:@"loadVideo_vip_dark"];
    UIImage * image = (0 == vipClass || 5 == vipClass) ? normalImage :imageName(@"loadVideo_gray");
    [_downloadBtn setImage:image forState:UIControlStateNormal];
}


- (void)setDetailModel:(DetailModel *)detailModel {
    
    _detailModel = detailModel;
    
    HKDownloadModel *downloadModel = [[HKDownloadModel alloc]init];
    downloadModel.url = self.detailModel.video_url;
    downloadModel.videoId = self.detailModel.video_id;
    downloadModel.videoDuration = self.detailModel.video_duration;
    downloadModel.imageUrl = self.detailModel.img_cover_url;
    downloadModel.videoType = self.detailModel.video_type.length? [self.detailModel.video_type intValue] : 0;
    
    if([self.detailModel.video_type intValue] == HKVideoType_PGC){
        downloadModel.name = self.detailModel.course_data.cource_title;
        downloadModel.category = self.detailModel.class_name;
        downloadModel.hardLevel = @"";
    }else{
        downloadModel.name = self.detailModel.video_titel;
        downloadModel.category = self.detailModel.video_application;
        downloadModel.hardLevel = self.detailModel.viedeo_difficulty;
    }
    HKDownloadModel *HKmodelDownload = [HKDownloadModel mj_objectWithKeyValues:downloadModel.mj_JSONData];
    self.downloadModel = HKmodelDownload;
    
    if (detailModel.is_collect == YES) {
        self.collectState = collectStateTrue;
    }else{
        self.collectState = collectStateFale;
    }
    [self queryDownloadStatusBlock:nil];
//    if ([self.detailModel.is_show_tips isEqualToString:@"1"]) {
//    }
    self.materialLabel.hidden = [self.detailModel.is_show_tips isEqualToString:@"1"] ? NO :YES;
    if (_detailModel.fromTrainCourse || _detailModel.is_series) {
        self.materialLabel.hidden = YES;
    }
}


#pragma mark - 设置收藏背景
- (void)setCollectState:(CollectState)collectState {
    _collectState = collectState;
    
    if (collectState == collectStateFale) {
        UIImage *normalImage = [UIImage hkdm_imageWithNameLight:@"star_gray" darkImageName:@"star_gray_dark"];
        [_collectBtn setImage:normalImage forState:UIControlStateNormal];
        [_collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    }else{
        [_collectBtn setImage:imageName(@"collection_red") forState:UIControlStateNormal];
        [_collectBtn setTitle:@"已收藏" forState:UIControlStateNormal];
    }
}


#pragma mark - 查询下载状态 设置下载背景标题
- (void)queryDownloadStatusBlock:(void(^)(HKDownloadStatus status, HKVideoType videoType))statusBlock{
    HKDownloadStatus status = [[HKDownloadManager shareInstance] queryStatus:self.downloadModel];
    
    [self setDownBtnTitleByStatus:status];
    if (status != HKDownloadNotExist && (self.downloadModel.videoType == HKVideoType_Ordinary || self.downloadModel.videoType == HKVideoType_UpDownCourse)) {
        _downloadBtn.selected = YES;
    }else{
        _downloadBtn.selected = NO;
    }
    !statusBlock? : statusBlock(status, self.downloadModel.videoType);
}



- (void)setDownBtnTitleByStatus:(HKDownloadStatus)status {
    
    if (self.detailModel.video_type.intValue == HKVideoType_Ordinary || self.detailModel.video_type.intValue == HKVideoType_UpDownCourse) {
        if (status == HKDownloadNotExist) {
            [_downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
        }else{
            if (status == HKDownloadFinished) {
                [_downloadBtn setTitle:@"已下载" forState:UIControlStateNormal];
                //                _downloadBtn.userInteractionEnabled = NO;
            }else{
                [_downloadBtn setTitle:@"下载中" forState:UIControlStateNormal];
            }
        }
    } else {
        [_downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
    }
}




- (void)collectOrQuitVideo:(CollectState)state {
    
    NSString *type = nil;
    if (state == collectStateFale) {
        type = @"1";
    }else{
        type = @"2";
    }
    WeakSelf;
    [[FWNetWorkServiceMediator sharedInstance] collectOrQuitVideoWithToken:nil videoId:_detailModel.video_id type:type videoType:[_detailModel.video_type integerValue] postNotification:YES completion:^(FWServiceResponse *response) {
        
        NSString *temp = type;
        StrongSelf;
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            NSDictionary *dict = nil;
            if ([temp isEqualToString:@"1"]) {
                //self.collectState = collectStateTrue;
                //[MBProgressHUD showSuccessMessage:@"收藏成功" imageName:@"right_red"];
                dict = @{@"isCollect": @"1",@"video_id": strongSelf.detailModel.video_id};
            }else{
                dict = @{@"isCollect": @"0",@"video_id": strongSelf.detailModel.video_id};
                //self.collectState = collectStateFale;
                //[MBProgressHUD showSuccessMessage:@"取消收藏" imageName:@"right_red"];
            }
            HK_NOTIFICATION_POST_DICT(HKCollectVideoNotification, nil, dict);
        }else{
            showTipDialog(response.msg);
        }
    } failBlock:^(NSError *error) {
        
    }];
}



#pragma mark - 解析收藏通知
- (void)collectVideoNotification:(NSNotification*)noti {
    NSDictionary *dict = noti.userInfo;
    
    NSString *videoId = [dict objectForKey:@"video_id"];
    if (isEmpty(videoId)) {
        return;
    }
    if (![videoId isEqualToString:self.detailModel.video_id]) {
        return;
    }
    NSString *type = [dict objectForKey:@"isCollect"];
    [self collectMessage:type];
}


#pragma mark - 收藏提示
- (void)collectMessage:(NSString*)type {
    
    if ([type isEqualToString:@"1"]) {
        self.collectState = collectStateTrue;
        [MBProgressHUD showSuccessMessage:@"收藏成功" imageName:@"right_red"];
    }else{
        self.collectState = collectStateFale;
        [MBProgressHUD showSuccessMessage:@"取消收藏" imageName:@"right_red"];
    }
}


- (void)didMoveToSuperview {
    [self createObserver];
}


- (void)createObserver {
    [MyNotification addObserver:self
                       selector:@selector(receiveNotification:)
                           name:HKSingleModelChangeNotification
                         object:nil];
}


#pragma mark - 解析通知中的信息
- (void)receiveNotification:(NSNotification *)noti {
    [self queryDownloadStatusBlock:nil];
}

- (void)mayNotRealBegin {
    if (self.detailModel.video_type.intValue == HKVideoType_Ordinary || self.detailModel.video_type.intValue == HKVideoType_UpDownCourse) {
        _downloadBtn.selected = YES;
        [_downloadBtn setTitle:@"下载中" forState:UIControlStateNormal];
    }
}


@end


