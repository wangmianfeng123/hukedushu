//
//  LoginBindPhoneView.m
//  Code
//
//  Created by Ivan li on 2017/9/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "LoginBindPhoneView.h"
#import "VerificationCodeButton.h"
#import<QuartzCore/QuartzCore.h>

#define btnBgColor RGB(210, 210, 210, 1);




@implementation LoginBindPhoneView


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
    
    [self addSubview:self.phoneLine];
    [self addSubview:self.authCodeLine];
    
    [self.phoneLine addSubview:self.phoneTextField];
    [self.authCodeLine addSubview:self.authCodeTextField];
    
    [self.authCodeLine addSubview:self.getAuthCodeBtn];
    [self addSubview:self.registerBtn];
    
    [self addSubview:self.tipLabel];
}


- (void)makeConstraints {
    
    __weak typeof(self) weakSelf = self;
    
    [_phoneLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(PADDING_25);
        make.left.equalTo(weakSelf.mas_left).offset(PADDING_25);
        make.right.equalTo(weakSelf.mas_right).offset(-PADDING_25);
        make.height.mas_equalTo(kHeight44);
    }];
    
    
    [_authCodeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.phoneLine);
        make.height.mas_equalTo(kHeight44);
        make.top.equalTo(weakSelf.phoneLine.mas_bottom).offset(PADDING_10);
    }];
    
    
    [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.phoneLine.mas_centerY);
        make.left.equalTo(weakSelf.phoneLine.mas_left).offset(PADDING_20);
        make.right.equalTo(weakSelf.phoneLine.mas_right).offset(-PADDING_5);
        make.height.mas_equalTo(PADDING_30);
    }];
    
    [_authCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(weakSelf.authCodeLine.mas_centerY);
        make.left.equalTo(weakSelf.authCodeLine.mas_left).offset(PADDING_20);
        make.right.equalTo(weakSelf.getAuthCodeBtn.mas_left).offset(-PADDING_5);
        make.height.mas_equalTo(PADDING_30);
    }];
    
    
    [_getAuthCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.authCodeLine.mas_centerY);
        make.right.equalTo(weakSelf.phoneLine.mas_right).offset(-PADDING_20);
        make.size.mas_equalTo(CGSizeMake(PADDING_20*4, PADDING_35));
    }];
    
    
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.authCodeLine.mas_bottom).offset(kHeight25);
        make.right.left.equalTo(weakSelf.phoneLine);
        make.height.mas_equalTo(kHeight44);
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.top.equalTo(weakSelf.registerBtn.mas_bottom).offset(PADDING_20);
    }];
    
}




- (UIView*)phoneLine {
    
    if (!_phoneLine) {
        _phoneLine = [[UIView alloc] init];
        //_phoneLine.backgroundColor = [UIColor blackColor];//[UIColor colorWithHexString:@"#ffffff"];
        _phoneLine.layer.borderColor = [[UIColor colorWithRed:199/255.0 green:199/255.0 blue:199/255.0 alpha:1] CGColor];
        _phoneLine.layer.borderWidth = 0.5f;
        _phoneLine.layer.cornerRadius = 20.0f;
    }
    return _phoneLine;
}


- (UIView*)authCodeLine {
    
    if (!_authCodeLine) {
        _authCodeLine = [[UIView alloc] init];
        _authCodeLine.layer.borderColor = [[UIColor colorWithRed:199/255.0 green:199/255.0 blue:199/255.0 alpha:1] CGColor];
        _authCodeLine.layer.borderWidth = 0.5f;
        _authCodeLine.layer.cornerRadius = 20.0f;
    }
    return _authCodeLine;
}


- (UITextField*)phoneTextField {
    
    if (!_phoneTextField) {
        
        _isPhoneEmpty = YES;
        _phoneTextField = [UITextField new];
        _phoneTextField.delegate = self;
        [_phoneTextField setBackgroundColor:[UIColor whiteColor]];
        //_phoneTextField.placeholder = K_str_inputPhoneNum;
        _phoneTextField.font = HK_FONT_SYSTEM(14);
        _phoneTextField.keyboardType = UIKeyboardTypePhonePad;
        
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_phoneTextField sizeToFit];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneTextFieldDidChange) name:UITextFieldTextDidChangeNotification object:_phoneTextField];
        
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:K_str_inputPhoneNum attributes:@{NSForegroundColorAttributeName : COLOR_A8ABBE_7B8196,NSFontAttributeName :HK_FONT_SYSTEM(14)}];
        _phoneTextField.attributedPlaceholder = placeholderString;
    }
    return _phoneTextField;
}



- (UITextField*)authCodeTextField {
    
    if (!_authCodeTextField) {
        
        _isAuthCodeEmpty = YES;
        _authCodeTextField = [UITextField new];
        _authCodeTextField.delegate = self;
        [_authCodeTextField setBackgroundColor:[UIColor whiteColor]];
        //_authCodeTextField.placeholder = K_str_inputAuthCode;
        _authCodeTextField.font = HK_FONT_SYSTEM(14);
        _authCodeTextField.keyboardType = UIKeyboardTypeDefault;
        
        _authCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
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
        [_getAuthCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getAuthCodeBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        //[_getAuthCodeBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateSelected];
        [_getAuthCodeBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
        [_getAuthCodeBtn setTag:22];
    }
    return _getAuthCodeBtn;
}



- (UIButton*)registerBtn {
    
    if (!_registerBtn) {
        
        _registerBtn = [UIButton new];
        [_registerBtn setEnabled:NO];
        _registerBtn.tag = 20;
        [_registerBtn.layer setCornerRadius:20.0];
        [_registerBtn setTitle:@"绑定" forState:UIControlStateNormal];
        [_registerBtn setTitle:@"绑定" forState:UIControlStateHighlighted];
        _registerBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _registerBtn.backgroundColor = RGB(210, 210, 210, 1);
        [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_registerBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}




- (UILabel *)tipLabel {
    
    if (!_tipLabel) {
        NSString *font = IS_IPHONE6PLUS ?@"14" :@"13";
        _tipLabel = [UILabel labelWithTitle:CGRectZero title:nil//@"绑定手机号即可获得100虎课币哦～"
                                 titleColor:[UIColor colorWithHexString:@"#999999"]
                                  titleFont:font
                              titleAligment:NSTextAlignmentCenter];
    }
    return _tipLabel;
}



- (void)registerAction:(id)sender {
    
    [self.delegate loginBindPhoneWithAuthcode:sender];
}


#pragma mark UITextField 代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.phoneTextField resignFirstResponder];
    [self.authCodeTextField resignFirstResponder];
    return YES;
}



#define  registerBtnBgColor   [UIColor colorWithHexString:@"#ffd500"];

- (void)phoneTextFieldDidChange {
    
    if (self.phoneTextField.text.length > 0) {
        self.isPhoneEmpty = NO;
        if (self.isAuthCodeEmpty == NO) {
            [self.registerBtn setEnabled:YES];
            _registerBtn.backgroundColor = registerBtnBgColor;
        }
    }else{
        [self.registerBtn setEnabled:NO];
        self.isPhoneEmpty = YES;
        _registerBtn.backgroundColor = btnBgColor;
    }
}




- (void)authCodeTextFieldDidChange {
    
    if (self.authCodeTextField.text.length > 0) {
        self.isAuthCodeEmpty = NO;
        if (self.isPhoneEmpty == NO ){
            [self.registerBtn setEnabled:YES];
            _registerBtn.backgroundColor = registerBtnBgColor;
        }
    }else{
        self.isAuthCodeEmpty = YES;
        _registerBtn.backgroundColor = btnBgColor;
        [self.registerBtn setEnabled:NO];
    }
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.phoneTextField];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.authCodeTextField];
}


@end

