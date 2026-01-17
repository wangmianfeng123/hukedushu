
//
//  HKNewUserFirstVC.m
//  Code
//
//  Created by Ivan li on 2018/8/2.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKNewUserFirstVC.h"
#import "HKNewUserFirstView.h"
#import "HKHomeGiftModel.h"

@interface HKNewUserFirstVC ()

@property (nonatomic,strong) HKNewUserFirstView *userView;

@property (nonatomic,strong)HKHomeGiftModel *giftM;

@end

@implementation HKNewUserFirstVC

- (void)dealloc {
    NSLog(@"HKNewUserFirstVC");
}


- (instancetype)initWithModel:(HKHomeGiftModel *)model {
    if (self = [super init]) {
        self.giftM = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)createUI {
    self.view.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.3];
    [self.view addSubview:self.userView];
    
    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}



- (HKNewUserFirstView*)userView {
    if (!_userView) {
        _userView = [[HKNewUserFirstView alloc]init];
        WeakSelf;
        _userView.hkNewUserFirstViewBlock = ^(NSString *title) {
            //[weakSelf.view removeFromSuperview];
            //[weakSelf removeFromParentViewController];
            [weakSelf closeAction];
        };
        _userView.model = self.giftM;
    }
    return _userView;
}



- (void)closeAction {
    showCustomViewDialogWithText(Tomorrow_Can_Get_Gift, 3, 50);
    [self dismissViewControllerAnimated:YES completion:nil];
}



+ (void)presentHKNewUserFirstVC:(HKHomeGiftModel *)model {
    
    UIViewController *topVC = [CommonFunction topViewController];
    
    if ([NSStringFromClass([topVC class]) isEqualToString:NSStringFromClass([HKNewUserFirstVC class])]) {
        return;
    }else{
        HKNewUserFirstVC *VC = [[HKNewUserFirstVC alloc]initWithModel:model];
        UINavigationController *loginVC = [[UINavigationController alloc]initWithRootViewController:VC];
        loginVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        if (nil != topVC) {
            [topVC presentViewController:loginVC animated:YES completion:nil];
        }
    }
}


@end



