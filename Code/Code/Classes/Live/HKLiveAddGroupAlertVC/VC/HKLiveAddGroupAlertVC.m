//
//  HKLiveAddGroupAlertVC.m
//  Code
//
//  Created by Ivan li on 2018/12/10.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKLiveAddGroupAlertVC.h"
#import "HKLiveAddGroupView.h"


@interface HKLiveAddGroupAlertVC ()

@property(nonatomic,strong)HKLiveAddGroupView    *addGroupView;

@end


@implementation HKLiveAddGroupAlertVC


- (void)dealloc {
    NSLog(@"HKLiveAddGroupAlertVC");
}


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
    [self.view addSubview:self.addGroupView];
    
    [self.addGroupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.height.mas_equalTo(300);
        make.width.mas_equalTo(580/2);
    }];
}


- (HKLiveAddGroupView*)addGroupView {
    if (!_addGroupView) {
        WeakSelf;
        _addGroupView = [[HKLiveAddGroupView alloc]init];
        _addGroupView.studyMedalCloseBlock = ^(UIButton *sender) {
            [weakSelf closeView];
        };
        
        _addGroupView.studyMedalPushBlock = ^(UIButton *sender) {
            weakSelf.liveAddGroupAlertVCBlock ?weakSelf.liveAddGroupAlertVCBlock(weakSelf) :nil;
        };
    }
    return  _addGroupView;
}


- (void)closeView {
    self.view.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.5 animations:^{
        self.view.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}


@end







