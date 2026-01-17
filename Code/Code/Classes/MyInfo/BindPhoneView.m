//
//  BindPhoneView.m
//  Code
//
//  Created by Ivan li on 2017/9/1.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "BindPhoneView.h"
#import "VerificationCodeButton.h"
#import<QuartzCore/QuartzCore.h>
#import "HKTextField.h"
#import "HKCustomMarginLabel.h"


#define btnBgColor COLOR_EFEFF6;

#define  registerBtnBgColor   [UIColor colorWithHexString:@"#FFD305"];



@implementation BindPhoneView


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
    [self addSubview:self.phoneLine];
    [self addSubview:self.authCodeLine];
    [self.phoneLine addSubview:self.phoneTextField];
    [self.authCodeLine addSubview:self.authCodeTextField];
    
    [self addSubview:self.registerBtn];
    [self addSubview:self.getAuthCodeBtn];
}


- (void)setBindPhoneType:(HKBindPhoneType)bindPhoneType {
    _bindPhoneType = bindPhoneType;
    if (HKBindPhoneType_Limit == bindPhoneType) {
        [self setWarnWithText:nil];
    }
    
    if (HKBindPhoneType_Ordinary == bindPhoneType || HKBindPhoneType_VipUserBind == bindPhoneType || HKBindPhoneType_VipBuySucess_UserBind== bindPhoneType) {
        self.getAuthCodeBtn.normalTitle = @"获取验证码";
    }
}


/** 设置警告提示 */
- (void)setWarnWithText:(NSString*)text {
    
    _warnLabel.textInsets = UIEdgeInsetsMake(10, 15, 10, 10);
    _warnLabel.text = @"小虎提示：登录太频繁可能会导致封号哦~请验证绑定手机，才能登录成功~";
}


- (void)makeConstraints {
    
    [self.warnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(PADDING_15);
        make.right.equalTo(self).offset(-PADDING_15);
        make.top.equalTo(self).offset(8);
    }];
    
    [_phoneLine mas_makeConstraints:^(MASConstraintMaker *make) {
        if (isEmpty(self.warnLabel.text)) {
            make.top.equalTo(self).offset(32);
        }else{
            make.top.lessThanOrEqualTo(self.warnLabel.mas_bottom).offset(32);
        }
        make.left.equalTo(self).offset(PADDING_25);
        make.right.equalTo(self).offset(-PADDING_25);
        make.height.mas_equalTo(kHeight44);
    }];
    
    [_authCodeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneLine);
        make.width.equalTo(self.phoneLine.mas_width).multipliedBy(IS_IPHONE5S ?0.6 :0.55);
        make.height.mas_equalTo(kHeight44);
        make.top.equalTo(self.phoneLine.mas_bottom).offset(PADDING_15);
    }];
    
    
    [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(weakSelf.phoneLine.mas_top).offset(PADDING_5);
        make.centerY.equalTo(self.phoneLine.mas_centerY);
        make.left.equalTo(self.phoneLine.mas_left).offset(PADDING_20);
        make.right.equalTo(self.phoneLine.mas_right).offset(-PADDING_5);
        make.height.mas_equalTo(PADDING_30);
    }];
    
    [_authCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.authCodeLine.mas_centerY);
        //make.top.equalTo(weakSelf.authCodeLine.mas_top).offset(PADDING_5);
        make.left.equalTo(self.authCodeLine).offset(PADDING_20);
        make.right.equalTo(self.authCodeLine).offset(-PADDING_5);
        make.height.mas_equalTo(PADDING_30);
    }];
    
    
    [_getAuthCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.authCodeLine.mas_centerY);
        make.right.height.equalTo(self.phoneLine);
        make.left.equalTo(self.authCodeLine.mas_right).offset(PADDING_15);
        //make.size.mas_equalTo(CGSizeMake(PADDING_20*4, PADDING_35));
    }];
    
    
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.authCodeLine.mas_bottom).offset(PADDING_30);
        make.right.left.equalTo(self.phoneLine);
        make.height.mas_equalTo(kHeight44);
    }];

}



- (UIView*)phoneLine {
    
    if (!_phoneLine) {
        _phoneLine = [[UIView alloc] init];
        _phoneLine.backgroundColor = COLOR_F8F9FA_333D48;
        _phoneLine.layer.cornerRadius = 22.f;
    }
    return _phoneLine;
}




- (UIView*)authCodeLine {
    
    if (!_authCodeLine) {
        _authCodeLine = [[UIView alloc] init];
        _authCodeLine.backgroundColor = COLOR_F8F9FA_333D48;
        _authCodeLine.layer.cornerRadius = 22.f;
    }
    return _authCodeLine;
}


- (HKTextField*)phoneTextField {
    
    if (!_phoneTextField) {
        
        _isPhoneEmpty = YES;
        _phoneTextField = [[HKTextField alloc]init];
        _phoneTextField.delegate = self;
        [_phoneTextField setBackgroundColor:COLOR_F8F9FA];
        //_phoneTextField.placeholder = K_str_inputPhoneNum;
        _phoneTextField.font = HK_FONT_SYSTEM(14);
        _phoneTextField.keyboardType = UIKeyboardTypePhonePad;
        
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextField.leftView = [[UIImageView alloc]initWithImage:imageName(@"phone_gray")];
        _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
        [_phoneTextField sizeToFit];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneTextFieldDidChange) name:UITextFieldTextDidChangeNotification object:_phoneTextField];
        
        [_phoneTextField setBackgroundColor:COLOR_F8F9FA_333D48];
        _phoneTextField.textColor = COLOR_27323F_EFEFF6;
        
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:K_str_inputPhoneNum attributes:@{NSForegroundColorAttributeName : COLOR_A8ABBE_7B8196,NSFontAttributeName :HK_FONT_SYSTEM(14)}];
        _phoneTextField.attributedPlaceholder = placeholderString;
    }
    return _phoneTextField;
}




- (HKTextField*)authCodeTextField {
    
    if (!_authCodeTextField) {
        
        _isAuthCodeEmpty = YES;
        _authCodeTextField = [[HKTextField alloc]init];
        _authCodeTextField.delegate = self;
        [_authCodeTextField setBackgroundColor:COLOR_F8F9FA];
        //_authCodeTextField.placeholder = K_str_inputAuthCode;
        _authCodeTextField.font = HK_FONT_SYSTEM(14);
        _authCodeTextField.keyboardType = UIKeyboardTypeDefault;
        
        _authCodeTextField.leftView = [[UIImageView alloc]initWithImage:imageName(@"lock_gray")];
        _authCodeTextField.leftViewMode = UITextFieldViewModeAlways;
        [_authCodeTextField sizeToFit];
        //设置监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authCodeTextFieldDidChange) name:UITextFieldTextDidChangeNotification object:_authCodeTextField];
        [_authCodeTextField setBackgroundColor:COLOR_F8F9FA_333D48];
        _authCodeTextField.textColor = COLOR_27323F_EFEFF6;
        
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:K_str_inputAuthCode attributes:@{NSForegroundColorAttributeName : COLOR_A8ABBE_7B8196,NSFontAttributeName :HK_FONT_SYSTEM(14)}];
        _authCodeTextField.attributedPlaceholder = placeholderString;
    }
    return _authCodeTextField;
}




- (VerificationCodeButton*)getAuthCodeBtn {
    
    if (!_getAuthCodeBtn) {
        _getAuthCodeBtn = [[VerificationCodeButton alloc]initWithFrame:CGRectZero];
        [_getAuthCodeBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
        [_getAuthCodeBtn setTag:22];
        _getAuthCodeBtn.layer.cornerRadius = 22.f;
    }
    return _getAuthCodeBtn;
}




- (UIButton*)registerBtn {
    
    if (!_registerBtn) {
        _registerBtn = [UIButton new];
        [_registerBtn setEnabled:NO];
        _registerBtn.tag = 20;
        [_registerBtn.titleLabel setFont:HK_FONT_SYSTEM(17)];
        
        _registerBtn.clipsToBounds = YES;
        [_registerBtn.layer setCornerRadius:22];
        [_registerBtn setTitle:@"绑定" forState:UIControlStateNormal];
        [_registerBtn setTitle:@"绑定" forState:UIControlStateHighlighted];
        
        [_registerBtn setTitleColor:COLOR_ffffff forState:UIControlStateNormal];
        [_registerBtn setTitleColor:COLOR_7B8196 forState:UIControlStateDisabled];
        
        UIColor *color = [UIColor colorWithHexString:@"#ff8c00"];
        UIColor *color1 = [UIColor colorWithHexString:@"#ffa000"];
        UIColor *color2 = [UIColor colorWithHexString:@"#ffb200"];
        UIImage *imageTemp = [[UIImage alloc]createImageWithSize:CGSizeMake(430 * 0.5, 44) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
        
        [_registerBtn setBackgroundImage:imageTemp forState:UIControlStateNormal];
        
        UIImage *backgroundImage = [UIImage hkdm_imageWithNameLight:@"login_code_bg_enable" darkImageName:@"login_code_bg_enable_dark"];
        [_registerBtn setBackgroundImage:backgroundImage forState:UIControlStateDisabled];
        [_registerBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
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




- (void)registerAction:(id)sender {
    
    [self.delegate registerWithAuthcode:sender];
}


#pragma mark UITextField 代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.phoneTextField resignFirstResponder];
    [self.authCodeTextField resignFirstResponder];
    return YES;
}





- (void)phoneTextFieldDidChange {
    
    /** 裁剪 字符串 */
    if (self.phoneTextField.text.length > 11){
        self.phoneTextField.text = [self.phoneTextField.text substringToIndex:11];
    }
    
    if (self.phoneTextField.text.length > 0) {
        self.isPhoneEmpty = NO;
        if (self.isAuthCodeEmpty == NO) {
            [self.registerBtn setEnabled:YES];
        }
        if (NO == self.getAuthCodeBtn.isTiming) {
            [_getAuthCodeBtn setEnabled:YES];
            _getAuthCodeBtn.selected = YES;
        }
        
    }else{
        [self.registerBtn setEnabled:NO];
        self.isPhoneEmpty = YES;
        [self.getAuthCodeBtn setEnabled:NO];
        _getAuthCodeBtn.selected = NO;
    }
}




- (void)authCodeTextFieldDidChange {
    
    if (self.authCodeTextField.text.length > 0) {
        self.isAuthCodeEmpty = NO;
        if (self.isPhoneEmpty == NO ){
            [self.registerBtn setEnabled:YES];
        }
    }else{
        self.isAuthCodeEmpty = YES;
        [self.registerBtn setEnabled:NO];
    }
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.phoneTextField];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.authCodeTextField];
}


@end


////
////  BindPhoneView.m
////  Code
////
////  Created by Ivan li on 2017/9/1.
////  Copyright © 2017年 pg. All rights reserved.
////
//
//#import "BindPhoneView.h"
//#import "VerificationCodeButton.h"
//#import "NSMutableAttributedString+HKAttributed.h"
//#import<QuartzCore/QuartzCore.h>
//#import "HKTextField.h"
//#import "HKCustomMarginLabel.h"
//
//
//#define btnBgColor COLOR_EFEFF6;
//
//#define  registerBtnBgColor   [UIColor colorWithHexString:@"#FFD305"];
//
//
//
//@implementation BindPhoneView
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
//    [self addSubview:self.phoneLine];
//    [self addSubview:self.authCodeLine];
//    [self.phoneLine addSubview:self.phoneTextField];
//    [self.authCodeLine addSubview:self.authCodeTextField];
//
//    [self addSubview:self.registerBtn];
//    [self addSubview:self.getAuthCodeBtn];
//}
//
//
//- (void)setBindPhoneType:(HKBindPhoneType)bindPhoneType {
//    _bindPhoneType = bindPhoneType;
//    if (HKBindPhoneType_Limit == bindPhoneType) {
//        [self setWarnWithText:nil];
//    }
//}
//
//
///** 设置警告提示 */
//- (void)setWarnWithText:(NSString*)text {
//
//    _warnLabel.textInsets = UIEdgeInsetsMake(10, 15, 10, 10);
//    _warnLabel.text = @"小虎提示：登录太频繁可能会导致封号哦~请验证绑定手机，才能登录成功~";
//}
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
//    [_phoneLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (isEmpty(self.warnLabel.text)) {
//            make.top.equalTo(self).offset(32);
//        }else{
//            make.top.lessThanOrEqualTo(self.warnLabel.mas_bottom).offset(32);
//        }
//        make.left.equalTo(self).offset(PADDING_25);
//        make.right.equalTo(self).offset(-PADDING_25);
//        make.height.mas_equalTo(kHeight44);
//    }];
//
//    [_authCodeLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.phoneLine);
//        make.width.equalTo(self.phoneLine.mas_width).multipliedBy(IS_IPHONE5S ?0.6 :0.55);
//        make.height.mas_equalTo(kHeight44);
//        make.top.equalTo(self.phoneLine.mas_bottom).offset(PADDING_15);
//    }];
//
//
//    [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        //make.top.equalTo(weakSelf.phoneLine.mas_top).offset(PADDING_5);
//        make.centerY.equalTo(self.phoneLine.mas_centerY);
//        make.left.equalTo(self.phoneLine.mas_left).offset(PADDING_20);
//        make.right.equalTo(self.phoneLine.mas_right).offset(-PADDING_5);
//        make.height.mas_equalTo(PADDING_30);
//    }];
//
//    [_authCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.centerY.equalTo(self.authCodeLine.mas_centerY);
//        //make.top.equalTo(weakSelf.authCodeLine.mas_top).offset(PADDING_5);
//        make.left.equalTo(self.authCodeLine).offset(PADDING_20);
//        make.right.equalTo(self.authCodeLine).offset(-PADDING_5);
//        make.height.mas_equalTo(PADDING_30);
//    }];
//
//
//    [_getAuthCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.authCodeLine.mas_centerY);
//        make.right.height.equalTo(self.phoneLine);
//        make.left.equalTo(self.authCodeLine.mas_right).offset(PADDING_15);
//        //make.size.mas_equalTo(CGSizeMake(PADDING_20*4, PADDING_35));
//    }];
//
//
//    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.authCodeLine.mas_bottom).offset(PADDING_30);
//        make.right.left.equalTo(self.phoneLine);
//        make.height.mas_equalTo(kHeight44);
//    }];
//
//}
//
//
//
//- (UIView*)phoneLine {
//
//    if (!_phoneLine) {
//        _phoneLine = [[UIView alloc] init];
//        _phoneLine.backgroundColor = COLOR_F8F9FA;
//        _phoneLine.layer.cornerRadius = 7.5f;
//    }
//    return _phoneLine;
//}
//
//
//
//
//- (UIView*)authCodeLine {
//
//    if (!_authCodeLine) {
//        _authCodeLine = [[UIView alloc] init];
//        _authCodeLine.backgroundColor = COLOR_F8F9FA;
//        _authCodeLine.layer.cornerRadius = 7.5f;
//    }
//    return _authCodeLine;
//}
//
//
//- (HKTextField*)phoneTextField {
//
//    if (!_phoneTextField) {
//
//        _isPhoneEmpty = YES;
//        _phoneTextField = [[HKTextField alloc]init];
//        _phoneTextField.delegate = self;
//        [_phoneTextField setBackgroundColor:COLOR_F8F9FA];
//        _phoneTextField.placeholder = K_str_inputPhoneNum;
//        _phoneTextField.font = HK_FONT_SYSTEM(14);
//        _phoneTextField.keyboardType = UIKeyboardTypePhonePad;
//
//        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _phoneTextField.leftView = [[UIImageView alloc]initWithImage:imageName(@"phone_gray")];
//        _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
//        [_phoneTextField sizeToFit];
//
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneTextFieldDidChange) name:UITextFieldTextDidChangeNotification object:_phoneTextField];
//    }
//    return _phoneTextField;
//}
//
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
//        [_authCodeTextField setBackgroundColor:COLOR_F8F9FA];
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
//        [_getAuthCodeBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_getAuthCodeBtn setTag:22];
//    }
//    return _getAuthCodeBtn;
//}
//
//
//
//
//- (UIButton*)registerBtn {
//
//    if (!_registerBtn) {
//        _registerBtn = [UIButton new];
//        [_registerBtn setEnabled:NO];
//        _registerBtn.tag = 20;
//        [_registerBtn.titleLabel setFont:HK_FONT_SYSTEM(17)];
//
//        _registerBtn.clipsToBounds = YES;
//        [_registerBtn.layer setCornerRadius:7.5];
//        [_registerBtn setTitle:@"绑定" forState:UIControlStateNormal];
//        [_registerBtn setTitle:@"绑定" forState:UIControlStateHighlighted];
//
//        [_registerBtn setTitleColor:COLOR_27323F forState:UIControlStateNormal];
//        [_registerBtn setTitleColor:COLOR_7B8196 forState:UIControlStateDisabled];
//
//        [_registerBtn setBackgroundImage:imageName(@"login_code_bg") forState:UIControlStateNormal];
//        [_registerBtn setBackgroundImage:imageName(@"login_code_bg_enable") forState:UIControlStateDisabled];
//
//        [_registerBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _registerBtn;
//}
//
//
//- (HKCustomMarginLabel *)warnLabel {
//
//    if (!_warnLabel) {
//
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
//
//- (void)registerAction:(id)sender {
//
//    [self.delegate registerWithAuthcode:sender];
//}
//
//
//#pragma mark UITextField 代理
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//
//    [self.phoneTextField resignFirstResponder];
//    [self.authCodeTextField resignFirstResponder];
//    return YES;
//}
//
//
//
//
//
//- (void)phoneTextFieldDidChange {
//
//    /** 裁剪 字符串 */
//    if (self.phoneTextField.text.length > 11){
//        self.phoneTextField.text = [self.phoneTextField.text substringToIndex:11];
//    }
//
//    if (self.phoneTextField.text.length > 0) {
//        self.isPhoneEmpty = NO;
//        if (self.isAuthCodeEmpty == NO) {
//            [self.registerBtn setEnabled:YES];
//        }
//        if (NO == self.getAuthCodeBtn.isTiming) {
//            [_getAuthCodeBtn setEnabled:YES];
//        }
//    }else{
//        [self.registerBtn setEnabled:NO];
//        self.isPhoneEmpty = YES;
//        [self.getAuthCodeBtn setEnabled:NO];
//    }
//
//}
//
//
//
//
//- (void)authCodeTextFieldDidChange {
//
//    if (self.authCodeTextField.text.length > 0) {
//        self.isAuthCodeEmpty = NO;
//        if (self.isPhoneEmpty == NO ){
//            [self.registerBtn setEnabled:YES];
//        }
//    }else{
//        self.isAuthCodeEmpty = YES;
//        [self.registerBtn setEnabled:NO];
//    }
//}
//
//
//- (void)dealloc {
//
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.phoneTextField];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.authCodeTextField];
//}
//
//
//@end
