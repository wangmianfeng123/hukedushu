//
//  HKStudyLoginView.m
//  Code
//
//  Created by ivan on 2020/6/24.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKStudyLoginView.h"
#import <UMShare/UMShare.h>
#import "HKSocialLoginView.h"
#import "NSMutableAttributedString+HKAttributed.h"


@interface HKStudyLoginView()

@property (nonatomic,strong)HKSocialLoginView  *socialLoginView;
/** 注册协议 选择 按钮 */
@property(nonatomic,strong)UIButton *selectBtn;

@property(nonatomic,strong)UIButton *privacyBtn;
/** 注册协议 按钮 */
@property(nonatomic,strong)UIButton *agreementBtn;
/** 注册 按钮 */
@property(nonatomic,strong)UIButton  *registerBtn;
/** 其他手机 */
@property(nonatomic,strong)UIButton  *otherPhoneBtn;

@property(nonatomic,strong)UILabel *themeLB;

@property(nonatomic,strong)UIImageView *bubleImageView;

@end


@implementation HKStudyLoginView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self makeConstraints];
    [self lastLoginPattern];
}



- (void)createUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.themeLB];
    [self.contentView addSubview:self.registerBtn];
    [self.contentView addSubview:self.socialLoginView];
    
    [self.contentView addSubview:self.selectBtn];
    [self.contentView addSubview:self.privacyBtn];
    
    [self.contentView addSubview:self.agreementBtn];
    [self.contentView addSubview:self.otherPhoneBtn];
    
    [self.contentView addSubview:self.bubleImageView];
    
    [self racSignal];
//    [self.selectBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
}


/** 上次登录 气泡提示 */
- (void)lastLoginPattern {
    
    //登录方式 [0:手机 1:QQ,2:微信,3:微博 ]
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger type = [defaults integerForKey:HK_LOGIN_TYPE];
    if (4 == type) {
        self.bubleImageView.hidden = NO;
    }else{
        self.bubleImageView.hidden = YES;
    }
}



- (void)racSignal {

    @weakify(self);
    [[self.registerBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (self.selectBtn.selected) {
            
        }else{
            
        }
    }];
}



- (void)makeConstraints {
    
    [self.otherPhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(-20);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.bubleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.registerBtn.mas_top).offset(-10);
        make.centerX.equalTo(self.registerBtn);
    }];
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.otherPhoneBtn.mas_top).offset(-PADDING_30);
        make.centerX.equalTo(self.contentView);
    }];
    
    
    [self.themeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.registerBtn.mas_top).offset(-114);
        make.centerX.equalTo(self.contentView);
    }];
    
    
    [self.agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.otherPhoneBtn.mas_bottom).offset(30);
        make.centerX.mas_equalTo(- (self.privacyBtn.width/2 - (self.selectBtn.width+5)/2));
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.agreementBtn.mas_left);
        make.centerY.equalTo(self.agreementBtn);
        make.size.mas_equalTo(CGSizeMake(30, 50));
    }];
    
    [self.privacyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.agreementBtn);
        make.left.equalTo(self.agreementBtn.mas_right).offset(5);
    }];
    
    [self.socialLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(135+KTabBarHeight49+20);
    }];
}



- (UILabel*)themeLB {
    if (!_themeLB) {
        _themeLB = [UILabel labelWithTitle:CGRectZero title:@"登录查看我的学习记录" titleColor:COLOR_27323F_EFEFF6 titleFont:nil titleAligment:NSTextAlignmentCenter];
        _themeLB.font = HK_FONT_SYSTEM_BOLD(18);
    }
    return _themeLB;
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
        [_bubleImageView sizeToFit];
        _bubleImageView.hidden =  YES;
    }
    return _bubleImageView;
}



- (UIButton*)otherPhoneBtn {
    if (!_otherPhoneBtn) {
        _otherPhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSMutableAttributedString *text = [NSMutableAttributedString bottomLineAttributedString:@"其他手机"];
        [text addAttribute:NSForegroundColorAttributeName value:COLOR_7B8196_A8ABBE range:NSMakeRange(0, text.length)];
        [text addAttribute:NSFontAttributeName value:HK_FONT_SYSTEM(14) range:NSMakeRange(0, text.length)];
        [_otherPhoneBtn setAttributedTitle:text forState:UIControlStateNormal];
        [_otherPhoneBtn sizeToFit];
        [_otherPhoneBtn addTarget:self action:@selector(otherPhoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _otherPhoneBtn;
}



- (void)otherPhoneBtnClick:(UIButton*)btn {
    if (self.otherPhoneBtnClickBlock) {
        self.otherPhoneBtnClickBlock(btn);
    }
}



- (UIButton*)registerBtn {
    
    if (!_registerBtn) {
        
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerBtn.tag = 20;
        _registerBtn.clipsToBounds = YES;
        [_registerBtn.layer setCornerRadius:45*0.5];
        [_registerBtn.titleLabel setFont:HK_FONT_SYSTEM(17)];
        [_registerBtn setTitle:@"本机号码一键登录" forState:UIControlStateNormal];
        [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_registerBtn setTitleColor:COLOR_ffffff forState:UIControlStateNormal];
                
        UIColor *color2 = [UIColor colorWithHexString:@"#FFB600"];
        UIColor *color1 = [UIColor colorWithHexString:@"#FFA300"];
        UIColor *color = [UIColor colorWithHexString:@"#FF8A00"];
        
        UIImage *backgroundImage = [[UIImage alloc]createImageWithSize:CGSizeMake(280, 45) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
        [_registerBtn setBackgroundImage:backgroundImage forState:UIControlStateSelected];
        
//        UIImage *backgroundImage = [UIImage hkdm_imageWithNameLight:@"login_code_bg_enable" darkImageName:@"login_code_bg_enable_dark"];
        [_registerBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        
        [_registerBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
        // 取消高亮的点击状态
        [_registerBtn setAdjustsImageWhenHighlighted:NO];
        [_registerBtn sizeToFit];
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

-(void)setIsChose:(BOOL)isChose{
    _selectBtn.selected = isChose;
}

- (void)selectBtnBtnClick:(UIButton*)btn {
    btn.selected = !btn.selected;
//    if (self.checkBoxClickBlock) {
//        self.checkBoxClickBlock(btn);
//    }
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



- (void)registerAction:(UIButton*)sender {
    if (self.registerBtnClickBlock) {
        self.registerBtnClickBlock(sender);
    }
}



- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}


@end
