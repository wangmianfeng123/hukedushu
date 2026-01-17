//
//  HKHomeNewPointView.m
//  Code
//
//  Created by Ivan li on 2018/3/5.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKHomeNewPointView.h"
#import "AppDelegate.h"
#import "UIImage+Helper.h"

@interface HKHomeNewPointView()

/** 背景 */
@property(nonatomic,strong)UIImageView  *ic;
/** 关闭按钮 */
@property(nonatomic,strong)UIButton *closeBtn;

@end


@implementation HKHomeNewPointView


- (instancetype)init {
    if (self = [super init]) {
        
        [self createUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    
    self.frame = [UIApplication sharedApplication].keyWindow.bounds;
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    // [UIColor colorWithWhite:0.6 alpha:0.6];
    
    [self addSubview:self.ic];
    [self addSubview:self.closeBtn];
    
    [_ic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];

    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_ic.mas_bottom).offset(PADDING_20);
        make.size.mas_equalTo(CGSizeMake(_closeBtn.imageView.image.size.width, _closeBtn.imageView.image.size.height));
        make.centerX.equalTo(_ic);
    }];
}


- (UIImageView*)ic {
    if (!_ic) {
        _ic = [UIImageView new];
        _ic.image = imageName(@"home_new_point");
        _ic.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _ic;
}



- (UIButton*)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithTitle:nil titleColor:COLOR_333333 titleFont:@"15" imageName:@"delete_gray"];
        [_closeBtn setImage:imageName(@"delete_gray") forState:UIControlStateHighlighted];
        [_closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.tag = 12;
    }
    return _closeBtn;
}



- (void)closeBtnClick:(UIButton*)sender {
    
    [UIView animateWithDuration:1 animations:^{
        self.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self performSelector:@selector(removeGuidePage) withObject:nil afterDelay:0.5];
        });
    }];
}


- (void)removeGuidePage {
    [self removeFromSuperview];
}



@end








