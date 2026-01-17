//
//  RegistereView.m
//  Code
//
//  Created by Ivan li on 2017/8/25.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "RegistereView.h"
#import "VerificationCodeButton.h"
#import<QuartzCore/QuartzCore.h>
#import <UMShare/UMShare.h>
#import "HKTextField.h"
#import "HKPopMenu.h"
#import "HKPopupMenu.h"
#import "HKPopupMenuDefaultConfig.h"
#import "HKSocialLoginView.h"

#define btnBgColor COLOR_EFEFF6;

#define  registerBtnBgColor   [UIColor colorWithHexString:@"#FFD305"];

@interface RegistereView() <VerificationCodeButtonDelegate>

@property (nonatomic,strong)HKSocialLoginView  *socialLoginView;

@property(nonatomic,strong)UIButton *privacyBtn;
/** 注册协议 按钮 */
@property(nonatomic,strong)UIButton *agreementBtn;

@end


@implementation RegistereView


- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self makeConstraints];
}



- (void)createUI {
    
    [self addSubview:self.themeLB];
    [self addSubview:self.phoneLine];
    [self addSubview:self.safeCodeLine];
    [self addSubview:self.authCodeLine];
    
    [self.phoneLine addSubview:self.phoneTextField];
    [self.safeCodeLine addSubview:self.safeCodeTextField];
    [self.authCodeLine addSubview:self.authCodeTextField];
    
    [self addSubview:self.getAuthCodeBtn];
    [self addSubview:self.pooCodeView];
    [self addSubview:self.registerBtn];
    [self addSubview:self.socialLoginView];
    
    [self addSubview:self.selectBtn];
    [self addSubview:self.privacyBtn];
    [self addSubview:self.agreementBtn];
    
    
    [self racSignal];
//    [self.selectBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    self.loginViewThemeType = HKLoginViewThemeType_phone;
}



- (void)racSignal {

    @weakify(self);
    RAC(self.registerBtn,selected) = [RACSignal combineLatest:@[self.phoneTextField.rac_textSignal,
             self.safeCodeTextField.rac_textSignal,self.authCodeTextField.rac_textSignal,[self.selectBtn rac_signalForControlEvents:UIControlEventTouchUpInside]]
    reduce:^(NSString *phone,NSString *safeCode,NSString*authCode,UIButton *selectBtn){
        @strongify(self);
        return @(phone.length>0 && safeCode.length>=4 && authCode.length>0 && selectBtn.selected);
    }];
    
    RAC(self.getAuthCodeBtn,selected) = [RACSignal combineLatest:@[self.phoneTextField.rac_textSignal,
             self.safeCodeTextField.rac_textSignal]
    reduce:^(NSString *phone,NSString *safeCode){
        @strongify(self);
        if (isEmpty(phone) || (phone.length < 11) || (NO == [self isAllNum:phone])) {
            return @(NO);
        }
        if (NO ==  [self isPicCorrect]) {
            return @(NO);
        }
        return @(YES);
    }];
    
//    RAC(self.registerBtn,selected) = [RACSignal combineLatest:@[self.phoneTextField.rac_textSignal,
//                                                                self.authCodeTextField.rac_textSignal,
//                                                                [self.selectBtn rac_signalForControlEvents:UIControlEventTouchUpInside]]
//    reduce:^(NSString *phone,NSString*authCode,UIButton *selectBtn){
//        @strongify(self);
//        return @(phone.length>0 && authCode.length>0 && selectBtn.selected);
//    }];
    

    
//    RAC(self.getAuthCodeBtn,selected) = [RACSignal combineLatest:@[self.phoneTextField.rac_textSignal]
//    reduce:^(NSString *phone){
//        @strongify(self);
//        if (isEmpty(phone) || (phone.length < 11) || (NO == [self isAllNum:phone])) {
//            return @(NO);
//        }
//        return @(YES);
//    }];
}



- (void)makeConstraints {
    
    [self.themeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(16);
    }];
        
    [self.phoneLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.themeLB.mas_bottom).offset(32);
        make.left.equalTo(self.mas_left).offset(PADDING_25);
        make.right.equalTo(self.mas_right).offset(-PADDING_25);
        make.height.mas_equalTo(45);
    }];
    
    [self.safeCodeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneLine);
        make.height.mas_equalTo(45);
        make.width.equalTo(self.phoneLine.mas_width).multipliedBy(IS_IPHONE5S ?0.6 :0.55);
        make.top.equalTo(self.phoneLine.mas_bottom).offset(10);
    }];
    
    
    [self.authCodeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneLine);
        make.height.mas_equalTo(45);
        make.width.equalTo(self.phoneLine.mas_width).multipliedBy(IS_IPHONE5S ?0.6 :0.55);
        make.top.equalTo(self.safeCodeLine.mas_bottom).offset(10);
    }];
    
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.phoneLine.mas_centerY);
        make.left.equalTo(self.phoneLine.mas_left).offset(PADDING_25);
        make.right.equalTo(self.phoneLine.mas_right).offset(-PADDING_5);
        make.height.mas_equalTo(45);
    }];
    
    [self.safeCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.safeCodeLine.mas_centerY);
        make.left.equalTo(self.safeCodeLine.mas_left).offset(2);
        make.right.equalTo(self.safeCodeLine).offset(-5);
        make.height.equalTo(_phoneTextField.mas_height);
    }];

    [self.authCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.authCodeLine.mas_centerY);
        make.left.equalTo(self.authCodeLine.mas_left).offset(PADDING_25);
        make.right.equalTo(self.authCodeLine).offset(-5);
        make.height.equalTo(_phoneTextField.mas_height);
    }];
    
    [self.getAuthCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.authCodeLine.mas_centerY);
        make.right.equalTo(self.phoneLine.mas_right);
        make.left.equalTo(_authCodeLine.mas_right).offset(PADDING_15);
        make.height.equalTo(_phoneTextField.mas_height);
    }];
    
    [self.pooCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.safeCodeLine.mas_centerY);
        make.right.equalTo(self.phoneLine.mas_right);
        make.left.equalTo(_safeCodeLine.mas_right).offset(PADDING_15);
        make.height.equalTo(_phoneTextField.mas_height);
    }];

    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.authCodeLine.mas_bottom).offset(PADDING_30);
        make.right.left.equalTo(self.phoneLine);
        make.height.mas_equalTo(kHeight44);
    }];
    
    [self.socialLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(IS_IPHONE5S ? 140 :170);
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.agreementBtn.mas_left).offset(0);
        make.centerY.equalTo(self.agreementBtn);
        make.width.mas_equalTo(@30);
        make.height.mas_equalTo(@50);
    }];
    
    [self.agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.registerBtn.mas_bottom).offset(30);
        make.centerX.mas_equalTo(- (self.privacyBtn.width/2 - (self.selectBtn.width+5)/2));
    }];

    [self.privacyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.agreementBtn);
        make.left.equalTo(self.agreementBtn.mas_right).offset(0);
    }];
}




- (void)setLoginViewThemeType:(HKLoginViewThemeType)loginViewThemeType {
    _loginViewThemeType = loginViewThemeType;
    switch (loginViewThemeType) {
        case HKLoginViewThemeType_phone:
            _themeLB.text = @"手机号登录";
            break;
            
        case HKLoginViewThemeType_study:
            _themeLB.text = @"登录查看我的学习记录";
            break;
            
        default:
            break;
    }
}


- (UILabel*)themeLB {
    if (!_themeLB) {
        _themeLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F_EFEFF6 titleFont:nil titleAligment:NSTextAlignmentCenter];
        _themeLB.font = HK_FONT_SYSTEM_BOLD(18);
    }
    return _themeLB;
}


- (UIView*)phoneLine {
    
    if (!_phoneLine) {
        _phoneLine = [[UIView alloc] init];
        _phoneLine.backgroundColor = COLOR_F8F9FA_333D48;
        _phoneLine.clipsToBounds = YES;
        _phoneLine.layer.cornerRadius = 45 * 0.5;
    }
    return _phoneLine;
}

- (UIView*)safeCodeLine {
    
    if (!_safeCodeLine) {
        _safeCodeLine = [[UIView alloc] init];
        _safeCodeLine.backgroundColor = COLOR_F8F9FA_333D48;
        _safeCodeLine.clipsToBounds = YES;
        _safeCodeLine.layer.cornerRadius = 45 * 0.5;
    }
    return _safeCodeLine;
}


- (UIView*)authCodeLine {
    
    if (!_authCodeLine) {
        _authCodeLine = [[UIView alloc] init];
        _authCodeLine.backgroundColor = COLOR_F8F9FA_333D48;
        _authCodeLine.clipsToBounds = YES;
        _authCodeLine.layer.cornerRadius = 45 * 0.5;
    }
    return _authCodeLine;
}




- (HKTextField*)phoneTextField {
    
    if (!_phoneTextField) {
        
        _phoneTextField = [[HKTextField alloc]init];
        _phoneTextField.delegate = self;
        [_phoneTextField setBackgroundColor:COLOR_F8F9FA_333D48];
        _phoneTextField.placeholder = K_str_inputPhoneNum;
        _phoneTextField.font = HK_FONT_SYSTEM(14);
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextField.leftView = [[UIImageView alloc]initWithImage:imageName(@"phone_gray")];
        _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
        [_phoneTextField sizeToFit];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:_phoneTextField];
        _phoneTextField.textColor = COLOR_27323F_EFEFF6;
        
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:K_str_inputPhoneNum attributes:@{NSForegroundColorAttributeName : COLOR_A8ABBE_7B8196,NSFontAttributeName :HK_FONT_SYSTEM(14)}];
        _phoneTextField.attributedPlaceholder = placeholderString;
    }
    return _phoneTextField;
}






- (HKTextField*)authCodeTextField {
    
    if (!_authCodeTextField) {
        
        _authCodeTextField = [[HKTextField alloc]init];
        _authCodeTextField.delegate = self;
        [_authCodeTextField setBackgroundColor:COLOR_F8F9FA_333D48];
        _authCodeTextField.placeholder = K_str_inputAuthCode;
        _authCodeTextField.font = HK_FONT_SYSTEM(14);
        _authCodeTextField.keyboardType = UIKeyboardTypeDefault;
        
        _authCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _authCodeTextField.leftView = [[UIImageView alloc]initWithImage:imageName(@"lock_gray")];
        _authCodeTextField.leftViewMode = UITextFieldViewModeAlways;
        [_authCodeTextField sizeToFit];
        //设置监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authCodeTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:_authCodeTextField];
        _authCodeTextField.textColor = COLOR_27323F_EFEFF6;
        
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:K_str_inputAuthCode attributes:@{NSForegroundColorAttributeName : COLOR_A8ABBE_7B8196,NSFontAttributeName :HK_FONT_SYSTEM(14)}];
        _authCodeTextField.attributedPlaceholder = placeholderString;
    }
    return _authCodeTextField;
}


- (HKTextField*)safeCodeTextField {
    
    if (!_safeCodeTextField) {
        
        _safeCodeTextField = [[HKTextField alloc]init];
        _safeCodeTextField.delegate = self;
        [_safeCodeTextField setBackgroundColor:COLOR_F8F9FA_333D48];
        //_safeCodeTextField.placeholder = IS_IPHONE5S ?@"请输入图形码":@"请输入图形验证码";
        _safeCodeTextField.font = HK_FONT_SYSTEM(14);
        _safeCodeTextField.keyboardType = UIKeyboardTypeDefault;
        
        _safeCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        //        _safeCodeTextField.leftViewMode = UITextFieldViewModeAlways;
        _safeCodeTextField.leftViewMode = UITextFieldViewModeNever;
        [_safeCodeTextField sizeToFit];
        
        //设置监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(safeCodeTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:_safeCodeTextField];
        _safeCodeTextField.textColor = COLOR_27323F_EFEFF6;
        
        NSString *placeholder = IS_IPHONE5S ?@"请输入图形码":@"请输入图形验证码";
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName : COLOR_A8ABBE_7B8196,NSFontAttributeName :HK_FONT_SYSTEM(14)}];
        _safeCodeTextField.attributedPlaceholder = placeholderString;
    }
    return _safeCodeTextField;
}

- (PooCodeView *)pooCodeView {
    
    if (_pooCodeView == nil) {
        _pooCodeView = [[PooCodeView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) andChangeArray:nil];
        _pooCodeView.clipsToBounds = YES;
        _pooCodeView.layer.cornerRadius = 7.5f;
        _pooCodeView.backgroundColor = [UIColor clearColor];
    }
    return _pooCodeView;
}


- (VerificationCodeButton*)getAuthCodeBtn {
    
    if (!_getAuthCodeBtn) {
        
        _getAuthCodeBtn = [VerificationCodeButton buttonWithType:UIButtonTypeCustom];
        _getAuthCodeBtn.clipsToBounds = YES;
        //_getAuthCodeBtn.cornerRadius = 45*0.5;
        _getAuthCodeBtn.layer.cornerRadius = 45*0.5;
        _getAuthCodeBtn.tag = 22;
        [_getAuthCodeBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
        _getAuthCodeBtn.delegate = self;
        // 取消高亮的点击状态
        [_getAuthCodeBtn setAdjustsImageWhenHighlighted:NO];
    }
    return _getAuthCodeBtn;
}



- (UIButton*)registerBtn {
    
    if (!_registerBtn) {
        
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerBtn.tag = 20;
        _registerBtn.clipsToBounds = YES;
        [_registerBtn.layer setCornerRadius:22];
        [_registerBtn.titleLabel setFont:HK_FONT_SYSTEM(17)];
        [_registerBtn setTitle:@"进入虎课" forState:UIControlStateNormal];
        [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_registerBtn setTitleColor:COLOR_7B8196_27323F forState:UIControlStateNormal];
        
        UIColor *color = [UIColor colorWithHexString:@"#ff8c00"];
        UIColor *color1 = [UIColor colorWithHexString:@"#ffa000"];
        UIColor *color2 = [UIColor colorWithHexString:@"#ffb200"];
        UIImage *imageTemp = [[UIImage alloc]createImageWithSize:CGSizeMake(430 * 0.5, 75 * 0.5) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
        [_registerBtn setBackgroundImage:imageTemp forState:UIControlStateSelected];
        
        UIImage *backgroundImage = [UIImage hkdm_imageWithNameLight:@"login_code_bg_enable" darkImageName:@"login_code_bg_enable_dark"];
        [_registerBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        
        [_registerBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
        // 取消高亮的点击状态
        [_registerBtn setAdjustsImageWhenHighlighted:NO];
    }
    return _registerBtn;
}


- (HKSocialLoginView*)socialLoginView {
    
    if (!_socialLoginView) {
        @weakify(self);
        _socialLoginView = [[HKSocialLoginView alloc]initWithFrame:CGRectZero];
        _socialLoginView.socialLoginViewType = HKSocialLoginViewType_phoneLogin;
        _socialLoginView.socialLoginBlock = ^(UIButton * _Nonnull btn) {
            @strongify(self);
            if (self.socialphoneLoginBlock) {
                self.socialphoneLoginBlock(btn,self.selectBtn);
            }
        };
        
//        if (IS_IPAD) {
            _socialLoginView.hidden = YES;
//            @weakify(self);
            [CommonFunction checkAPPStatus:^{
//                @strongify(self);
                if (self.socialLoginView) {
                    self.socialLoginView.hidden = NO;
                }
            }];
//        }
    }
    return _socialLoginView;
}





- (UIButton*)selectBtn {
    if (!_selectBtn) {
        _selectBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn addTarget:self action:@selector(selectBtnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *normalImage = [UIImage hkdm_imageWithNameLight:@"ic_round_normal_v2_10" darkImageName:@"ic_round_normal_v2_10_dark"];
        [_selectBtn setImage:normalImage forState:UIControlStateNormal];
        
        UIImage *selectImage = [UIImage hkdm_imageWithNameLight:@"ic_round_selected_v2_10" darkImageName:@"ic_round_selected_v2_10_dark"];
        [_selectBtn setImage:selectImage forState:UIControlStateSelected];
        [_selectBtn setEnlargeEdgeWithTop:20 right:5 bottom:30 left:30];
        [_selectBtn sizeToFit];
        //_selectBtn.selected = YES;
    }
    return _selectBtn;
}


- (void)selectBtnBtnClick:(UIButton*)btn {
    btn.selected = !btn.selected;
    
}


- (UIButton*)agreementBtn {
    
    if (!_agreementBtn) {
        UIColor *textColor = [UIColor hkdm_colorWithColorLight:COLOR_A8AFB8 dark:COLOR_7B8196];
        _agreementBtn =  [UIButton buttonWithTitle:@"我已阅读并同意《虎课用户协议》" titleColor:textColor titleFont:@"12" imageName:nil];
        [_agreementBtn addTarget:self action:@selector(agreementBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _agreementBtn.tag = 24;
    }
    return _agreementBtn;
}

- (void)agreementBtnClick:(UIButton*)btn {
    if (self.agreementBtnClickBlock) {
        self.agreementBtnClickBlock(btn);
    }
}


- (UIButton*)privacyBtn {
    
    if (!_privacyBtn) {
        UIColor *textColor = [UIColor hkdm_colorWithColorLight:COLOR_A8AFB8 dark:COLOR_7B8196];
        _privacyBtn =  [UIButton buttonWithTitle:@"《隐私协议》" titleColor:textColor titleFont:@"12" imageName:nil];
        [_privacyBtn addTarget:self action:@selector(privacyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_privacyBtn sizeToFit];
    }
    return _privacyBtn;
}


- (void)privacyBtnClick:(UIButton*)btn {
    if (self.privacyBtnClickBlock) {
        self.privacyBtnClickBlock(btn);
    }
}


- (void)registerAction:(id)sender {
    
//    // 注册 校验图形验证码
//    NSInteger tag = [(UIButton *)sender tag];
//    if (20 == tag ) {
//        if (!self.selectBtn.selected) {
//            showTipDialog(ONE_LOGIN_MSG);
//            return;
//        }
//    }
    [self.delegate registerWithAuthcode:sender];
}



/** 图形验证码  YES - 正确 NO  */
- (BOOL)isPicCorrect {
    int result1 = [self.pooCodeView.changeString compare:self.safeCodeTextField.text options:NSCaseInsensitiveSearch];
    if (self.pooCodeView.changeString.length != self.safeCodeTextField.text.length || result1 != 0) {
        return NO;
    }
    return YES;
}

#pragma mark VerificationCodeButton 代理
- (void)timerEnd:(id)sender {
    
}



#pragma mark UITextField 代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.phoneTextField resignFirstResponder];
    [self.authCodeTextField resignFirstResponder];
    return YES;
}



- (void)phoneTextFieldDidChange:(NSNotification *)noti {
    
    [self clipString:noti.object count:11];
}



- (BOOL)isAllNum:(NSString *)string{
    unichar c;
    for (int i=0; i<string.length; i++) {
        c=[string characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}



- (void)safeCodeTextFieldDidChange:(NSNotification *)noti {
    
}



- (void)authCodeTextFieldDidChange:(NSNotification *)noti {
    
    [self clipString:noti.object count:8];
}



/** 裁剪 字符串 */
- (void)clipString:(UITextField *)textField  count:(NSInteger)count{
    
    if (textField.text.length > count){
        textField.text = [textField.text substringToIndex:count];
    }
}



- (NSString*)phoneText{
    return self.phoneTextField.text;
}


- (NSString*)authCodeText{
    return self.authCodeTextField.text;
}

- (NSString*)safeCodeText{
    return self.safeCodeTextField.text;
}


- (void)dealloc {
    [self.getAuthCodeBtn stopCountDown];
    TTVIEW_RELEASE_SAFELY(_getAuthCodeBtn);
    HK_NOTIFICATION_REMOVE();
}


@end
