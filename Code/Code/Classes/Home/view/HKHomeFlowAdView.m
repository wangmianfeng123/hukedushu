//
//  HKHomeFlowAdView.m
//  Code
//
//  Created by hanchuangkeji on 2018/9/14.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKHomeFlowAdView.h"

@interface HKHomeFlowAdView()


@end

@implementation HKHomeFlowAdView

static HKHomeFlowAdView *_adView;

+ (HKHomeFlowAdView *)addADViewToView:(UIView *)superView {
    if (_adView == nil) {
        HKHomeFlowAdView *adView = [[HKHomeFlowAdView alloc] init];
//        adView.backgroundColor = [UIColor orangeColor];
        CGFloat width = IS_IPHONEMORE4_7INCH? 48 : 44;
        adView.frame = CGRectMake(UIScreenWidth - 15 - width, SCREEN_HEIGHT - 272 * 0.5 - width, width, width);
//        [[UIApplication sharedApplication].keyWindow addSubview:adView];11
        [superView insertSubview:adView atIndex:999];
        _adView = adView;
        _adView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:adView action:@selector(tagGesture)];
        [_adView addGestureRecognizer:tap];
    }
    _adView.hidden = NO;
    return _adView;
}

- (void)setModel:(HKMapModel *)model {
    _model = model;
    [_adView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.img_url]] placeholderImage:imageName(HK_Placeholder)];
}

+ (void)hideADView {
    if (_adView) {
        _adView.hidden = YES;
    }
}

+ (void)showADView {
    if (_adView) {
        _adView.hidden = NO;
    }
}

- (void)tagGesture {
    
    !self.adFlowBlock? : self.adFlowBlock(self.model);
    [MobClick event:UM_RECORD_AD_SUSPENSION];
}


@end
