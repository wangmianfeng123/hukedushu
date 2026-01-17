//
//  HKListeningControlView.m
//  Code
//
//  Created by Ivan li on 2019/7/16.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKListeningControlView.h"
#import "GKSliderView.h"
#import "MMMaterialDesignSpinner.h"
#import "HKMusicPlayLoadView.h"
#import "HKCustomMarginLabel.h"

#import "HKBookModel.h"
#import "UIImage+Helper.h"
#import "UIButton+Style.h"
#import "HKListeningLoadingView.h"




@interface HKListeningControlView()<GKSliderViewDelegate>

@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong) UIView *sliderView;

@property (nonatomic, strong) UILabel *currentLabel;

@property (nonatomic, strong) UILabel *totalLabel;

@property (nonatomic, strong) GKSliderView *slider;

@property (nonatomic, strong) HKListeningLoadingView *loadView;
/** 目录 */
@property (nonatomic, strong) UIButton *directoryBtn;
/** 定时 */
@property (nonatomic, strong) UIButton *timerBtn;
/** 详情 文稿描述  */
@property (nonatomic, strong) UIButton *detailBtn;
/** 封面图 */
@property (nonatomic, strong) UIImageView *coverIV;
/** 封面小标签 */
@property (nonatomic, strong) HKCustomMarginLabel *coverTagLB;

@property (nonatomic, strong) UIView *bgView;
/** 封面 标签图 */
@property (nonatomic, strong) UIImageView *coverTagIV;
/** 封面图阴影 */
@property (nonatomic, strong) UIImageView *coverShadowIV;
/** 封面图背景 */
@property (nonatomic, strong) UIImageView *coverBgIV;
/** 速率 */
@property (nonatomic, strong) UIButton *rateBtn;
/** 上一节*/
@property (nonatomic, strong) UIButton *preCourseBtn;
/** 下一节*/
@property (nonatomic, strong) UIButton *nextCourseBtn;
/** 目录 */
@property (nonatomic, strong) UILabel *directoryLB;
/** 定时 */
@property (nonatomic, strong) UILabel *timerLB;
/** 纸书 */
@property (nonatomic, strong) UIButton *buyBookBtn;
@end



@implementation HKListeningControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        //self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.bgView];
        // 滑杆
        [self.bgView addSubview:self.sliderView];
        [self.sliderView addSubview:self.currentLabel];
        [self.sliderView addSubview:self.totalLabel];
        [self.sliderView addSubview:self.slider];
        // 底部
        
        [self.bgView addSubview:self.playBtn];
        [self.bgView addSubview:self.loadView];
        [self.bgView addSubview:self.directoryBtn];

        [self.bgView addSubview:self.coverBgIV];
        [self.bgView addSubview:self.timerBtn];
        [self.bgView addSubview:self.coverIV];
        [self.bgView addSubview:self.detailBtn];
        
        [self.bgView addSubview:self.coverShadowIV];
        [self.bgView addSubview:self.coverTagIV];
        
        [self.bgView addSubview:self.rateBtn];
        [self.bgView addSubview:self.preCourseBtn];
        [self.bgView addSubview:self.nextCourseBtn];
        
        [self.bgView addSubview:self.directoryLB];
        [self.bgView addSubview:self.timerLB];
        
        [self.bgView addSubview:self.buyBookBtn];
        [self resetControlView];
        
        self.coverIV.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverIVClick)];
        [self.coverIV addGestureRecognizer:tap];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self beginClick:self.buyBookBtn.imageView];
        });        
    }
    return self;
}

- (void)coverIVClick{
    if (self.bookModel.book_goods.is_show) {
        [self buyBookBtnClick:nil];
    }
}


- (void)dealloc {
    
    [self.loadView invalidateTimer];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
    
    //[self shakeView:self.buyBookBtn.imageView];
}


- (void)makeConstraints {
    //mas_remakeConstraints 重置之前的约束添加新约束
    //mas_makeConstraints 添加新约束

    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [self.coverIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.bgView).offset(20);
        make.size.mas_equalTo(CGSizeMake(127, 190));
    }];
    
    [self.coverBgIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.coverIV).offset(-15);
        make.bottom.right.equalTo(self.coverIV).offset(15);
    }];
    
    [self.coverShadowIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.coverIV);
        make.size.mas_equalTo(CGSizeMake(127, 60));
    }];
    
    [self.coverTagIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverIV).offset(10);
        make.bottom.equalTo(self.coverIV).offset(-10);
    }];


    [self.sliderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.detailBtn.mas_bottom).offset(10);
        make.height.mas_equalTo(50);
    }];

    [self.slider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.sliderView);
        make.left.equalTo(self.sliderView).offset(45);
        make.right.equalTo(self.sliderView).offset(-45);
    }];

    [self.currentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.slider.mas_left);
        make.centerY.equalTo(self.sliderView.mas_centerY);
    }];

    [self.totalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.slider.mas_right);
        make.centerY.equalTo(self.sliderView.mas_centerY);
    }];


    [self.playBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sliderView.mas_bottom).offset(-12);
        make.centerX.equalTo(self.bgView);
    }];
    
    if (self.loadView.superview) {
        [self.loadView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.playBtn).insets(UIEdgeInsetsMake(15, 15, 15, 15));
        }];
    }
    
    [self.preCourseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playBtn);
        make.right.equalTo(self.playBtn.mas_left).offset(-PADDING_10);
    }];
    
    [self.nextCourseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playBtn);
        make.left.equalTo(self.playBtn.mas_right).offset(PADDING_10);
    }];
    

    if (self.bookModel.book_goods.is_show) {
        
        self.rateBtn.centerX = self.centerX;
        self.rateBtn.top = CGRectGetMaxY(self.coverBgIV.frame)+ 15;
        
        self.detailBtn.top = self.rateBtn.top;
        self.detailBtn.right = self.rateBtn.left - 70;
        
        self.buyBookBtn.top = self.rateBtn.top;
        self.buyBookBtn.left = self.rateBtn.right + 70;
        
    }else{
        self.detailBtn.top = CGRectGetMaxY(self.coverBgIV.frame)+ 15;
        self.detailBtn.right = self.centerX - 30;
    
        self.rateBtn.left = self.centerX + 30;
        self.rateBtn.centerY = self.detailBtn.centerY;
    }

    CGFloat magin = 20;
    
    [self.directoryBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playBtn);
        make.left.equalTo(self.contentView).offset(magin);
        //make.right.equalTo(self.playBtn.mas_left).offset(-magin);
    }];
    
    [self.timerBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playBtn);
        //make.left.equalTo(self.playBtn.mas_right).offset(magin);
        make.right.equalTo(self.contentView).offset(-magin);
    }];
    
    [self.directoryLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.directoryBtn);
        make.top.equalTo(self.directoryBtn.mas_bottom).offset(PADDING_5);
    }];
    
    [self.timerLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.timerBtn);
        make.top.equalTo(self.timerBtn.mas_bottom).offset(PADDING_5);
    }];
}


- (void)setCurrentTime:(NSString *)currentTime {
    _currentTime = currentTime;
    
    self.currentLabel.text = currentTime;
//    [self makeConstraints];
}

- (void)setTotalTime:(NSString *)totalTime {
    _totalTime = totalTime;
    
    self.totalLabel.text = totalTime;
}

- (void)setValue:(float)value {
    _value = value;
    self.slider.value = value;
}


- (void)setBufferValue:(float)bufferValue {
    _bufferValue = bufferValue;
    self.slider.bufferValue = bufferValue;
}


- (void)setIsDraging:(BOOL)isDraging {
    _isDraging = isDraging;
}


- (void)resetControlView {
    self.value       = 0;
    self.currentTime = @"00:00";
    self.totalTime   = @"00:00";
}


- (void)showLoadingAnim {
    [self.slider showLoading];
}

- (void)hideLoadingAnim {
    [self.slider hideLoading];
}


/** 暂停 播放按钮加载 动画 */
- (void)hidePlayBtnLoadingAnim {
    if (self.loadView && self) {
        [self.loadView pausedLoading:YES];
        self.loadView.hidden = YES;
    }
}


/** 开始 播放按钮加载 动画 */
- (void)showPlayBtnLoadingAnim {
    
    if (isLogin() && self) {
        if (self.loadView) {
            [self.loadView startLoading:YES];
            self.loadView.hidden = NO;
        }
    }
}


#pragma mark - UserAction
- (void)loveBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlView:didClickLove:)]) {
        [self.delegate controlView:self didClickLove:sender];
    }
}

- (void)downloadBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlView:didClickDownload:)]) {
        [self.delegate controlView:self didClickDownload:sender];
    }
}

- (void)commentBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlView:didClickComment:)]) {
        [self.delegate controlView:self didClickComment:sender];
    }
}

- (void)moreBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlView:didClickMore:)]) {
        [self.delegate controlView:self didClickMore:sender];
    }
}


- (void)playBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlView:didClickPlay:)]) {
        [self.delegate controlView:self didClickPlay:sender];
    }
}

- (void)loopBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlView:didClickLoop:)]) {
        [self.delegate controlView:self didClickLoop:sender];
    }
}

- (void)prevBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlView:didClickPrev:)]) {
        [self.delegate controlView:self didClickPrev:sender];
    }
}

- (void)nextBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlView:didClickNext:)]) {
        [self.delegate controlView:self didClickNext:sender];
    }
}

- (void)listBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlView:didClickList:)]) {
        [self.delegate controlView:self didClickList:sender];
    }
}

#pragma mark - GKSliderViewDelegate
- (void)sliderTouchBegin:(float)value {
    if (!isLogin()) {
        return;
    }
    if (self.isPreparedToPlay &&[self.delegate respondsToSelector:@selector(controlView:didSliderTouchBegan:)]) {
        [self.delegate controlView:self didSliderTouchBegan:value];
        self.isDraging = YES;
    }
}

- (void)sliderTouchEnded:(float)value {
    if (!isLogin()) {
        return;
    }
    if (self.isPreparedToPlay &&[self.delegate respondsToSelector:@selector(controlView:didSliderTouchEnded:)]) {
        [self.delegate controlView:self didSliderTouchEnded:value];
        self.isDraging = NO;
    }
}

- (void)sliderTapped:(float)value {
    if (!isLogin()) {
        return;
    }
    if (self.isPreparedToPlay &&[self.delegate respondsToSelector:@selector(controlView:didSliderTapped:)]) {
        [self.delegate controlView:self didSliderTapped:value];
        self.isDraging = YES;
    }
}

- (void)sliderValueChanged:(float)value {
    if (!isLogin()) {
        return;
    }
    if (self.isPreparedToPlay && [self.delegate respondsToSelector:@selector(controlView:didSliderValueChange:)]) {
        [self.delegate controlView:self didSliderValueChange:value];
    }
}



- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton new];
        [_playBtn setImage:[UIImage imageNamed:@"ic_videostart_v2_14"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"ic_videostart_v2_14"] forState:UIControlStateHighlighted];
        [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}



- (UIView *)sliderView {
    if (!_sliderView) {
        _sliderView = [UIView new];
        _sliderView.backgroundColor = [UIColor clearColor];
    }
    return _sliderView;
}

- (UILabel *)currentLabel {
    if (!_currentLabel) {
        _currentLabel = [UILabel new];
        UIColor *textColor = [UIColor hkdm_colorWithColorLight:COLOR_A8ABBE dark:COLOR_EFEFF6];
        _currentLabel.textColor = textColor;
        _currentLabel.font = HK_TIME_FONT(9); // HK_FONT_SYSTEM(9);
    }
    return _currentLabel;
}



- (UILabel *)totalLabel {
    if (!_totalLabel) {
        _totalLabel = [UILabel new];
        _totalLabel.textColor = COLOR_A8ABBE_7B8196;
        _totalLabel.font = HK_FONT_SYSTEM(9);
    }
    return _totalLabel;
}


- (HKCustomMarginLabel *)coverTagLB {
    if (!_coverTagLB) {
        _coverTagLB = [HKCustomMarginLabel new];
        _coverTagLB.backgroundColor = COLOR_ffffff;
        _coverTagLB.textColor = COLOR_999999;
        _coverTagLB.font = [UIFont systemFontOfSize:12.0];
    }
    return _coverTagLB;
}



- (HKListeningLoadingView *)loadView {
    if (!_loadView) {
        _loadView = [[HKListeningLoadingView alloc] init];
        _loadView.hidden = YES;
    }
    return _loadView;
}



- (GKSliderView *)slider {
    if (!_slider) {
        _slider = [[GKSliderView alloc]initWithFrame:CGRectZero progressMargin:20];
        _slider.isBookSlider = YES;
        _slider.allowTapped = NO;
        
        _slider.maximumTrackTintColor = COLOR_F8F9FA;
        _slider.bufferTrackTintColor  = COLOR_EFEFF6;
        _slider.minimumTrackTintColor = COLOR_FFD305;
        [_slider setThumbImage:imageName(@"ic_point_normal_v2_14") forState:UIControlStateNormal];
        [_slider setThumbImage:imageName(@"ic_point_pressed_v2_14") forState:UIControlStateHighlighted];
        
        _slider.clipsToBounds = YES;
        _slider.layer.cornerRadius = 4;
        _slider.delegate = self;
        _slider.sliderHeight = 4;
        // 默认禁止滑动
        _slider.userInteractionEnabled = NO;
    }
    return _slider;
}



- (UIView*)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}



- (UIImageView*)coverIV {
    if (!_coverIV) {
        _coverIV = [UIImageView new];
        _coverIV.clipsToBounds = YES;
        _coverIV.layer.cornerRadius = 5;
        _coverIV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _coverIV;
}



- (UIImageView*)coverBgIV {
    if (!_coverBgIV) {
        _coverBgIV = [UIImageView new];
        _coverBgIV.clipsToBounds = YES;
        _coverBgIV.layer.cornerRadius = 5;
        UIImage *image = [UIImage hkdm_imageWithNameLight:@"bg_shadow_book_v2_14" darkImageName:@"bg_shadow_book_v2_14_dark"];
        _coverBgIV.image = image;
        //_coverBgIV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _coverBgIV;
}




- (UIImageView*)coverShadowIV {
    if (!_coverShadowIV) {
        _coverShadowIV = [UIImageView new];
        
        _coverShadowIV.image = imageName(@"bg_book_cover_v2.14");
        _coverShadowIV.clipsToBounds = YES;
        _coverShadowIV.layer.cornerRadius = 5;
        _coverShadowIV.hidden = YES;
    }
    return _coverShadowIV;
}



- (UIImageView*)coverTagIV {
    if (!_coverTagIV) {
        _coverTagIV = [UIImageView new];
        _coverTagIV.contentMode = UIViewContentModeScaleAspectFit;
        _coverTagIV.image = imageName(@"tag_free_v2_14");
        
    }
    return _coverTagIV;
}




- (UIButton *)directoryBtn {
    if (!_directoryBtn) {
        _directoryBtn = [UIButton new];
        
        UIImage *image = [UIImage hkdm_imageWithNameLight:@"ic_navigation_v2_14" darkImageName:@"ic_navigation_v2_14_dark"];
        [_directoryBtn setImage:image forState:UIControlStateNormal];
        [_directoryBtn setImage:image forState:UIControlStateHighlighted];
        [_directoryBtn addTarget:self action:@selector(directoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_directoryBtn.titleLabel setFont:HK_TIME_FONT(10)];
        [_directoryBtn setTitleColor:COLOR_7B8196_A8ABBE forState:UIControlStateNormal];
        [_directoryBtn setHKEnlargeEdge:15];
        [_directoryBtn sizeToFit];
        _directoryBtn.hidden = YES;
    }
    return _directoryBtn;
}





- (UIButton *)timerBtn {
    if (!_timerBtn) {
        _timerBtn = [UIButton new];
        
        UIImage *image = [UIImage hkdm_imageWithNameLight:@"ic_timing_v2_14" darkImageName:@"ic_timing_v2_14_dark"];
        [_timerBtn setImage:image forState:UIControlStateNormal];
        [_timerBtn setImage:image forState:UIControlStateHighlighted];
        [_timerBtn addTarget:self action:@selector(timerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_timerBtn.titleLabel setFont:HK_TIME_FONT(10)];
        [_timerBtn setTitleColor:COLOR_7B8196_A8ABBE forState:UIControlStateNormal];
        [_timerBtn setHKEnlargeEdge:15];
        [_timerBtn sizeToFit];
        _timerBtn.hidden = YES;
    }
    return _timerBtn;
}



- (UILabel*)directoryLB {
    if (!_directoryLB) {
        _directoryLB = [UILabel labelWithTitle:CGRectZero title:@"目录" titleColor:COLOR_7B8196_A8ABBE titleFont:nil titleAligment:NSTextAlignmentCenter];
        _directoryLB.font = HK_TIME_FONT(10);
        _directoryLB.hidden = YES;
    }
    return _directoryLB;
}


- (UILabel*)timerLB {
    if (!_timerLB) {
        _timerLB = [UILabel labelWithTitle:CGRectZero title:@"定时" titleColor:COLOR_7B8196_A8ABBE titleFont:nil titleAligment:NSTextAlignmentCenter];
        _timerLB.font = HK_TIME_FONT(10);
        _timerLB.hidden = YES;
    }
    return _timerLB;
}


- (UIButton *)detailBtn {
    if (!_detailBtn) {
        _detailBtn = [UIButton new];
        
        UIImage *image = [UIImage hkdm_imageWithNameLight:@"ic_word_v2_14" darkImageName:@"ic_word_v2_14_dark"];
        [_detailBtn setImage:image forState:UIControlStateNormal];
        [_detailBtn setImage:image forState:UIControlStateHighlighted];
        [_detailBtn addTarget:self action:@selector(detailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
        [_detailBtn setTitle:@"文稿" forState:UIControlStateNormal];
        [_detailBtn setTitle:@"文稿" forState:UIControlStateHighlighted];
        
        [_detailBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
        [_detailBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateHighlighted];
        [_detailBtn.titleLabel setFont:HK_FONT_SYSTEM(10)];
        
        [_detailBtn hkLayoutButtonWithEdgeInsetsStyle:ICButtonEdgeInsetsStyleTop imageTitleSpace:3];
        [_detailBtn sizeToFit];
        [_detailBtn setHKEnlargeEdge:15];
    }
    return _detailBtn;
}


- (UIButton *)buyBookBtn {
    if (!_buyBookBtn) {
        _buyBookBtn = [UIButton new];
        
        UIImage *image = [UIImage hkdm_imageWithNameLight:@"ic_book" darkImageName:@"ic_book"];
        [_buyBookBtn setImage:image forState:UIControlStateNormal];
        [_buyBookBtn setImage:image forState:UIControlStateHighlighted];
        [_buyBookBtn addTarget:self action:@selector(buyBookBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
        [_buyBookBtn setTitle:@"购书包邮" forState:UIControlStateNormal];
        [_buyBookBtn setTitle:@"购书包邮" forState:UIControlStateHighlighted];
        
        [_buyBookBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
        [_buyBookBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateHighlighted];
        [_buyBookBtn.titleLabel setFont:HK_FONT_SYSTEM(10)];
        
        [_buyBookBtn hkLayoutButtonWithEdgeInsetsStyle:ICButtonEdgeInsetsStyleTop imageTitleSpace:3];
        [_buyBookBtn sizeToFit];
        [_buyBookBtn setHKEnlargeEdge:15];
        _buyBookBtn.hidden = YES;
        
        
        
//        CAKeyframeAnimation *shakeAnim = [CAKeyframeAnimation animation];
//        shakeAnim.keyPath = @"transform.translation.x";
//        shakeAnim.duration = 0.15;
//        CGFloat delta = 10;
//        shakeAnim.values = @[@0, @(-delta), @(delta), @0];
//        shakeAnim.repeatCount = 2;
//        [_buyBookBtn.layer addAnimation:shakeAnim forKey:nil];
    }
    return _buyBookBtn;
}


#pragma mark --- 抖动动画
//- (void)beginClick:(UIView *)sender {
//    //创建动画
//    CAKeyframeAnimation * keyAnimaion = [CAKeyframeAnimation animation];
//    keyAnimaion.keyPath = @"transform.rotation";
//    keyAnimaion.values = @[@(-10 / 180.0 * M_PI),@(10 /180.0 * M_PI),@(-10/ 180.0 * M_PI),@(0 /180.0 * M_PI)];//度数转弧度
//    keyAnimaion.removedOnCompletion = NO;
//    keyAnimaion.fillMode = kCAFillModeForwards;
//    keyAnimaion.duration = 0.3;
//    keyAnimaion.repeatCount = MAXFLOAT;//动画次数
//    [sender.layer addAnimation:keyAnimaion forKey:nil];
//}


#pragma mark 抖动
//- (void)shakeView:(UIView*)viewToShake{
//    CGFloat t =4.0;
//    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
//    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
//    viewToShake.transform = translateLeft;
//    [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
//        [UIView setAnimationRepeatCount:2.0];
//        viewToShake.transform = translateRight;
//    } completion:^(BOOL finished){
//        if(finished){
//            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//                viewToShake.transform =CGAffineTransformIdentity;
//            } completion:NULL];
//        }
//    }];
//}

- (void)beginClick:(UIView *)sender {
    [sender.layer removeAllAnimations];
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    shake.fromValue = [NSNumber numberWithFloat:+0.2];
    shake.toValue = [NSNumber numberWithFloat:-0.2];
    shake.duration = 0.15;//执行时间
    shake.autoreverses = NO; //是否重复
    shake.repeatCount = 2;//次数
    [sender.layer addAnimation:shake forKey:@"imageView"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self beginClick:self.buyBookBtn.imageView];
    });
}


- (UIButton *)preCourseBtn {
    if (!_preCourseBtn) {
        _preCourseBtn = [UIButton new];
        [_preCourseBtn addTarget:self action:@selector(prevBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *normalImage = [UIImage hkdam_lightOrDarkModeImageWithLightImage:imageName(@"ic_last_one") darkImage:imageName(@"ic_last_one_night")];
        UIImage *disableImage = [UIImage hkdam_lightOrDarkModeImageWithLightImage:imageName(@"ic_last_one_disable") darkImage:imageName(@"ic_last_one_disable_night")];
        
        [_preCourseBtn setImage:normalImage forState:UIControlStateNormal];
        [_preCourseBtn setImage:normalImage forState:UIControlStateHighlighted];
        [_preCourseBtn setImage:disableImage forState:UIControlStateDisabled];
        [_preCourseBtn setHKEnlargeEdge:10];
        _preCourseBtn.hidden = YES;
    }
    return _preCourseBtn;
}


- (UIButton *)nextCourseBtn {
    if (!_nextCourseBtn) {
        _nextCourseBtn = [UIButton new];
        [_nextCourseBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *normalImage = [UIImage hkdam_lightOrDarkModeImageWithLightImage:imageName(@"ic_next_one") darkImage:imageName(@"ic_next_one_night")];
        UIImage *disableImage = [UIImage hkdam_lightOrDarkModeImageWithLightImage:imageName(@"ic_next_one_disable") darkImage:imageName(@"ic_next_one_disable_night")];
        [_nextCourseBtn setImage:normalImage forState:UIControlStateNormal];
        [_nextCourseBtn setImage:normalImage forState:UIControlStateHighlighted];
        [_nextCourseBtn setImage:disableImage forState:UIControlStateDisabled];
        [_nextCourseBtn setHKEnlargeEdge:10];
        _nextCourseBtn.hidden = YES;
    }
    return _nextCourseBtn;
}




- (UIButton *)rateBtn {
    if (!_rateBtn) {
        _rateBtn = [UIButton new];
        [_rateBtn addTarget:self action:@selector(rateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *title = [self rateBtntitle];
        [_rateBtn setTitle:title forState:UIControlStateNormal];
        [_rateBtn setTitle:title forState:UIControlStateHighlighted];
        
        UIImage *image = [UIImage hkdm_imageWithNameLight:@"ic_speed_v2_19" darkImageName:@"ic_speed_v2_19_dark"];
        [_rateBtn setImage:image forState:UIControlStateNormal];
        [_rateBtn setImage:image forState:UIControlStateHighlighted];
        
        [_rateBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
        [_rateBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateHighlighted];
        [_rateBtn.titleLabel setFont:HK_FONT_SYSTEM(10)];
        [_rateBtn hkLayoutButtonWithEdgeInsetsStyle:ICButtonEdgeInsetsStyleTop imageTitleSpace:3];
        [_rateBtn setHKEnlargeEdge:15];
        [_rateBtn sizeToFit];
    }
    return _rateBtn;
}


- (NSString *)rateBtntitle {
    NSString *title = @"倍速";
    NSInteger index = [HKNSUserDefaults integerForKey:HKBookPlayRateIndex];
    switch (index) {
        case 0: case 2:
            title = @"倍速";
            break;
        break;
        
        case 1:
            title = @"0.75X";
        break;
        
        case 3:
            title = @"1.25X";
        break;
        
        case 4:
            title = @"1.5X";
        break;
        
        case 5:
            title = @"2.0X";
        break;
        
    default:
        break;
    }
    return title;
}


- (void)rateBtnClick:(UIButton*)btn {
    [MobClick event:um_hukedushu_detailpage_speed];
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlView:rateBtn:)]) {
        [self.delegate controlView:self rateBtn:btn];
    }
}




- (void)directoryBtnClick:(UIButton *)btn {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlView:didClickRirectory:)]) {
        [self.delegate controlView:self didClickRirectory:btn];
    }
}


- (void)detailBtnClick:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlView:didClickDesc:)]) {
        [self.delegate controlView:self didClickDesc:btn];
    }
}


- (void)timerBtnClick:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlView:didClickTimer:)]) {
        [self.delegate controlView:self didClickTimer:btn];
    }
}



- (void)buyBookBtnClick:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlView:bookBtn:)]) {
        [MobClick event:hukedushu_detailpage_book];
        [self.delegate controlView:self bookBtn:btn];
    }
}


- (void)setBookModel:(HKBookModel *)bookModel {
    _bookModel = bookModel;
    [self.coverIV sd_setImageWithURL:HKURL(bookModel.cover) placeholderImage:imageName(@"pic_placeholder_v2_14") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(controlView:coverIV:)]) {
            [self.delegate controlView:self coverIV:self.coverIV];
        }
    }];
    self.coverTagIV.hidden  = bookModel.is_free ? NO : YES;
    self.coverShadowIV.hidden = bookModel.is_free ? NO : YES;
    
    self.directoryBtn.hidden = bookModel.course_num ? NO :YES;
    self.timerBtn.hidden = self.directoryBtn.hidden;
    
    self.directoryLB.hidden = self.directoryBtn.hidden;
    self.timerLB.hidden = self.directoryBtn.hidden;
    
    NSString *title = bookModel.course_num ? [NSString stringWithFormat:@"共%ld节",bookModel.course_num] : @"共1节";
    _directoryLB.text = title;
    self.buyBookBtn.hidden = !bookModel.book_goods.is_show;
//    [self makeConstraints];
}



- (void)setRelateBookModel:(HKRelateBookModel *)relateBookModel {
    _relateBookModel = relateBookModel;
    
    self.nextCourseBtn.hidden = _bookModel.course_num ? NO :YES;
    self.preCourseBtn.hidden = self.nextCourseBtn.hidden;
    
    self.nextCourseBtn.enabled = (0 != [relateBookModel.next_book.book_id intValue]);
    self.preCourseBtn.enabled = (0 != [relateBookModel.last_book.book_id intValue]);
}


- (void)setPlayBtnImageWithPlayStatus:(GKPlayerStatus)status {
    
    if (self.isPlaying || (GKPlayerStatusPlaying == status)) {
         //(GKPlayerStatusBuffering == self.status) || (GKPlayerStatusPlaying == self.status)
        //加载 旋转
        [self.playBtn setImage:[UIImage imageNamed:@"ic_videostop_v2_14"] forState:UIControlStateNormal];
        [self.playBtn setImage:[UIImage imageNamed:@"ic_videostop_v2_14"] forState:UIControlStateHighlighted];
    }else{
      
        [self.playBtn setImage:[UIImage imageNamed:@"ic_videostart_v2_14"] forState:UIControlStateNormal];
        [self.playBtn setImage:[UIImage imageNamed:@"ic_videostart_v2_14"] forState:UIControlStateHighlighted];
    }
}




- (void)setStatus:(GKPlayerStatus)status {
    
    _status = status;
    switch (status) {
        case GKPlayerStatusBuffering:
        {
        }
            break;
        case GKPlayerStatusPlaying:
        {
            
        }
            break;
        case GKPlayerStatusPaused:
        {
            
        }
            break;
        case GKPlayerStatusStopped:
        {

        }
            break;
        case GKPlayerStatusEnded:
        {
            //播放结束了
        }
            break;
        case GKPlayerStatusError:
        {
        }
            break;
            
        default:
            break;
    }
    [self setPlayBtnImageWithPlayStatus:status];
}


- (void)updateTimerBtnTitleWithCurrentTime:(NSInteger)time {
    NSString *text = nil;
    if (0 == time) {
        text = @"定时";
    }else {
        text = [GKTool timeStrWithSecTime:time];
    }
    self.timerLB.text = text;
}



- (void)setCurrentLabelColorWithValueChange:(BOOL)isChange {
    UIColor *textColor = [UIColor hkdm_colorWithColorLight:COLOR_A8ABBE dark:COLOR_EFEFF6];
    self.currentLabel.textColor = isChange ? COLOR_27323F_EFEFF6 : textColor;
}




- (UIImage*)coverImage {
    return self.coverIV.image;
}



- (void)setIsPreparedToPlay:(BOOL)isPreparedToPlay {
    _isPreparedToPlay = isPreparedToPlay;
    self.slider.userInteractionEnabled = isPreparedToPlay;
}



@end
