//
//  HKVerticalHomeBtn.m
//

#import "HKVerticalHomeBtn.h"
#import "HKCustomMarginLabel.h"
#import "UIView+SNFoundation.h"

@implementation HKVerticalHomeBtn



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}


- (void)setup {
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.imageView addSubview:self.tagBgView];
    [self.tagBgView addSubview:self.tagLabel];
    
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self.tagBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.imageView).offset(6);
        if (IS_IPAD) {
            make.right.equalTo(self.imageView.mas_right);
        }else{
            make.centerX.equalTo(self.imageView).offset(13);
        }
        make.width.equalTo(self.tagLabel);
        make.height.equalTo(@13);
    }];
        
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(self.tagBgView);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 渐变背景
        NSArray *colorArr = @[(__bridge id)COLOR_FF4863.CGColor, (__bridge id)[COLOR_FF4863 colorWithAlphaComponent:0.9].CGColor, (__bridge id)[COLOR_FF4863 colorWithAlphaComponent:0.8].CGColor];
        [_tagBgView gradientShadowWithColor:colorArr];
    });
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (IS_IPAD) {
        self.imageView.size = CGSizeMake(self.width * 0.7, self.width * 0.5);
    }else{
        self.imageView.size = CGSizeMake(self.width, 40 * Ratio);
    }
    self.imageView.centerX = self.width * 0.5;
    self.imageView.y = 2;
    
    // 调整文字
    self.titleLabel.x = 0;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height -(IS_IPAD ? self.width * 0.5 : 40 *Ratio) - 4;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame) + 4;
}



- (HKCustomMarginLabel*)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[HKCustomMarginLabel alloc]initWithFrame:CGRectZero];
        UIColor *textColor = [UIColor hkdm_colorWithColorLight:COLOR_ffffff dark:COLOR_ffffff];
        _tagLabel.textColor = textColor;
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.font = HK_FONT_SYSTEM_WEIGHT(8, UIFontWeightMedium);
        _tagLabel.clipsToBounds = YES;
        _tagLabel.layer.cornerRadius = 6.5;
        _tagLabel.backgroundColor = [UIColor clearColor];
        _tagLabel.textInsets = UIEdgeInsetsMake(0, 4, 0, 4);
        _tagLabel.hidden = YES;
    }
    return _tagLabel;
}


- (UIView*)tagBgView {
    if (!_tagBgView) {
        _tagBgView = [UIView new];
        _tagBgView.hidden = YES;
        _tagBgView.clipsToBounds = YES;
        _tagBgView.layer.cornerRadius = 6.5;
        _tagBgView.layer.borderWidth = 0.35;
        _tagBgView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _tagBgView;
}


- (void)showTagWithTitle:(NSString*)title {
    
    BOOL bEmpty = isEmpty(title);
    _tagBgView.hidden = bEmpty;
    _tagLabel.text = bEmpty ?nil :title;
    _tagLabel.hidden = bEmpty;
}



- (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}


@end





