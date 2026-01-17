//
//  MyLoadingCell.m
//  Code
//
//  Created by Ivan li on 2017/8/28.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "MyLoadingCell.h"
#import "HKDownloadModel.h"
#import "UIView+SNFoundation.h"
#import "hkLineProgressView.h"


@interface MyLoadingCell()

/// 下载时进度条 图片
@property (nonatomic,strong) UIImage *loadingImage;
/// 暂停时进度条 图片
@property (nonatomic,strong) UIImage *pauseImage;

@property (nonatomic,strong)hkLineProgressView *lineProgress;

@end





@implementation MyLoadingCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setObserver];
        [self makeConstraints];
    }
    return self;
}


- (void)createUI {
    
    [self.contentView addSubview:self.cellBgView];
    [self.cellBgView addSubview:self.iconImageView];
    [self.cellBgView addSubview:self.titleLabel];
    
    [self.cellBgView addSubview:self.timeLabel];
    [self.cellBgView addSubview:self.downloadBtn];
    
    [self.cellBgView addSubview:self.progress];
    [self.cellBgView addSubview:self.selectBtn];
    
    [self.cellBgView addSubview:self.statusLabel];
    [self.cellBgView addSubview:self.progressLabel];
    
    [self.cellBgView addSubview:self.lineProgress];
    [self hkDarkModel];
}


- (void)hkDarkModel {
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    self.timeLabel.textColor = COLOR_A8ABBE_7B8196;
    self.progressLabel.textColor = COLOR_A8ABBE_7B8196;
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    [self makeConstraints];
//}


- (void)makeConstraints {
    
    [self.cellBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cellBgView.mas_centerY);
        make.left.equalTo(self.cellBgView.mas_left).offset(-PADDING_25);
        make.size.mas_equalTo(CGSizeMake(PADDING_25, PADDING_25));
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectBtn.mas_right).offset(PADDING_10);
        make.top.equalTo(self.cellBgView).offset(PADDING_15);
        make.size.mas_equalTo(CGSizeMake(155, 95));
    }];
        
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.mas_right).offset(PADDING_10);
        make.right.equalTo(self.cellBgView.mas_right).offset(-PADDING_30);
    }];
    
    [self.downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cellBgView.mas_right).offset(-PADDING_10);
        make.bottom.equalTo(self.cellBgView.mas_bottom).offset(-PADDING_15);
        make.size.mas_equalTo(CGSizeMake(PADDING_25*2, PADDING_25));
    }];
    
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.right.equalTo(self.downloadBtn);
        make.height.mas_equalTo(3);
    }];
    
    
    
//    [self.lineProgress mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.titleLabel);
//        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
//        make.right.equalTo(self.downloadBtn);
//        make.height.mas_equalTo(3);
//    }];
//
//    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.progress.mas_bottom).offset(5);
//        make.left.equalTo(self.progress);
//        make.right.lessThanOrEqualTo(self.progressLabel.mas_left).offset(-2);
//    }];
//
//    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.progress);
//        make.top.equalTo(self.progress.mas_bottom).offset(5);
//        make.width.mas_lessThanOrEqualTo(60);
//    }];
//
//    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.statusLabel.mas_bottom).offset(8);
//        make.left.equalTo(self.titleLabel);
//        make.right.equalTo(self.cellBgView).offset(-PADDING_5);
//    }];
    
    

    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImageView.mas_bottom);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.cellBgView).offset(-PADDING_5);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.timeLabel.mas_top).offset(-5);
        make.left.equalTo(self.progress);
        make.right.lessThanOrEqualTo(self.progressLabel.mas_left).offset(-2);
    }];
    
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.lineProgress.mas_right);
        make.top.equalTo(self.statusLabel);
        make.width.mas_lessThanOrEqualTo(60);
    }];
    
    [self.lineProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.statusLabel.mas_top).offset(-5);
        make.right.equalTo(self.titleLabel);
        make.height.mas_equalTo(3);
    }];
}



- (void)updateEditAllConstraints {
    
    WeakSelf;
    [_cellBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(PADDING_30);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(0);
        make.top.bottom.equalTo(weakSelf.contentView);
    }];
}



- (void)updateNoEditAllConstraints {
    WeakSelf;
    [_cellBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView);
    }];
}


- (UIView*)cellBgView {
    
    if (!_cellBgView) {
        _cellBgView = [UIView new];
    }
    return _cellBgView;
}



- (UIImageView*)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.size = CGSizeMake(155, 95);
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = 5;
    }
    return _iconImageView;
}



- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F titleFont:@"14" titleAligment:NSTextAlignmentLeft];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}


- (UILabel*)statusLabel {
    if (!_statusLabel) {
        _statusLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_7B8196 titleFont:@"12" titleAligment:NSTextAlignmentLeft];
    }
    return _statusLabel;
}


- (UILabel*)timeLabel {
    if (!_timeLabel) {
        _timeLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE titleFont:@"11" titleAligment:NSTextAlignmentLeft];
    }
    return _timeLabel;
}


- (UILabel*)progressLabel {
    if (!_progressLabel) {
        _progressLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE titleFont:@"12" titleAligment:NSTextAlignmentLeft];
    }
    return _progressLabel;
}


- (UIButton*)downloadBtn {
    
    if (!_downloadBtn) {
        _downloadBtn = [UIButton buttonWithTitle:nil titleColor:[UIColor whiteColor] titleFont:nil imageName:nil];
        _downloadBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = CGRectMake(0, 0, 50, 25);
        
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        borderLayer.frame = CGRectMake(0, 0, 50, 25);
        borderLayer.lineWidth = 1.5f;
        borderLayer.strokeColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
        borderLayer.fillColor = [UIColor clearColor].CGColor;
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 50, 25) cornerRadius:4];
        maskLayer.path = bezierPath.CGPath;
        borderLayer.path = bezierPath.CGPath;
        
        [_downloadBtn.layer insertSublayer:borderLayer atIndex:0];
        [_downloadBtn.layer setMask:maskLayer];
        
        [_downloadBtn.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [_downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
        [_downloadBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [_downloadBtn.titleLabel setFont:[UIFont systemFontOfSize:IS_IPHONE6PLUS ? 15:14]];
        [_downloadBtn addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
        _downloadBtn.hidden = YES;
    }
    return _downloadBtn;
}



- (hkLineProgressView*)lineProgress {
    if (!_lineProgress) {
        _lineProgress = [[hkLineProgressView alloc] init];
        _lineProgress.maximumTrackTintColor = COLOR_EFEFF6;
        //_lineProgress.minimumTrackTintColor = HKColorFromHex(0xFFD305, 1.0);
        _lineProgress.sliderHeight = 3;
        _lineProgress.minimumTrackImage = self.loadingImage;
    }
    return _lineProgress;
}





- (UIProgressView*)progress {
    
    if (!_progress) {
        _progress = [UIProgressView new];
        //设置进度条颜色
        _progress.trackTintColor = COLOR_EFEFF6;
        //设置进度默认值，这个相当于百分比，范围在0~1之间，不可以设置最大最小值
        _progress.progress = 0.0;
        //设置进度条上进度的颜色
        //_progress.progressTintColor = [UIColor colorWithHexString:@"#ffd500"];
        _progress.progressTintColor = COLOR_A8ABBE;
        //设置进度条的背景图片
        _progress.trackImage = [UIImage new];
        //设置进度条上进度的背景图片
        _progress.progressImage = self.pauseImage; //[UIImage imageNamed:@""];
        _progress.hidden = YES;
    }
    return _progress;
}



- (UIImage*)loadingImage {
    if (nil == _loadingImage) {
        UIColor *color2 = [UIColor colorWithHexString:@"#FFB600"];
        UIColor *color1 = [UIColor colorWithHexString:@"#FFA300"];
        UIColor *color = [UIColor colorWithHexString:@"#FF8A00"];
        _loadingImage = [[UIImage alloc]createImageWithSize:CGSizeMake(3, 3) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
        [_loadingImage roundCornerImageWithRadius:1.5];
    }
    return _loadingImage;
}


- (UIImage*)pauseImage {
    if (nil == _pauseImage) {
        _pauseImage = [UIImage createImageWithColor:COLOR_A8ABBE size:CGSizeMake(3, 3)];
        [_pauseImage roundCornerImageWithRadius:1.5];
    }
    return _pauseImage;
}


- (void)downloadAction:(UIButton*)sender {
    
    if (self.btnClickBlock) {
        self.btnClickBlock(self.downloadModel);
    }
}



- (UIButton*)selectBtn {
    
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.tag = 30;
        [_selectBtn setImage:imageName(@"cirlce_gray") forState:UIControlStateNormal];
        [_selectBtn setImage:imageName(@"right_green") forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}



-(void)checkboxClick:(UIButton *)btn {
    
    btn.selected = !btn.selected;
    if (btn.selected) {
        _downloadModel.cellClickState = 1;
    }else{
        _downloadModel.cellClickState = 0;
    }
    self.selectBlock ? self.selectBlock(btn.selected,_downloadModel) : nil;
}


#pragma mark - 编辑状态下 点击 cell 选中
- (void)clickAllRow:(BOOL)selected {
    
    if (selected == YES) {
        UIButton *btn = self.selectBtn;
        btn.selected = !btn.selected;
        
        HKDownloadModel *temp = [[HKDownloadModel alloc]init];
        temp = _downloadModel;
        
        if (btn.selected) {
            _downloadModel.cellClickState = 1;
        }else{
            _downloadModel.cellClickState = 0;
        }
        self.selectBlock ? self.selectBlock(btn.selected,_downloadModel) : nil;
    }
}



- (void)setDownloadModel:(HKDownloadModel *)downloadModel {
    
    _downloadModel = downloadModel;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:downloadModel.imageUrl]] placeholderImage:imageName(HK_Placeholder)];
    _titleLabel.text = [NSString stringWithFormat:@"%@",downloadModel.name];
    
    _timeLabel.text = [NSString stringWithFormat:@"视频时长：%@",downloadModel.videoDuration];
    [self setDownloadStateWithFileModel:downloadModel];
        
    // 判断选中状态
    if (_downloadModel.cellClickState == 1) {
        _selectBtn.selected = YES;
    } else {
        _selectBtn.selected = NO;
    }
}



#pragma mark - 赋值 并设置 控件约束
- (void)setAllModel:(HKDownloadModel *)downloadModel isEdit:(BOOL)isEdit {
    
    [self setDownloadModel:downloadModel];
    if (isEdit){
        [self updateEditAllConstraints];
        //self.downloadBtn.hidden = YES;
    }else{
        [self updateNoEditAllConstraints];
        //self.downloadBtn.hidden = NO;
    }
}



#pragma mark - 下载时刷新
- (void)updateDownloadModel:(HKDownloadModel *)downloadModel {
        
    _downloadModel = downloadModel;
    [self setDownloadStateWithFileModel:downloadModel];
}




- (void)setDownloadStateWithFileModel:(HKDownloadModel *)fileInfo  {
    
    NSString *title = nil;
    UIColor *color = nil;
    
    BOOL isokNetwork = (NO == [HkNetworkManageCenter shareInstance].isNoActiveNetStatus);
    
    switch (fileInfo.status) {
        case HKDownloadWaiting:
            title = isokNetwork ?@"暂无网络" :@"等待下载";
            color = COLOR_7B8196;
            break;
        case HKDownloadPause:
            title = @"已暂停";
            color = COLOR_FF7820;
            break;
        case HKDownloading:
            title = isokNetwork ?@"暂无网络" :@"下载中";
            if (fileInfo.downloadRate>0 && !isokNetwork) {
                title = fileInfo.rateStr;
            }
            
            color = COLOR_7B8196;
            break;
        case HKDownloadFinished:
            title = @"已完成";
            color = COLOR_7B8196;
            break;
        case HKDownloadFailed:
            title = @"下载失败，点击重试";
            if (AFNetworkReachabilityStatusReachableViaWWAN == [HkNetworkManageCenter shareInstance].networkStatus) {
                title = @"移动网络下暂停下载";
            }
            if (isokNetwork) {
                title = @"暂无网络";
            }
            color = COLOR_FF7820;
            break;
        default:
            break;
    }
    [self setDownBtnWithTitle:title];
    
    [_progress setProgress:fileInfo.downloadPercent animated:YES];
    
    NSMutableAttributedString *attributedText = [NSMutableAttributedString mutableAttributedString:title LineSpace:0 color:color font:HK_FONT_SYSTEM(12)];
    self.statusLabel.attributedText = attributedText;
    self.progressLabel.text = [NSString stringWithFormat:@"%.f%@",floor(fileInfo.downloadPercent * 100),@"%"];
    /// 设置 进度条 进度图片
    self.progress.progressImage = (HKDownloading == fileInfo.status) ?self.loadingImage :self.pauseImage;
    
    self.lineProgress.value = fileInfo.downloadPercent;
    self.lineProgress.minimumTrackImage = (HKDownloading == fileInfo.status) ?self.loadingImage :self.pauseImage;
    
    if ((HKDownloading == fileInfo.status)) {
        UIColor *borderColor = [UIColor colorWithHexString:@"#FF8A00"];
        UIColor *backgroundColor = [UIColor colorWithHexString:@"#FFFCED"];
        [self.lineProgress setMaximumTrackBorderColor:borderColor backgroundColor:backgroundColor];
    }else{
        [self.lineProgress resetMaximumTrackBorderColor];
    }
}



- (void)setDownBtnWithTitle:(NSString *)title {
    
    [_downloadBtn setTitle:title forState:UIControlStateNormal];
}



#pragma mark - 网络改变通知通知
- (void)setObserver {
    
    [MyNotification addObserver:self
                       selector:@selector(editNotification:)
                           name:@"loadingedit"
                         object:nil];
    
}


- (void)editNotification:(NSNotification *)noti {
    
    NSDictionary *dict = noti.userInfo;
    NSInteger  status = [dict[@"loadingedit"] integerValue];
    self.edit = status;
    if (status == 1) {
        [self updateEditAllConstraints];
        //self.downloadBtn.hidden = YES;
    }else{
        //self.downloadBtn.hidden = NO;
        [self updateNoEditAllConstraints];
    }
}




@end


