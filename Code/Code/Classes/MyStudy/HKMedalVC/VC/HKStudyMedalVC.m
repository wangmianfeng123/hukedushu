//
//  HKMedalVC.m
//  Code
//
//  Created by Ivan li on 2018/12/6.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKStudyMedalVC.h"
#import "HKStudyMedalView.h"


@interface HKStudyMedalVC ()

@property(nonatomic,strong)HKStudyMedalView    *medalView;

@end


@implementation HKStudyMedalVC



- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createUI {
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.medalView];
    
    [self.medalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.height.mas_equalTo(780/2);
        make.width.mas_equalTo(580/2);
    }];
}


- (HKStudyMedalView*)medalView {
    if (!_medalView) {
        WeakSelf;
        _medalView = [[HKStudyMedalView alloc]init];
        _medalView.studyMedalCloseBlock = ^(UIButton *sender) {
            [weakSelf closeBtnClick];
        };
        _medalView.studyMedalPushBlock = ^(UIButton *sender) {
            
        };
    }
    return  _medalView;
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







