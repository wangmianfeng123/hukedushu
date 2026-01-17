
//
//  HKVerificationPhoneView.m
//  Code
//
//  Created by Ivan li on 2018/7/22.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKVerificationPhoneView.h"
#import "VerificationCodeButton.h"
#import<QuartzCore/QuartzCore.h>
#import "HKTextField.h"
#import "HKCustomMarginLabel.h"


#define btnBgColor   COLOR_EFEFF6;

#define  loginBtnBgColor   COLOR_FFD305;

@interface HKVerificationPhoneView ()<VerificationCodeButtonDelegate>

@end




@implementation HKVerificationPhoneView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)createUI {
    
    [self addSubview:self.warnLabel];
    [self addSubview:self.phoneLB];
    
    [self addSubview:self.authCodeLine];
    [self.authCodeLine addSubview:self.authCodeTextField];
    
    [self addSubview:self.loginBtn];
    [self addSubview:self.getAuthCodeBtn];
}


- (void)hkDarkModel {
    
}



- (void)makeConstraints {
    
    [self.warnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(PADDING_15);
        make.right.equalTo(self).offset(-PADDING_15);
        make.top.equalTo(self).offset(8);
    }];
    
    [self.phoneLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self);
        make.top.equalTo(self.warnLabel.mas_bottom).offset(154/2);
    }];
    
    [_authCodeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneLB.mas_bottom).offset(110/2);
        make.left.equalTo(self).offset(PADDING_25);
        make.width.mas_equalTo((SCREEN_WIDTH - 50)* (IS_IPHONE5S ?0.6 :0.55));
        make.height.mas_equalTo(kHeight44);
    }];
    
    [_authCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.authCodeLine.mas_centerY);
        make.left.equalTo(self.authCodeLine).offset(PADDING_20);
        make.right.equalTo(self.authCodeLine).offset(-PADDING_5);
        make.height.mas_equalTo(PADDING_30);
    }];
    
    
    [_getAuthCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.authCodeLine.mas_centerY);
        make.height.equalTo(self.authCodeLine);
        make.right.equalTo(self).offset(-PADDING_25);
        make.left.equalTo(self.authCodeLine.mas_right).offset(PADDING_15);
    }];
    
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.authCodeLine.mas_bottom).offset(PADDING_30);
        make.right.equalTo(self).offset(-PADDING_25);
        make.left.equalTo(self).offset(PADDING_25);
        make.height.mas_equalTo(kHeight44);
    }];
}



- (UIView*)authCodeLine {
    
    if (!_authCodeLine) {
        _authCodeLine = [[UIView alloc] init];
        _authCodeLine.backgroundColor = COLOR_F8F9FA_333D48;
        _authCodeLine.layer.cornerRadius = 7.5f;
    }
    return _authCodeLine;
}



- (HKTextField*)authCodeTextField {
    
    if (!_authCodeTextField) {
        
        _isAuthCodeEmpty = YES;
        _authCodeTextField = [[HKTextField alloc]init];
        _authCodeTextField.delegate = self;
        [_authCodeTextField setBackgroundColor:COLOR_F8F9FA_333D48];
        //_authCodeTextField.placeholder = K_str_inputAuthCode;
        _authCodeTextField.font = HK_FONT_SYSTEM(14);
        _authCodeTextField.keyboardType = UIKeyboardTypeDefault;
        
        _authCodeTextField.leftView = [[UIImageView alloc]initWithImage:imageName(@"lock_gray")];
        _authCodeTextField.leftViewMode = UITextFieldViewModeAlways;
        [_authCodeTextField sizeToFit];
        //设置监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authCodeTextFieldDidChange) name:UITextFieldTextDidChangeNotification object:_authCodeTextField];
        
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:K_str_inputAuthCode attributes:@{NSForegroundColorAttributeName : COLOR_A8ABBE_7B8196,NSFontAttributeName :HK_FONT_SYSTEM(14)}];
        _authCodeTextField.attributedPlaceholder = placeholderString;
    }
    return _authCodeTextField;
}




- (VerificationCodeButton*)getAuthCodeBtn {
    
    if (!_getAuthCodeBtn) {
        _getAuthCodeBtn = [[VerificationCodeButton alloc]initWithFrame:CGRectZero];
        [_getAuthCodeBtn setEnabled:YES];
        _getAuthCodeBtn.delegate = self;
        [_getAuthCodeBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
        [_getAuthCodeBtn setTag:22];
    }
    return _getAuthCodeBtn;
}





- (UIButton*)loginBtn {
    
    if (!_loginBtn) {
        _loginBtn = [UIButton new];
        [_loginBtn setEnabled:NO];
        _loginBtn.tag = 20;
        _loginBtn.clipsToBounds = YES;
        [_loginBtn.layer setCornerRadius:7.5];
        [_loginBtn setTitle:@"进入虎课" forState:UIControlStateNormal];
        [_loginBtn setTitle:@"进入虎课" forState:UIControlStateHighlighted];
        
        [_loginBtn setTitleColor:COLOR_27323F forState:UIControlStateNormal];
        [_loginBtn setTitleColor:COLOR_7B8196 forState:UIControlStateDisabled];
        
        [_loginBtn setBackgroundImage:imageName(@"login_code_bg") forState:UIControlStateNormal];
        UIImage *backgroundImage = [UIImage hkdm_imageWithNameLight:@"login_code_bg_enable" darkImageName:@"login_code_bg_enable_dark"];
        [_loginBtn setBackgroundImage:backgroundImage forState:UIControlStateDisabled];
        [_loginBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}


- (HKCustomMarginLabel *)warnLabel {
    
    if (!_warnLabel) {
        _warnLabel  = [[HKCustomMarginLabel alloc] init];
        [_warnLabel setTextColor:[UIColor colorWithHexString:@"#FF7A6C"]];
        _warnLabel.clipsToBounds = YES;
        _warnLabel.layer.cornerRadius = 5.0;
        
        _warnLabel.backgroundColor = [UIColor colorWithHexString:@"#FFEBE9"];
        _warnLabel.numberOfLines = 0;
        _warnLabel.font = HK_FONT_SYSTEM(13);
    }
    return _warnLabel;
}



- (UILabel*)phoneLB {
    if (!_phoneLB) {
        _phoneLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F titleFont:nil titleAligment:NSTextAlignmentCenter];
        _phoneLB.font = HK_FONT_SYSTEM_WEIGHT(20, UIFontWeightSemibold);
    }
    return _phoneLB;
}




- (void)registerAction:(UIButton*)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(verificationPhone:sender:)]) {
        [self.delegate verificationPhone:self sender:sender];
    }
}



#pragma mark UITextField 代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.authCodeTextField resignFirstResponder];
    return YES;
}




- (void)authCodeTextFieldDidChange {
    
    if (self.authCodeTextField.text.length > 0) {
        self.isAuthCodeEmpty = NO;
        [self.loginBtn setEnabled:YES];
    }else{
        self.isAuthCodeEmpty = YES;
        [self.loginBtn setEnabled:NO];
    }
}


- (void)setWarnWithText:(NSString*)text phone:(NSString*)phone {
    if (!isEmpty(text)) {
        _warnLabel.textInsets = UIEdgeInsetsMake(10, 15, 10, 10);
        _warnLabel.text = text;
    }
    _phoneLB.text = [CommonFunction phoneNumToAsterisk:phone];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.authCodeTextField];
}


@end












//
////
////  HKVerificationPhoneView.m
////  Code
////
////  Created by Ivan li on 2018/7/22.
////  Copyright © 2018年 pg. All rights reserved.
////
//
//#import "HKVerificationPhoneView.h"
//#import "VerificationCodeButton.h"
//#import "NSMutableAttributedString+HKAttributed.h"
//#import<QuartzCore/QuartzCore.h>
//#import "HKTextField.h"
//#import "HKCustomMarginLabel.h"
//
//
//#define btnBgColor   COLOR_EFEFF6;
//
//#define  loginBtnBgColor   COLOR_FFD305;
//
//@interface HKVerificationPhoneView ()<VerificationCodeButtonDelegate>
//
//@end
//
//
//
//
//@implementation HKVerificationPhoneView
//
//
//- (id)initWithFrame:(CGRect)frame {
//
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self createUI];
//    }return self;
//}
//
//- (void)layoutSubviews {
//
//    [super layoutSubviews];
//    [self makeConstraints];
//}
//
//
//- (void)createUI {
//
//    [self addSubview:self.warnLabel];
//    [self addSubview:self.phoneLB];
//
//    [self addSubview:self.authCodeLine];
//    [self.authCodeLine addSubview:self.authCodeTextField];
//
//    [self addSubview:self.loginBtn];
//    [self addSubview:self.getAuthCodeBtn];
//}
//
//
//
//
//- (void)makeConstraints {
//
//    [self.warnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(PADDING_15);
//        make.right.equalTo(self).offset(-PADDING_15);
//        make.top.equalTo(self).offset(8);
//    }];
//
//    [self.phoneLB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.left.equalTo(self);
//        make.top.equalTo(self.warnLabel.mas_bottom).offset(154/2);
//    }];
//
//    [_authCodeLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.phoneLB.mas_bottom).offset(110/2);
//        make.left.equalTo(self).offset(PADDING_25);
//        make.width.mas_equalTo((SCREEN_WIDTH - 50)* (IS_IPHONE5S ?0.6 :0.55));
//        make.height.mas_equalTo(kHeight44);
//    }];
//
//    [_authCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.centerY.equalTo(self.authCodeLine.mas_centerY);
//        make.left.equalTo(self.authCodeLine).offset(PADDING_20);
//        make.right.equalTo(self.authCodeLine).offset(-PADDING_5);
//        make.height.mas_equalTo(PADDING_30);
//    }];
//
//
//    [_getAuthCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.authCodeLine.mas_centerY);
//        make.height.equalTo(self.authCodeLine);
//        make.right.equalTo(self).offset(-PADDING_25);
//        make.left.equalTo(self.authCodeLine.mas_right).offset(PADDING_15);
//    }];
//
//
//    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.authCodeLine.mas_bottom).offset(PADDING_30);
//        make.right.equalTo(self).offset(-PADDING_25);
//        make.left.equalTo(self).offset(PADDING_25);
//        make.height.mas_equalTo(kHeight44);
//    }];
//}
//
//
//
//- (UIView*)authCodeLine {
//
//    if (!_authCodeLine) {
//        _authCodeLine = [[UIView alloc] init];
//        _authCodeLine.backgroundColor = COLOR_f3f7fa;
//        _authCodeLine.layer.cornerRadius = 7.5f;
//    }
//    return _authCodeLine;
//}
//
//
//
//- (HKTextField*)authCodeTextField {
//
//    if (!_authCodeTextField) {
//
//        _isAuthCodeEmpty = YES;
//        _authCodeTextField = [[HKTextField alloc]init];
//        _authCodeTextField.delegate = self;
//        [_authCodeTextField setBackgroundColor:COLOR_f3f7fa];
//        _authCodeTextField.placeholder = K_str_inputAuthCode;
//        _authCodeTextField.font = HK_FONT_SYSTEM(14);
//        _authCodeTextField.keyboardType = UIKeyboardTypeDefault;
//
//        _authCodeTextField.leftView = [[UIImageView alloc]initWithImage:imageName(@"lock_gray")];
//        _authCodeTextField.leftViewMode = UITextFieldViewModeAlways;
//        [_authCodeTextField sizeToFit];
//        //设置监听
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authCodeTextFieldDidChange) name:UITextFieldTextDidChangeNotification object:_authCodeTextField];
//    }
//    return _authCodeTextField;
//}
//
//
//
//
//- (VerificationCodeButton*)getAuthCodeBtn {
//
//    if (!_getAuthCodeBtn) {
//        _getAuthCodeBtn = [[VerificationCodeButton alloc]initWithFrame:CGRectZero];
//        _getAuthCodeBtn.backgroundColor = COLOR_FFD305;
//        [_getAuthCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
//        [_getAuthCodeBtn setTitleColor:COLOR_A8ABBE forState:UIControlStateNormal];
//        _getAuthCodeBtn.delegate = self;
//        [_getAuthCodeBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_getAuthCodeBtn setTag:22];
//    }
//    return _getAuthCodeBtn;
//}
//
//
//
//
//
//- (UIButton*)loginBtn {
//
//    if (!_loginBtn) {
//        _loginBtn = [UIButton new];
//        [_loginBtn setEnabled:NO];
//        _loginBtn.tag = 20;
//        [_loginBtn.layer setCornerRadius:7.5];
//        [_loginBtn setTitle:@"进入虎课" forState:UIControlStateNormal];
//        [_loginBtn setTitle:@"进入虎课" forState:UIControlStateHighlighted];
//        _loginBtn.backgroundColor = COLOR_EFEFF6;
//        [_loginBtn setTitleColor:COLOR_7B8196 forState:UIControlStateNormal];
//        [_loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//        [_loginBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _loginBtn;
//}
//
//
//- (HKCustomMarginLabel *)warnLabel {
//
//    if (!_warnLabel) {
//        _warnLabel  = [[HKCustomMarginLabel alloc] init];
//        [_warnLabel setTextColor:[UIColor colorWithHexString:@"#FF7A6C"]];
//        _warnLabel.clipsToBounds = YES;
//        _warnLabel.layer.cornerRadius = 5.0;
//
//        _warnLabel.backgroundColor = [UIColor colorWithHexString:@"#FFEBE9"];
//        _warnLabel.numberOfLines = 0;
//        _warnLabel.font = HK_FONT_SYSTEM(13);
//    }
//    return _warnLabel;
//}
//
//
//
//- (UILabel*)phoneLB {
//    if (!_phoneLB) {
//        _phoneLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F titleFont:nil titleAligment:NSTextAlignmentCenter];
//        _phoneLB.font = HK_FONT_SYSTEM_WEIGHT(20, UIFontWeightSemibold);
//    }
//    return _phoneLB;
//}
//
//
//
//
//- (void)registerAction:(UIButton*)sender {
//
//    if (self.delegate && [self.delegate respondsToSelector:@selector(verificationPhone:sender:)]) {
//        [self.delegate verificationPhone:self sender:sender];
//    }
//}
//
//
//
//#pragma mark  VerificationCodeButton 代理
//- (void)timerEnd:(id)sender {
//    self.getAuthCodeBtn.backgroundColor = COLOR_FFD305;
//}
//
//
//
//#pragma mark UITextField 代理
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//
//    [self.authCodeTextField resignFirstResponder];
//    return YES;
//}
//
//
//
////
////- (void)phoneTextFieldDidChange {
////
////    if (self.phoneTextField.text.length > 0) {
////        self.isPhoneEmpty = NO;
////        if (self.isAuthCodeEmpty == NO) {
////            [self.loginBtn setEnabled:YES];
////            self.loginBtn.backgroundColor = loginBtnBgColor;
////        }
////        if (NO == self.getAuthCodeBtn.isTiming) {
////            self.getAuthCodeBtn.backgroundColor = COLOR_FFD305;
////        }
////
////    }else{
////        [self.loginBtn setEnabled:NO];
////        self.isPhoneEmpty = YES;
////        self.loginBtn.backgroundColor = btnBgColor;
////        self.getAuthCodeBtn.backgroundColor = COLOR_EFEFF6;
////    }
////}
//
//
//
//
//- (void)authCodeTextFieldDidChange {
//
//    if (self.authCodeTextField.text.length > 0) {
//        self.isAuthCodeEmpty = NO;
//        [self.loginBtn setEnabled:YES];
//        self.loginBtn.backgroundColor = loginBtnBgColor;
//    }else{
//        self.isAuthCodeEmpty = YES;
//        self.loginBtn.backgroundColor = btnBgColor;
//        [self.loginBtn setEnabled:NO];
//    }
//}
//
//
//- (void)setWarnWithText:(NSString*)text phone:(NSString*)phone {
//    if (!isEmpty(text)) {
//        _warnLabel.textInsets = UIEdgeInsetsMake(10, 15, 10, 10);
//        _warnLabel.text = text;
//    }
//    _phoneLB.text = [CommonFunction phoneNumToAsterisk:phone];
//}
//
//
//
//
//- (void)dealloc {
//
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.authCodeTextField];
//}
//
//
//@end
//
