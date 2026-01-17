

//
//  HKLoginView.m
//  Code
//
//  Created by Ivan li on 2018/7/21.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKLoginView.h"
#import <UMShare/UMShare.h>
#import "UIButton+ImageTitleSpace.h"
  
#import "UIImage+Helper.h"
#import "HKWaterWaveView.h"
#import <CoreText/CoreText.h>


/**

 待修护问题
 1，图形验证码错误 不能点击获取手机短信验证码
 2，当日获取手机短信次数受限，不能再点击获取验证码  提示 “已经达到上限”
 
*/


@implementation HKLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }return self;
}


- (instancetype)init{
    if (self = [super init]) {
        [self createUI];
    }return self;
}



- (void)createUI {
    
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    self.clipsToBounds = YES;
    [self addSubview:self.logoImageView];
    
    [self addSubview:self.phoneLoginBtn];
    [self addSubview:self.qqLoginBtn];
    
    [self addSubview:self.weiBoLoginBtn];
    [self addSubview:self.agreementBtn];
    BOOL isWechat = [self checkClientIsInstall:UMSocialPlatformType_WechatSession];
    if (isWechat) {
        [self addSubview:self.weChatLoginBtn];
    }
    
    [self addSubview:self.loginTipLB];
    [self addSubview:self.selectBtn];
    [self addSubview:self.loginTipIV];
    [self addSubview:self.colseButton];
    
    [self addSubview:self.loginThemeLB];
    [self addSubview:self.privacyBtn];
    
    [self addSubview:self.bgBtn];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self lastLoginPattern];
    });
    
    self.selectBtn.selected = YES;
    self.isSelectAgree = YES;
    
}


- (void)setLoginViewType:(HKLoginViewType)loginViewType {
    _loginViewType = loginViewType;
    if (loginViewType == HKLoginViewType_Firstload) {
        [self insertSubview:self.kywaterView aboveSubview:self.logoImageView];
    }
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.agreementBtn.mas_left).offset(-5);
        make.centerY.equalTo(self.agreementBtn);
    }];
    
    if (self.loginViewType == HKLoginViewType_ordinary) {
        [self makeConstraints];
        self.layer.cornerRadius = PADDING_5;
        
        [self.agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-18);
            make.centerX.mas_equalTo(- (self.privacyBtn.width/2 - (self.selectBtn.width+5)/2));
        }];

        [self.privacyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.agreementBtn);
            make.left.equalTo(self.agreementBtn.mas_right).offset(5);
        }];
        
        [self.colseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(6);
            make.right.equalTo(self).offset(-10);
        }];
        
    }else{
        [self makeConstraints1];
        self.layer.cornerRadius = 50;
        [self.agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-22);
            make.centerX.mas_equalTo(- (self.privacyBtn.width/2 - (self.selectBtn.width+5)/2));
        }];

        [self.privacyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.agreementBtn);
            make.left.equalTo(self.agreementBtn.mas_right).offset(5);
        }];
    }
}




- (void)makeConstraints1 {
    
    [self.loginTipLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.phoneLoginBtn.mas_top).offset(-50);
        make.right.left.centerX.equalTo(self);
    }];
    
    BOOL isWechat = [self checkClientIsInstall:UMSocialPlatformType_WechatSession];
    
    if (isWechat ) {
        
        [@[self.weChatLoginBtn, self.qqLoginBtn,self.phoneLoginBtn] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:PADDING_30*2 leadSpacing:30 tailSpacing:30];

        [@[self.weChatLoginBtn, self.qqLoginBtn,self.phoneLoginBtn] mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.bottom.equalTo(self.agreementBtn.mas_top).offset(-54/2);
            make.bottom.equalTo(self.weiBoLoginBtn.mas_top).offset(-55);
            make.size.mas_equalTo(CGSizeMake(PADDING_30*2, PADDING_30*2));
        }];
        
    }else{
        
        [@[self.qqLoginBtn,self.phoneLoginBtn] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:PADDING_30*2
                                                                        leadSpacing:30  tailSpacing:30];
        
        [@[self.qqLoginBtn,self.phoneLoginBtn] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.weiBoLoginBtn.mas_top).offset(-55);
            make.size.mas_equalTo(CGSizeMake(PADDING_30*2, PADDING_30*2));
        }];
    }
    
    [self.weiBoLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.agreementBtn.mas_top).offset(-10);
        make.centerX.equalTo(self);
    }];
}





- (void)makeConstraints {
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(32);
    }];
    
    BOOL isWechat = [self checkClientIsInstall:UMSocialPlatformType_WechatSession];
    
    if (isWechat ) {
        float temp = (SCREEN_WIDTH - PADDING_30*2*3 - PADDING_35*2 - (IS_IPHONE5S?30 :50))/2;
        [@[self.weChatLoginBtn,self.qqLoginBtn,self.phoneLoginBtn] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:PADDING_35 leadSpacing:temp tailSpacing:temp];
        
        [@[self.weChatLoginBtn,self.qqLoginBtn,self.phoneLoginBtn] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.weiBoLoginBtn.mas_top).offset(-55);
            make.size.mas_equalTo(CGSizeMake(PADDING_30*2, PADDING_30*2));
        }];
        
    }else{
        float temp = (SCREEN_WIDTH - PADDING_30*2*2 - PADDING_35 - (IS_IPHONE5S?30 :50))/2;
        [@[self.qqLoginBtn,self.phoneLoginBtn] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:PADDING_35 leadSpacing:temp tailSpacing:temp];
        
        [@[self.qqLoginBtn,self.phoneLoginBtn] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.weiBoLoginBtn.mas_top).offset(-55);
            make.size.mas_equalTo(CGSizeMake(PADDING_30*2, PADDING_30*2));
        }];
    }
    
    [self.weiBoLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.agreementBtn.mas_top).offset(-8);
        make.centerX.equalTo(self);
    }];
    
    [self.loginThemeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(60);
        make.centerX.equalTo(self);
    }];
}



- (UIButton *)phoneLoginBtn {
    
    if (!_phoneLoginBtn) {
        _phoneLoginBtn =  [self customBtnWithTitle:@"手机号码" imageName:@"phone_login" tag:100 ];
        [_phoneLoginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];      
        [_phoneLoginBtn setTitleEdgeInsets:UIEdgeInsetsMake(85,-5, 0, -5)];
        [_phoneLoginBtn setEnlargeEdgeWithTop:PADDING_5 right:PADDING_5 bottom:PADDING_20 left:PADDING_5];
    }
    return _phoneLoginBtn;
}



- (UIButton *)qqLoginBtn {
    
    if (!_qqLoginBtn) {
        _qqLoginBtn =  [self customBtnWithTitle:@"QQ" imageName:@"qq_login" tag:102 ];
        [_qqLoginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        [_qqLoginBtn setTitleEdgeInsets:UIEdgeInsetsMake(85,0, 0, 0)];
        [_qqLoginBtn setEnlargeEdgeWithTop:PADDING_5 right:PADDING_5 bottom:PADDING_20 left:PADDING_5];
    }
    return _qqLoginBtn;
}



- (UIButton *)weChatLoginBtn {
    
    if (!_weChatLoginBtn) {
        _weChatLoginBtn = [self customBtnWithTitle:@"微信" imageName:@"weChat_login"  tag:104 ];
        [_weChatLoginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        [_weChatLoginBtn setTitleEdgeInsets:UIEdgeInsetsMake(85,0, 0, 0)];
        // 未安装客户端 隐藏 WeChat
        _weChatLoginBtn.hidden = ![self checkClientIsInstall:UMSocialPlatformType_WechatSession];
        [_weChatLoginBtn setEnlargeEdgeWithTop:PADDING_5 right:PADDING_5 bottom:PADDING_20 left:PADDING_5];
    }
    return _weChatLoginBtn;
}

- (UIButton*)weiBoLoginBtn {
    if (!_weiBoLoginBtn) {
        _weiBoLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _weiBoLoginBtn.tag = 106;
        [_weiBoLoginBtn setTitle:@"微博登录" forState:UIControlStateNormal];
        [_weiBoLoginBtn setTitleColor:COLOR_7B8196_A8ABBE forState:UIControlStateNormal];
        [_weiBoLoginBtn.titleLabel setFont:HK_FONT_SYSTEM(13)];
        [_weiBoLoginBtn setImage:imageName(@"ic_go_v2_16") forState:UIControlStateNormal];
        [_weiBoLoginBtn setImage:imageName(@"ic_go_v2_16") forState:UIControlStateHighlighted];
    
        [_weiBoLoginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        [_weiBoLoginBtn setEnlargeEdgeWithTop:PADDING_5 right:PADDING_5 bottom:PADDING_20 left:PADDING_5];
        [_weiBoLoginBtn sizeToFit];
        [_weiBoLoginBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleRight imageTitleSpace:0];
    }
    return _weiBoLoginBtn;
}


- (UIImageView*)bubleImageView {
    if (!_bubleImageView) {
        _bubleImageView = [UIImageView new];
        UIImage *image = [UIImage hkdm_imageWithNameLight:@"login_buble" darkImageName:@"login_buble_dark"];
        if (IS_IPHONE5S) {
            image = [UIImage changeImageSize:image AndSize:CGSizeMake(65, 75/2)];
        }
        _bubleImageView.image = image;
        _bubleImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _bubleImageView;
}


- (void)loginAction:(UIButton*)sender {
    
    if (!self.isSelectAgree) {
        [self showLoginTipIV];
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(thirdPlatformLogin:)]) {
        [self.delegate thirdPlatformLogin:sender];
    }
}



- (void)showLoginTipIV {
    
    if (!self.isShowAgreeTip) {
        [self.loginTipIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.selectBtn.mas_top).offset(1);
            make.left.equalTo(self.selectBtn).offset(-29);
        }];
        self.loginTipIV.hidden = NO;
        self.isShowAgreeTip = YES;
        [self.loginTipIV setNeedsLayout];
        [self.loginTipIV layoutIfNeeded];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.loginTipIV.hidden = YES;
            self.isShowAgreeTip = NO;
        });
    }
}





- (UIButton*)customBtnWithTitle:(NSString *)title
                      imageName:(NSString *)imageName
                            tag:(NSInteger )tag {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_7B8196_A8ABBE forState:UIControlStateNormal];
    [btn.titleLabel setFont:HK_FONT_SYSTEM(14)];
    [btn setBackgroundImage:imageName(imageName) forState:UIControlStateNormal];
    [btn setBackgroundImage:imageName(imageName) forState:UIControlStateHighlighted];
    return  btn;
}





- (UIImageView*)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [UIImageView new];
        UIImage *image = [UIImage hkdm_imageWithNameLight:@"huke_login_text" darkImageName:@"huke_login_text_dark"];
        _logoImageView.image = image;
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _logoImageView;
}



- (HKWaterWaveView*)kywaterView {
    if (!_kywaterView) {
        CGFloat W = SCREEN_WIDTH - (IS_IPHONE5S ?-PADDING_15 :-PADDING_25)*2;
        _kywaterView = [[HKWaterWaveView alloc]initWithFrame:CGRectMake(0, 0, W, 350/2) type:waveTypeSinf];
    }
    return _kywaterView;
}



#pragma mark - 检查客户端是否安装 yes - 安装
- (BOOL)checkClientIsInstall:(NSInteger)clientCode {
    //    UMSocialPlatformType_QQ;  UMSocialPlatformType_WechatSession;   UMSocialPlatformType_Sina
    
    if (UMSocialPlatformType_WechatSession == clientCode) {
        return [WXApi isWXAppInstalled];
    }
    return [[UMSocialManager defaultManager]isInstall:clientCode];
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(agreementBtnClickAction:)]) {
        [self.delegate agreementBtnClickAction:btn];
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(privacyBtnClickAction:)]) {
        [self.delegate privacyBtnClickAction:btn];
    }
}




- (UIButton*)bgBtn {
    
    if (!_bgBtn) {
        _bgBtn =  [UIButton buttonWithTitle:nil titleColor:COLOR_A8AFB8 titleFont:@"12" imageName:nil];
        _bgBtn.backgroundColor = [UIColor grayColor];
    }
    return _bgBtn;
}







- (UILabel*)loginTipLB {

    if (!_loginTipLB) {
        _loginTipLB = [UILabel new];
        _loginTipLB.textColor = COLOR_27323F;
        _loginTipLB.font = HK_FONT_SYSTEM(13);
        _loginTipLB.textAlignment = NSTextAlignmentCenter;
        _loginTipLB.numberOfLines = 0;
        
        UIFont *font = HK_FONT_SYSTEM_WEIGHT(22, UIFontWeightSemibold);
        
        NSString *str = @"APP新人大礼包\n登录即可领取";
        NSMutableAttributedString *attributed = [NSMutableAttributedString changeFontAndColor:font Color:COLOR_27323F
                                                                                  TotalString:str
                                                                               SubStringArray:@[@"APP新人大礼包"]];

        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 3;
        style.alignment = NSTextAlignmentCenter;
        [attributed addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
        
        _loginTipLB.attributedText = attributed;
    }
    return _loginTipLB;
}



- (UILabel*)loginThemeLB {
    
    if (!_loginThemeLB) {
        _loginThemeLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_FF7820 titleFont:@"14" titleAligment:NSTextAlignmentCenter];
        _loginThemeLB.numberOfLines = 0;
        _loginThemeLB.hidden = YES;
    }
    return _loginThemeLB;
}



#pragma mark - 设置极验 登录文案
- (void)setLoginText:(NSString*)text isShowLoginGift:(BOOL)isShowLoginGift {
    
    _isShowLoginGift = isShowLoginGift;
    [self setLoginTheme:text];
}


- (void)setLoginTheme:(NSString*)text {
    self.loginThemeLB.hidden = NO;
    self.logoImageView.hidden = YES;
    
    NSString *str = nil;
    if (isEmpty(text)) {
        str = @"登录/注册";
    }else{
        str = [NSString stringWithFormat:@"登录/注册\n%@", text];
    }
    
    UIFont *font = HK_FONT_SYSTEM_WEIGHT(22, UIFontWeightSemibold);
    NSMutableAttributedString *attributed = [NSMutableAttributedString changeFontAndColor:font Color:COLOR_27323F
                                                                              TotalString:str
                                                                           SubStringArray:@[@"登录/注册"]];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 6;
    style.alignment = NSTextAlignmentCenter;
    [attributed addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
    
    // 字间距
    long number = 1;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributed addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(5,[text length])];
    CFRelease(num);
    
    self.loginThemeLB.attributedText = attributed;
}





/** 上次登录 气泡提示 */
- (void)lastLoginPattern {
    
    //登录方式 [0:手机 1:QQ,2:微信,3:微博 ]
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger type = [defaults integerForKey:HK_LOGIN_TYPE];
    
    if (type >= 1 && type <=4) {
        CGRect rect = [self getFrame:type];
        switch (type) {
            case 1:
                [self setBubble:self.qqLoginBtn rect:rect];
                break;
            case 2:
                [self setBubble:self.weChatLoginBtn rect:rect];
                break;
            case 3:
                //微博登陆 无需提示
                //[self setBubble:self.weiBoLoginBtn rect:rect];
                break;
            case 4:
                [self setBubble:self.phoneLoginBtn rect:rect];
                break;
            default:
                break;
        }
    }
}


- (CGRect)getFrame:(NSInteger)type {
    
    CGRect rect = CGRectZero;
    switch (type) {
        case 1:
            rect = self.qqLoginBtn.frame;
            break;
        case 2:
            rect = self.weChatLoginBtn.frame;
            break;
        case 3:
            rect = self.weiBoLoginBtn.frame;
            break;
        case 4:
            rect = self.phoneLoginBtn.frame;
            break;
    }
    return rect;
}



/** 设置气泡提示 */
- (void)setBubble:(id)sender rect:(CGRect)rect {
    
    if (sender && (0 != rect.size.width )) {
        [self addSubview:self.bubleImageView];
        [self.bubleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(((UIView*)sender).mas_top).offset(3);
            make.centerX.equalTo(((UIView*)sender).mas_centerX);
        }];
        
    }
}




- (UIImageView*)loginTipIV {
    if (!_loginTipIV) {
        _loginTipIV = [UIImageView new];
        _loginTipIV.image = imageName(@"ic_login_tip_v2_11");
        [_loginTipIV sizeToFit];
        _loginTipIV.hidden = YES;
    }
    return _loginTipIV;
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
    }
    return _selectBtn;
}


- (UIButton*)colseButton {
    if (!_colseButton) {
        _colseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *normalImage = [UIImage hkdm_imageWithNameLight:@"ic_close_v2_15" darkImageName:@"ic_close_v2_15_dark"];
        [_colseButton setImage:normalImage forState:UIControlStateNormal];
        [_colseButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_colseButton setEnlargeEdgeWithTop:5 right:5 bottom:35 left:35];
    }
    return _colseButton;
}


- (void)closeButtonAction:(UIButton*)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hkLoginView:closeButton:)]) {
        [self.delegate hkLoginView:self closeButton:btn];
    }
}


- (void)selectBtnBtnClick:(UIButton*)btn {
    btn.selected = !btn.selected;
    self.isSelectAgree = btn.selected;
}


- (void)dealloc {
    [self.kywaterView stop];
}


@end




