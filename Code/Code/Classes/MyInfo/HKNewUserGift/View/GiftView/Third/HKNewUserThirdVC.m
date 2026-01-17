//
//  HKNewUserThirdVC.m
//  Code
//
//  Created by Ivan li on 2018/8/6.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKNewUserThirdVC.h"
#import "HKNewUserThirdView.h"
#import "HKHomeGiftModel.h"


@interface HKNewUserThirdVC ()

@property (nonatomic,strong) HKNewUserThirdView *thirdView;

@property (nonatomic,strong)HKHomeGiftModel *giftM;

@end

@implementation HKNewUserThirdVC

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
    [self.view addSubview:self.thirdView];
    
    [self.thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}




- (HKNewUserThirdView*)thirdView {
    if (!_thirdView) {
        _thirdView = [[HKNewUserThirdView alloc]init];
        WeakSelf;
        _thirdView.hkNewUserFirstViewBlock = ^(NSString *title) {
            //[weakSelf.view removeFromSuperview];
            //[weakSelf removeFromParentViewController];
            [weakSelf closeAction];
        };
        _thirdView.model = self.giftM;
    }
    return _thirdView;
}


- (void)dealloc {
    NSLog(@"HKNewUserThirdVC");
}


- (void)closeAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}



+ (void)presentHKNewUserThirdVC:(HKHomeGiftModel *)model {
        
    UIViewController *topVC = [CommonFunction topViewController];
    
    if ([NSStringFromClass([topVC class]) isEqualToString:NSStringFromClass([HKNewUserThirdVC class])]) {
        return;
    }else{
        HKNewUserThirdVC *VC = [[HKNewUserThirdVC alloc]initWithModel:model];
        UINavigationController *loginVC = [[UINavigationController alloc]initWithRootViewController:VC];
        loginVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        if (nil != topVC) {
            [topVC presentViewController:loginVC animated:YES completion:nil];
        }
    }
}




@end



