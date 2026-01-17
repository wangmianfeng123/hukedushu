//
//  HKNewUserFirstView.m
//  Code
//
//  Created by Ivan li on 2018/8/2.
//  Copyright © 2018年 pg. All rights reserved.
//
//

#import "HKNewUserFirstView.h"
#import "HKWaterWaveView.h"
#import "HKTagBtnTool.h"
#import "HKGiftWaterWaveView.h"
#import "HKNewUserCouponView.h"
#import "HKHomeGiftModel.h"




@interface HKNewUserFirstView()

@property (nonatomic,strong) LOTAnimationView *animation;

@end


@implementation HKNewUserFirstView



- (void)createUI {
    [super createUI];
    
    [self.waterBgView addSubview:self.couponBgView];
    [self.couponBgView addSubview:self.couponView];
    
    [self.couponBgView addSubview:self.giftTagIV];
    [self.couponBgView addSubview:self.giftTagLB];
    [self.couponBgView addSubview:self.tagLB];
    self.giftTagTitle = @"第一天恭喜获得";
    //self.bottomTagTitle = @"无限学习全站19大分类设计教程";
    
    [self addSubview:self.animation];
    
    [self.animation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.couponBgView.mas_top).offset(PADDING_20);
        make.centerX.equalTo(self.couponBgView);
        make.size.mas_equalTo(CGSizeMake(470/2, 470/2));
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    [super makeConstraints];
    
    [self.couponBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.waterBgView).offset(-30);
        make.left.equalTo(self.waterBgView).offset(30);
        make.height.mas_equalTo(377/2);
    }];
    
    [self.couponView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.couponBgView).offset(-86/2);
        make.left.equalTo(self.couponBgView).offset(72/2);
        make.right.equalTo(self.couponBgView).offset(-72/2);
        make.height.mas_equalTo(128/2);
    }];
    
    [self.tagLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.couponView.mas_bottom).offset(3);
        make.right.left.equalTo(self.couponBgView);
    }];
    
    [self.giftTagLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.couponView.mas_top).offset(-22);
        make.right.left.equalTo(self.couponBgView);
    }];
    
    [self.giftTagIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.giftTagLB.mas_top).offset(-3);
        make.centerX.equalTo(self.giftTagLB);
    }];
}



- (LOTAnimationView*)animation {
    if (!_animation) {
        _animation = [LOTAnimationView animationNamed:@"hkGift-first.json"];
        _animation.loopAnimation = YES;
        [_animation playWithCompletion:^(BOOL animationFinished) {
            
        }];
    }
    return _animation;
}


- (void)setModel:(HKHomeGiftModel *)model {
    _model = model;
    
    self.couponView.model = model;
    self.bottomTagTitle = model.first_day_gift.express_vip.desc;
}

@end





