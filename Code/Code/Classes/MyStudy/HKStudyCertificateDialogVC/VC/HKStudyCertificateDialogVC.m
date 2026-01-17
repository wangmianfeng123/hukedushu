//
//  HKStudyCertificateVC.m
//  Code
//
//  Created by Ivan li on 2018/12/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKStudyCertificateDialogVC.h"
#import "HKStudyCertificateView.h"
#import "UINavigationController+ZFNormalFullscreenPopGesture.h"


@interface HKStudyCertificateDialogVC ()

@property(nonatomic,strong)HKStudyCertificateView    *certificateView;

@end


@implementation HKStudyCertificateDialogVC



- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createUI {
    self.zf_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.certificateView];
    
    [self.certificateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.height.mas_equalTo(780/2);
        make.width.mas_equalTo(580/2);
    }];
}


- (HKStudyCertificateView*)certificateView {
    if (!_certificateView) {
        WeakSelf;
        _certificateView = [[HKStudyCertificateView alloc]init];
        _certificateView.studyMedalCloseBlock = ^(UIButton *sender) {
            [weakSelf closeBtnClick];
        };
        _certificateView.studyMedalPushBlock = ^(UIButton *sender) {
            [weakSelf closeBtnClick];
        };
    }
    return  _certificateView;
}


- (void)closeBtnClick {
    self.view.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.5 animations:^{
        self.view.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}


@end



