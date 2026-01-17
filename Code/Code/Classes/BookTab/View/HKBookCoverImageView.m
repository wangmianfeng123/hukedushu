//
//  HKBookCoverImageView.m
//  Code
//
//  Created by Ivan li on 2019/10/31.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBookCoverImageView.h"
#import "UIView+Banner.h"
#import "HKBookModel.h"



@interface HKBookCoverImageView()

@property (strong, nonatomic)  UILabel *freeLB;

@property (strong, nonatomic)  UIImageView *listenIV;
/// 推荐
@property (strong, nonatomic)  UILabel *recomLB;
/// 推荐背景
@property (strong, nonatomic)  UIImageView *recomBgIV;


@end



@implementation HKBookCoverImageView


- (instancetype)initWithImage:(nullable UIImage *)image {
    if (self = [super initWithImage:image]) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}


- (instancetype)init {
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}


- (void)setUp {
    [self addSubview:self.shadowIV];
    [self addSubview:self.recomBgIV];
    [self addSubview:self.recomLB];
    [self addSubview:self.listenIV];
    [self addSubview:self.freeLB];
    [self.recomBgIV addRoundedCornersWithRadius:5 byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
//    self.listenIV.hidden = YES;
    self.freeLB.hidden = YES;
}


- (void)makeConstraints {
    [self.recomBgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
    }];
    
    [self.recomLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.recomBgIV);
        make.centerY.equalTo(self.recomBgIV);
    }];
    
    [self.listenIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-4);
        make.bottom.equalTo(self).offset(-7);
    }];
    
    [self.freeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(4);
        make.centerY.equalTo(self.listenIV);
        make.size.mas_equalTo(CGSizeMake(25, 14));
    }];
    
    [self.shadowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
    }];
}



- (UIImageView*)listenIV {
    if (!_listenIV) {
        _listenIV = [UIImageView new];
        _listenIV.image = imageName(@"ic_video_v2_14");
    }
    return _listenIV;
}



- (UILabel*)freeLB {
    if (!_freeLB) {
        _freeLB = [UILabel labelWithTitle:CGRectZero title:@"免费" titleColor:COLOR_ffffff titleFont:nil titleAligment:NSTextAlignmentCenter];
        [_freeLB setFont:HK_FONT_SYSTEM_WEIGHT(9, UIFontWeightSemibold)];
        _freeLB.backgroundColor = [UIColor clearColor];
        // 圆角
        _freeLB.clipsToBounds = YES;
        _freeLB.layer.cornerRadius = 5.0;
        _freeLB.layer.borderColor = [UIColor whiteColor].CGColor;
        _freeLB.layer.borderWidth = 1.0;
        _freeLB.hidden = YES;
    }
    return _freeLB;
}



- (UIImageView*)recomBgIV {
    if (!_recomBgIV) {
        _recomBgIV = [UIImageView new];
        _recomBgIV.image = [self bgImage];
        [_recomBgIV sizeToFit];
        _recomBgIV.hidden = YES;
    }
    return _recomBgIV;
}



- (UIImage*)bgImage {
    // 主编推荐
    UIColor *color = [UIColor colorWithHexString:@"#FF6363"];
    UIColor *color1 = [UIColor colorWithHexString:@"#ed6f65"];
    UIColor *color2 = [UIColor colorWithHexString:@"#f19742"];
    UIImage *image = [[UIImage alloc]createImageWithSize:CGSizeMake(50, 17) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
    return image;
}


- (UILabel*)recomLB {
    if (!_recomLB) {
        _recomLB = [UILabel labelWithTitle:CGRectZero title:@"主编推荐" titleColor:COLOR_ffffff titleFont:@"11" titleAligment:NSTextAlignmentCenter];
        _recomLB.font = HK_FONT_SYSTEM_WEIGHT(10, UIFontWeightSemibold);
        [_recomLB sizeToFit];
    }
    return _recomLB;
}



- (UIImageView*)shadowIV {
    if (!_shadowIV) {
        _shadowIV = [UIImageView new];
        _shadowIV.image = imageName(@"hk_book_shadow_black");
        _shadowIV.clipsToBounds = YES;
        _shadowIV.layer.cornerRadius = 5.0;
    }
    return _shadowIV;
}



- (void)setModel:(HKBookModel *)model {
    
    _model = model;
    
    [self sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.cover]] placeholderImage:imageName(HK_Placeholder)];
    
    self.freeLB.hidden = !model.is_free;
        
    self.recomLB.hidden = !model.is_recommend;
    
    self.recomBgIV.hidden = !model.is_recommend;
}





@end
