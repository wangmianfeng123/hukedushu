//
//  HKPayResultVC.m
//  Code
//
//  Created by hanchuangkeji on 2017/12/8.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKPayResultVC.h"
#import "VideoPlayVC.h"
#import "MyInfoViewController.h"
#import "HKCustomMarginLabel.h"
#import "BindPhoneVC.h"
#import "HKDownloadCourseVC.h"


@interface HKPayResultVC ()

@property (strong, nonatomic)  UIImageView *topIV;

@property (strong, nonatomic)  UILabel *topLB;

@property (strong, nonatomic)  UILabel *midLB;

@property (strong, nonatomic)  UIButton *bottomBtn;

@property (strong, nonatomic) HKCustomMarginLabel *tipLB;

@end



@implementation HKPayResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self setValue];
}

- (void)createUI {
    
    self.title = @"购买结果";
    [self createLeftBarButton];
    
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;//[UIColor whiteColor];
    [self.view addSubview:self.topIV];
    [self.view addSubview:self.tipLB];
    [self.view addSubview:self.topLB];
    [self.view addSubview:self.midLB];
    [self.view addSubview:self.bottomBtn];
    
    [self.tipLB mas_makeConstraints:^(MASConstraintMaker *make) {
        if(@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        }else{
            make.top.equalTo(self.view);
        }
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    [self.topIV mas_makeConstraints:^(MASConstraintMaker *make) {
        if(@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(50);
        }else{
            make.top.equalTo(self.view).offset(50);
        }
        make.centerX.equalTo(self.view);
    }];
    
    [self.midLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topLB.mas_top).offset(-8);
        make.centerX.equalTo(self.view);
    }];
    
    [self.topLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topIV.mas_bottom).offset(37);
        make.centerX.equalTo(self.view);
    }];
    
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLB.mas_bottom).offset(22);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(36);
    }];
}


- (void)backAction {
    if (self.success) {
        [self popViewController];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



- (void)setValue {
    if (self.success) {
        
        NSString *stringName = self.model.name.length? [NSString stringWithFormat:@"【%@】", self.model.name] : @"【虎课网VIP】";
        NSString *contentString = [NSString stringWithFormat:@"你已成功购买%@\n距离大神又近了一步哦~", stringName];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
        [attrString addAttribute:NSFontAttributeName value:HK_FONT_SYSTEM(16) range:NSMakeRange(0, contentString.length)];
        
        //[attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0 weight:UIFontWeightBold] range:range];
        //[attrString addAttribute:NSForegroundColorAttributeName value:HKColorFromHex(0x27323F, 1.0) range:NSMakeRange(0, contentString.length)];
        self.topLB.attributedText = attrString;
        self.midLB.text = @"支付成功";
        self.tipLB.hidden = self.model.isBindPhone;
    } else {
        // 支付不成功
        self.topIV.image = imageName(@"my_VIP_Pay_fail_result");
        self.topLB.text = @"支付失败";
        self.midLB.text = @"最后一步出了点问题，请重新支付哦~";
    }
    [self setBottomBtnTitleWithBindPhone:self.model.isBindPhone isSucess:self.success];
}





- (HKCustomMarginLabel*)tipLB {
    if (!_tipLB) {
        _tipLB  = [[HKCustomMarginLabel alloc] init];
        _tipLB.textInsets = UIEdgeInsetsMake(4, 15, 4, 0);
        _tipLB.textColor = [UIColor colorWithHexString:@"#FF7A6C"];
        _tipLB.font = HK_FONT_SYSTEM(13);
        _tipLB.textAlignment = NSTextAlignmentLeft;
        _tipLB.backgroundColor = [UIColor colorWithHexString:@"#FFEBE9"];
        _tipLB.text = @"小虎提示：为防止账号被盗，请立即绑定手机号。";
        _tipLB.hidden = YES;
    }
    return _tipLB;
}


- (UIImageView*)topIV {
    if (!_topIV) {
        _topIV = [UIImageView new];
        _topIV.image = imageName(@"ic_access_v2_7");
    }
    return _topIV;
}


- (UILabel*)topLB {
    if (!_topLB) {
        _topLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_7B8196_A8ABBE titleFont:nil titleAligment:NSTextAlignmentCenter];
        _topLB.font = HK_FONT_SYSTEM(16);
        _topLB.numberOfLines = 2;
    }
    return _topLB;
}



- (UILabel*)midLB {
    if (!_midLB) {
        _midLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F_EFEFF6 titleFont:nil titleAligment:NSTextAlignmentCenter];
        _midLB.font = HK_FONT_SYSTEM_WEIGHT(18, UIFontWeightSemibold);
    }
    return _midLB;
}


- (UIButton*)bottomBtn {
    if (!_bottomBtn) {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomBtn.clipsToBounds = YES;
        _bottomBtn.backgroundColor = [UIColor whiteColor];
        _bottomBtn.layer.cornerRadius = 18;
        _bottomBtn.layer.borderColor = COLOR_FF6868.CGColor;
        _bottomBtn.layer.borderWidth = 1.0;
        
        _bottomBtn.titleLabel.font = HK_FONT_SYSTEM(15);
        [_bottomBtn setTitle:@"立即学习" forState:UIControlStateNormal];
        [_bottomBtn setTitle:@"立即学习" forState:UIControlStateHighlighted];
        [_bottomBtn setTitleColor:COLOR_FF6868 forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:COLOR_FF6868 forState:UIControlStateHighlighted];
        [_bottomBtn setContentEdgeInsets:UIEdgeInsetsMake(7, 30, 7, 30)];
        [_bottomBtn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}



- (void)bottomBtnClick {
    
    if (self.success) {
        if (self.model.isBindPhone) {
            [self popViewController];
        }else{
            [self pushBindPhoneVC];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



- (void)popViewController {
    UINavigationController *navigationVC = self.navigationController;
    VideoPlayVC *videoPlayVC = nil;
    MyInfoViewController *myInfoViewController = nil;
    HKDownloadCourseVC * downloadVC = nil;
    BOOL haveDownVC = NO;
    for (UIViewController *viewControllView in navigationVC.viewControllers) {
        if ([viewControllView isKindOfClass:[HKDownloadCourseVC class]]) {
            haveDownVC = YES;
        }
    }
    
    for (UIViewController *viewControllView in navigationVC.viewControllers) {
        // 从视频详情页过来的
        if ([viewControllView isKindOfClass:[HKDownloadCourseVC class]]){
            downloadVC = (HKDownloadCourseVC *)viewControllView;
            break;
            
        }else if ([viewControllView isKindOfClass:[VideoPlayVC class]]) {
            videoPlayVC = (VideoPlayVC *)viewControllView;
            if (!haveDownVC) {
                break;
            }
        } else if ([viewControllView isKindOfClass:[MyInfoViewController class]]) {
            myInfoViewController = (MyInfoViewController *)viewControllView;
            break;
        }
    }
    // 退到视频详情页
    if (downloadVC) {
        [navigationVC popToViewController:downloadVC animated:YES];
    }else if (videoPlayVC) {
        [navigationVC popToViewController:videoPlayVC animated:YES];
    }else if (myInfoViewController) {// 退到个人主页
        [navigationVC popToViewController:myInfoViewController animated:YES];
    }else {
        [navigationVC popViewControllerAnimated:YES];
    }
}




- (void)pushBindPhoneVC {
    BindPhoneVC *VC = [BindPhoneVC new];
    VC.bindPhoneType = HKBindPhoneType_VipBuySucess_UserBind;
    [self pushToOtherController:VC];
}



- (void)setBottomBtnTitleWithBindPhone:(BOOL)isBindPhone  isSucess:(BOOL)isSucess {
    
    NSString *title = nil;
    if (isSucess) {
        title = isBindPhone ?@"立即学习" :@"绑定手机号";
    }else{
        title = @"重新支付";
    }
    [_bottomBtn setTitle:title forState:UIControlStateNormal];
    [_bottomBtn setTitle:title forState:UIControlStateHighlighted];
}


@end

