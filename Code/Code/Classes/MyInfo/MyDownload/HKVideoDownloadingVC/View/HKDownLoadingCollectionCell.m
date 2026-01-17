//
//  HKDownLoadingCollectionCell.m
//  Code
//
//  Created by Ivan li on 2019/11/11.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKDownLoadingCollectionCell.h"
#import "HKDownloadModel.h"

@implementation HKDownLoadingCollectionCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
        [self setObserver];
    }
    return self;
}


- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
        [self setObserver];
    }
    return self;
}



- (void)createUI {
    
    [self.contentView addSubview:self.cellBgView];
    [self.cellBgView addSubview:self.selectBtn];
    [self.cellBgView addSubview:self.iconImageView];
    
    [self.cellBgView addSubview:self.titleLabel];
    [self.cellBgView addSubview:self.progress];
    [self.cellBgView addSubview:self.statusLB];
    
    [self.cellBgView addSubview:self.timeLabel];
    [self.cellBgView addSubview:self.downloadBtn];
    
    [self makeConstraints];
}



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
        make.bottom.equalTo(self.cellBgView).offset(-PADDING_15);
        make.width.mas_equalTo(155);
    }];
        
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.mas_right).offset(PADDING_10);
        make.right.equalTo(self.cellBgView.mas_right).offset(-PADDING_5);
    }];
    
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.right.equalTo(self.contentView).offset(-18);
        make.height.mas_equalTo(3);
    }];
    
    [self.statusLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.progress.mas_bottom).offset(2);
        make.right.lessThanOrEqualTo(self.contentView).offset(-PADDING_5);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.statusLB.mas_bottom).offset(-PADDING_5);
        make.right.lessThanOrEqualTo(self.contentView).offset(-PADDING_5);
    }];
        
    [self.downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cellBgView.mas_right).offset(-PADDING_10);
        make.bottom.equalTo(self.cellBgView.mas_bottom).offset(-PADDING_15);
        make.size.mas_equalTo(CGSizeMake(PADDING_25*2, PADDING_25));
    }];
}



- (void)updateEditAllConstraints {
    [self.cellBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(PADDING_30);
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.top.bottom.equalTo(self.contentView);
    }];
}



- (void)updateNoEditAllConstraints {
    [self.cellBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
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
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = 5.0;
    }
    return _iconImageView;
}



- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F titleFont:@"14" titleAligment:0];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}



- (UILabel*)statusLB {
    if (!_statusLB) {
        _statusLB  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_7B8196 titleFont:@"12" titleAligment:0];
    }
    return _statusLB;
}



- (UILabel*)timeLabel {
    if (!_timeLabel) {
        _timeLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE titleFont:@"11" titleAligment:0];
    }
    return _timeLabel;
}



- (UIButton*)downloadBtn {
    
    if (!_downloadBtn) {
        _downloadBtn = [UIButton buttonWithTitle:nil titleColor:[UIColor whiteColor] titleFont:nil imageName:nil];
        
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
    }
    return _downloadBtn;
}



- (UIProgressView*)progress {
    
    if (!_progress) {
        _progress = [UIProgressView new];
        //self.progressLabel.text = [NSString stringWithFormat:@"%@ / %@ (%.2f%%)",currentSize, totalSize, progress*100];
        //_progress.frame = (CGRect){20,100,200,50};
        //设置进度条颜色
        _progress.trackTintColor = COLOR_EFEFF6;
        //设置进度默认值，这个相当于百分比，范围在0~1之间，不可以设置最大最小值
        _progress.progress = 0.0;
        //设置进度条上进度的颜色
        _progress.progressTintColor = COLOR_ffd500;
        //设置进度条的背景图片
        _progress.trackImage = [UIImage new];
        //设置进度条上进度的背景图片
        _progress.progressImage = [UIImage new];
    }
    return _progress;
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
    [_progress setProgress:downloadModel.downloadPercent animated:YES];
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
        self.downloadBtn.hidden = YES;
    }else{
        [self updateNoEditAllConstraints];
        self.downloadBtn.hidden = NO;
    }
}



#pragma mark - 下载时刷新
- (void)updateDownloadModel:(HKDownloadModel *)downloadModel {
        
    _downloadModel = downloadModel;
    [_progress setProgress:downloadModel.downloadPercent animated:YES];
    [self setDownloadStateWithFileModel:downloadModel];
}




- (void)setDownloadStateWithFileModel:(HKDownloadModel *)fileInfo  {
    
    switch (fileInfo.status) {
        case HKDownloadWaiting:
            [self setDownBtnWithTitle:@"等待下载"];
            break;
        case HKDownloadPause:
            [self setDownBtnWithTitle:@"已暂停"];
            break;
        case HKDownloading:
            [self setDownBtnWithTitle:@"下载中"];
            break;
        case HKDownloadFinished:
            [self setDownBtnWithTitle:@"已完成"];
            break;
        case HKDownloadFailed:
            [self setDownBtnWithTitle:@"重试"];
            break;
        default:
            break;
    }
}



- (void)setDownBtnWithTitle:(NSString *)title {
    
    [_downloadBtn setTitle:title forState:UIControlStateNormal];
}



#pragma mark - 网络改变通知通知
- (void)setObserver {
        
    HK_NOTIFICATION_ADD_OBJ(@"loadingedit", (editNotification:), self);
}


- (void)editNotification:(NSNotification *)noti {
    
    NSDictionary *dict = noti.userInfo;
    NSInteger  status = [dict[@"loadingedit"] integerValue];
    self.edit = status;
    if (status == 1) {
        [self updateEditAllConstraints];
        self.downloadBtn.hidden = YES;
    }else{
        self.downloadBtn.hidden = NO;
        [self updateNoEditAllConstraints];
    }
}



@end



