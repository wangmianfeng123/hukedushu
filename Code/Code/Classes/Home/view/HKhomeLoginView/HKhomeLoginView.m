//
//  HKhomeLoginView.m
//  Code
//
//  Created by ivan on 2020/6/22.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKhomeLoginView.h"


#define  showHomeLoginKey   @"isShowHomeLogin"



@implementation HKhomeLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}


- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}


- (void)createUI {
    
    [self addSubview:self.bgView];
    [self addSubview:self.logoIV];
    [self addSubview:self.closeBtn];
    
    [self.bgView addSubview:self.descLB];
    [self.bgView addSubview:self.loginBtn];
    self.backgroundColor = [UIColor clearColor];
    // 成功登录
    HK_NOTIFICATION_ADD(HKLoginSuccessNotification, userloginSuccessNotification);
}


- (void)userloginSuccessNotification {
    [[self class]saveHomeLoginColseDate];
    [self removeFromSuperview];
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(-5);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.mas_top).offset(10);
        make.right.equalTo(self.bgView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.logoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView).offset(-10);
        make.left.equalTo(self.bgView);
        if (IS_IPHONE5S) {
            make.size.mas_equalTo(CGSizeZero);
        }
    }];
    
    [self.descLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        if (IS_IPHONE5S) {
            make.left.equalTo(self.bgView.mas_left).offset(10);
        }else{
            make.left.equalTo(self.logoIV.mas_right);
        }
        make.right.lessThanOrEqualTo(self.loginBtn.mas_left).offset(-5);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.right.equalTo(self.bgView).offset(- 12);
    }];
}


- (UIButton*)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *normalImage = [UIImage hkdm_imageWithNameLight:@"ic_close_float_v2_23" darkImageName:@"ic_close_float_v2_23"];
        [_closeBtn setImage:normalImage forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setHKEnlargeEdge:30];
    }
    return _closeBtn;
}


- (void)closeButtonAction:(UIButton*)btn {
    [[self class]saveHomeLoginColseDate];
    [self removeFromSuperview];
}




- (UIButton*)loginBtn {
    
    if (!_loginBtn) {
        
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.tag = 20;
        _loginBtn.clipsToBounds = YES;
        [_loginBtn.layer setCornerRadius:10];
        [_loginBtn.titleLabel setFont:HK_FONT_SYSTEM(12)];
        [_loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        UIColor *color = [UIColor colorWithHexString:@"#ff8c00"];
        UIColor *color1 = [UIColor colorWithHexString:@"#ffa000"];
        UIColor *color2 = [UIColor colorWithHexString:@"#ffb200"];
        UIImage *bgImage = [[UIImage alloc]createImageWithSize:CGSizeMake(60, 20) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
        
        [_loginBtn setBackgroundImage:bgImage forState:UIControlStateSelected];
        [_loginBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
                
        [_loginBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.size = CGSizeMake(60, 20);
        [_loginBtn sizeToFit];
    }
    return _loginBtn;
}



- (void)loginBtnAction:(UIButton*)sender {
    
    if (self.loginBtnActionBlock) {
        self.loginBtnActionBlock(sender);
    }
    [[self class]saveHomeLoginColseDate];
    [self removeFromSuperview];
}



- (UILabel*)descLB {
    if (!_descLB) {
        NSString *text = @"登录即享受365天每天一课免费学习";
        _descLB = [UILabel labelWithTitle:CGRectZero title:text titleColor:[UIColor whiteColor] titleFont:@"12" titleAligment:NSTextAlignmentLeft];
        [_descLB setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _descLB;
}


- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.55];
        _bgView.layer.cornerRadius = 5;
        _bgView.clipsToBounds = YES;
    }
    return _bgView;
}


- (UIImageView*)logoIV {
    if (!_logoIV) {
        _logoIV = [UIImageView new];
        _logoIV.image = imageName(@"img_gift_v2_23");
        _logoIV.size = CGSizeMake(50, 50);
    }
    return _logoIV;
}




/**
 是否 当天需要显示login view 
 
 @return
 */
+ (BOOL)isNeedShowHomeLoginOfDay {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *oldDateStr = [defaults objectForKey:showHomeLoginKey];
    [defaults synchronize];
    
    NSDateFormatter *dateformatter = [NSDateFormatter new];
    [dateformatter setTimeStyle:NSDateFormatterShortStyle];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    
    NSDate *oldDate = [dateformatter dateFromString:oldDateStr];
    
    if (nil == oldDate) {
        return YES;
    }
    NSInteger days = [DateChange numberOfDaysWithFromDate:oldDate toDate:[NSDate date]];
    return (days >0) ? YES : NO;
}



/// 保存 登录view 关闭时间
+ (void)saveHomeLoginColseDate {
    
    NSDateFormatter *dateformatter = [NSDateFormatter new];
    [dateformatter setTimeStyle:NSDateFormatterShortStyle];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *currentStr = [dateformatter stringFromDate:[NSDate date]];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:currentStr forKey:showHomeLoginKey];
    [defaults synchronize];
}



@end



