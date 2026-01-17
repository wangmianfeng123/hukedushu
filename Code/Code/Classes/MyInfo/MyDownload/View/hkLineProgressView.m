//
//  hkLineProgressView.m
//  Code
//
//  Created by Ivan li on 2020/1/7.
//  Copyright © 2020 pg. All rights reserved.
//

#import "hkLineProgressView.h"
#import "UIView+ZFHKNormalFrame.h"

static const CGFloat kProgressMargin = 0;
/** 进度的高度 */
static const CGFloat kProgressH = 2.0;



@interface hkLineProgressView ()

/** 进度背景 */
@property (nonatomic, strong) UIImageView *bgProgressView;
/** 滑动进度 */
@property (nonatomic, strong) UIImageView *sliderProgressView;

@property (nonatomic, assign) CGPoint lastPoint;

@end


@implementation hkLineProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addSubViews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 初始化frame
    self.bgProgressView.zf_width   = self.zf_width;
    //self.bgProgressView.zf_width   = self.zf_width - kProgressMargin * 2;
    
    self.bgProgressView.zf_centerY     = self.zf_height * 0.5;
    self.sliderProgressView.zf_centerY = self.zf_height * 0.5;
    
    /// 修复slider  bufferProgress错位问题
    self.sliderProgressView.zf_left = kProgressMargin;
    
    CGFloat progressValue  = self.bgProgressView.zf_width * self.value;
    self.sliderProgressView.zf_width = progressValue;
}

/**
 添加子视图
 */
- (void)addSubViews {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bgProgressView];
    [self addSubview:self.sliderProgressView];
    
    // 初始化frame
    self.bgProgressView.frame     = CGRectMake(kProgressMargin, 0, 0, kProgressH);
    self.sliderProgressView.frame = self.bgProgressView.frame;
}

#pragma mark - Setter

- (void)setMaximumTrackTintColor:(UIColor *)maximumTrackTintColor {
    _maximumTrackTintColor = maximumTrackTintColor;
    self.bgProgressView.backgroundColor = maximumTrackTintColor;
}

- (void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor {
    _minimumTrackTintColor = minimumTrackTintColor;
    self.sliderProgressView.backgroundColor = minimumTrackTintColor;
}


- (void)setMaximumTrackImage:(UIImage *)maximumTrackImage {
    _maximumTrackImage = maximumTrackImage;
    self.bgProgressView.image = maximumTrackImage;
    self.maximumTrackTintColor = [UIColor clearColor];
}

- (void)setMinimumTrackImage:(UIImage *)minimumTrackImage {
    _minimumTrackImage = minimumTrackImage;
    self.sliderProgressView.image = minimumTrackImage;
    self.minimumTrackTintColor = [UIColor clearColor];
}


- (void)setMaximumTrackBorderColor:(UIColor *)borderColor  backgroundColor:(UIColor *)backgroundColor {
    self.bgProgressView.layer.borderWidth = 0.5;
    self.bgProgressView.layer.borderColor = borderColor.CGColor;
    self.bgProgressView.layer.backgroundColor = backgroundColor.CGColor;
}



- (void)resetMaximumTrackBorderColor {
    self.bgProgressView.backgroundColor = _maximumTrackTintColor;
    self.bgProgressView.layer.borderWidth = 0.0;
}


- (void)setValue:(float)value {
    if (isnan(value)) return;
    value = MIN(1.0, value);
    _value = value;
    //self.sliderProgressView.zf_width = self.sliderBtn.zf_centerX;
    self.sliderProgressView.zf_width = self.bgProgressView.zf_width * value;
}


- (void)setSliderHeight:(CGFloat)sliderHeight {
    if (isnan(sliderHeight)) return;
    _sliderHeight = sliderHeight;
    self.bgProgressView.zf_height     = sliderHeight;
    self.sliderProgressView.zf_height = sliderHeight;
    [self testCornerRadius];
}


- (void)testCornerRadius {
    self.bgProgressView.layer.cornerRadius = _sliderHeight*0.5;
    self.sliderProgressView.layer.cornerRadius = _sliderHeight*0.5;
}


#pragma mark - getter

- (UIImageView *)bgProgressView {
    if (!_bgProgressView) {
        _bgProgressView = [UIImageView new];
        _bgProgressView.backgroundColor = [UIColor grayColor];
        _bgProgressView.contentMode = UIViewContentModeScaleAspectFill;
        _bgProgressView.clipsToBounds = YES;
    }
    return _bgProgressView;
}



- (UIImageView *)sliderProgressView {
    if (!_sliderProgressView) {
        _sliderProgressView = [UIImageView new];
        _sliderProgressView.backgroundColor = [UIColor redColor];
        _sliderProgressView.contentMode = UIViewContentModeScaleAspectFill;
        _sliderProgressView.clipsToBounds = YES;
    }
    return _sliderProgressView;
}


@end
