//
//  HKGiftBaseView.m
//  Code
//
//  Created by Ivan li on 2018/8/6.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKGiftBaseView.h"
#import "HKWaterWaveView.h"
#import "HKTagBtnTool.h"
#import "HKGiftWaterWaveView.h"
#import "HKNewUserCouponView.h"
#import "HKHomeGiftModel.h"


@implementation HKGiftBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }return self;
}


- (instancetype)init{
    if (self = [super init]) {
        [self createUI];
    }return self;
}



- (void)createUI {
    
    self.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.3];
    [self addSubview:self.waterBgView];
    [self addSubview:self.tagBtnTool];
    [self.waterBgView addSubview:self.waterView];
    
//    [self.waterBgView addSubview:self.couponBgView];
//    [self.couponBgView addSubview:self.couponView];
//
//    [self.couponBgView addSubview:self.giftTagIV];
//    [self.couponBgView addSubview:self.giftTagLB];
//    [self.couponBgView addSubview:self.tagLB];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    [self.waterBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(IS_IPHONE5S ?-PADDING_15 :-PADDING_25).priorityLow();
        make.left.equalTo(self).offset(IS_IPHONE5S ?PADDING_15 :PADDING_25).priorityLow();
        make.center.equalTo(self);
        make.width.mas_lessThanOrEqualTo(IS_IPHONE5S ? 325-30 :660/2).priorityHigh();
        make.height.mas_equalTo(680/2);
    }];
    
    [self.tagBtnTool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(100);
        make.top.equalTo(self.waterBgView.mas_bottom).offset(PADDING_20);
    }];

}



- (UIView*)waterBgView {
    if (!_waterBgView) {
        _waterBgView = [UIView new];
        _waterBgView.clipsToBounds = YES;
        _waterBgView.layer.cornerRadius = 50;
    }
    return _waterBgView;
}


- (HKGiftWaterWaveView*)waterView {
    if (!_waterView) {
        CGFloat W = SCREEN_WIDTH - (IS_IPHONE5S ?-PADDING_15 :-PADDING_25)*2;
        _waterView = [[HKGiftWaterWaveView alloc]initWithFrame:CGRectMake(0, 0, W,(680/2)) type:waveTypeSinf];
        
        _waterView.waveSpeed = 0.5;
        _waterView.waveAmplitude = 15;
        [_waterView waveWithColor:[UIColor grayColor]];
    }
    return _waterView;
}



- (HKTagBtnTool*)tagBtnTool {
    if (!_tagBtnTool) {
        _tagBtnTool = [[HKTagBtnTool alloc] init];
        WeakSelf;
        _tagBtnTool.tabBtnBlock = ^(NSString *title) {
            StrongSelf;
            strongSelf.hkNewUserFirstViewBlock ?strongSelf.hkNewUserFirstViewBlock(nil) :nil;
        };
    }
    return _tagBtnTool;
}



- (UIView*)couponBgView {
    if (!_couponBgView) {
        _couponBgView = [UIView new];
        _couponBgView.clipsToBounds = YES;
        _couponBgView.layer.cornerRadius = 5;
        _couponBgView.backgroundColor = [UIColor whiteColor];
    }
    return _couponBgView;
}


- (HKNewUserCouponView*)couponView {
    if (!_couponView) {
        _couponView = [[HKNewUserCouponView alloc]init];
    }
    return _couponView;
}



- (UILabel*)tagLB {
    if (!_tagLB) {
        _tagLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_7B8196 titleFont:@"10" titleAligment:NSTextAlignmentCenter];
    }
    return _tagLB;
}


- (UILabel*)giftTagLB {
    if (!_giftTagLB) {
        _giftTagLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_FF7D36 titleFont:@"13" titleAligment:NSTextAlignmentCenter];
    }
    return _giftTagLB;
}


- (UIImageView*)giftTagIV {
    if (!_giftTagIV) {
        _giftTagIV = [UIImageView new];
        _giftTagIV.image = imageName(@"txt_new_v2_3");
        _giftTagIV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _giftTagIV;
}


- (void)setBottomTagTitle:(NSString *)bottomTagTitle {
    _bottomTagTitle = bottomTagTitle;
    _tagLB.text = bottomTagTitle; 
}


- (void)setGiftTagTitle:(NSString *)giftTagTitle {
    _giftTagTitle = giftTagTitle;
    _giftTagLB.text = giftTagTitle;
}



- (void)dealloc {
    [self.waterView stop];
    NSLog(@"HKGiftBaseView");
}


@end







