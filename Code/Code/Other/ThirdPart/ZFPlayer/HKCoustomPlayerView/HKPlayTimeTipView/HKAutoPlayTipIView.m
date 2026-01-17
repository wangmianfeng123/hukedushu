

//
//  HKAutoPlayTipIView.m
//  Code
//
//  Created by Ivan li on 2018/9/10.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKAutoPlayTipIView.h"


@implementation HKAutoPlayTipIView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}


- (void)setUp {
    [HKNSUserDefaults setBool:YES forKey:@"HKAutoPlayTipIView"];
    [HKNSUserDefaults synchronize];
    
    self.image = imageName(@"hkplayer_autoPlay_tip");
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick)];
    [self addGestureRecognizer:tap];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (NSEC_PER_SEC * 5)), dispatch_get_main_queue(), ^{
        [self removeView];
        if (self.delegate && [self.delegate respondsToSelector:@selector(removeAutoPlayTipIView:)]) {
            [self.delegate removeAutoPlayTipIView:self];
        }
    });
}


- (void)removeView {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
}

- (void)imageClick {
    [self removeView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(removeAutoPlayTipIView:)]) {
        [self.delegate removeAutoPlayTipIView:self];
    }
}


- (void)dealloc {
    [self removeView];
}


@end
