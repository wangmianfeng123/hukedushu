//
//  HKSocialLoginView.m
//  Code
//
//  Created by ivan on 2020/6/17.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKSocialLoginView.h"
#import <UMShare/UMShare.h>

#import "UIButton+ImageTitleSpace.h"
#import "UIImage+Helper.h"
#import "HKWaterWaveView.h"
#import <CoreText/CoreText.h>
#import "UIView+LayoutSubviewsCallback.h"


@implementation HKSocialLoginView

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
//    [self addSubview:self.themeLB];
//    [self addSubview:self.leftLineView];
//    [self addSubview:self.rightLineView];
    [self addSubview:self.centerLineView];
    
    [self addSubview:self.qqLoginBtn];
    [self addSubview:self.weiBoLoginBtn];
    
    
    [self addSubview:self.qqTextLB];
    [self addSubview:self.weChatTextLB];
    
    [self addSubview:self.qqLoginTipLB];
    [self addSubview:self.weChatLoginTipLB];
    
    [self addSubview:self.weiBoLoginRoundBtn];
    
    BOOL isWechat = [self checkClientIsInstall:UMSocialPlatformType_WechatSession];
    if (isWechat) {
        [self addSubview:self.weChatLoginBtn];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self lastLoginPattern];
    });
    self.weiBoLoginRoundBtn.hidden = YES;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.weiBoLoginBtn.hidden = NO;
    if (HKSocialLoginViewType_phoneLogin == self.socialLoginViewType) {
        [self phoneLoginMakeConstraints];
    }else{
        [self oneLoginMakeConstraints];
    }
}



- (void)oneLoginMakeConstraints {
    
//    [self.themeLB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
//        make.top.equalTo(self).offset(PADDING_5);
//    }];
//
//    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.themeLB);
//        make.left.equalTo(self).offset(3);
//        make.right.equalTo(self.themeLB.mas_left).offset(-18);
//        make.height.mas_equalTo(1);
//    }];
//
//    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.themeLB);
//        make.right.equalTo(self).offset(-3);
//        make.left.equalTo(self.themeLB.mas_right).offset(18);
//        make.height.mas_equalTo(1);
//    }];
    
    [self.centerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(1, 1));
    }];
    
    BOOL isInstall = [self checkClientIsInstall:UMSocialPlatformType_WechatSession];
    self.weChatTextLB.hidden = !isInstall;
    
    if (isInstall) {
                
        [self.weChatLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(18);
            make.centerX.equalTo(self).offset(-15);
            make.size.mas_equalTo(CGSizeMake(23, 20));
        }];
        
        [self.weChatTextLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.weChatLoginBtn);
            make.left.equalTo(self.weChatLoginBtn.mas_right).offset(PADDING_5);
        }];
        
        [self.weChatLoginTipLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.weChatTextLB.mas_left);
            make.top.equalTo(self.weChatTextLB.mas_bottom).offset(PADDING_5);
            make.size.mas_equalTo(CGSizeMake(58, 26));
        }];
        
        [self.qqLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.weChatLoginBtn);
            make.left.equalTo(self.weChatTextLB.mas_right).offset(40);
            make.size.mas_equalTo(CGSizeMake(23, 20));
        }];
        
//        [self.weiBoLoginRoundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.weChatLoginBtn);
//            make.size.mas_equalTo(CGSizeMake(55, 19));
//            make.right.equalTo(self.weChatLoginBtn.mas_left).offset(-40);
//        }];
        [self.weiBoLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.weChatLoginBtn);
            make.right.equalTo(self.weChatLoginBtn.mas_left).offset(-40);
        }];
        
    }else{
                
        [self.qqLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.centerLineView.mas_right).offset(20);
            make.top.equalTo(self.mas_top).offset(18);
            make.size.mas_equalTo(CGSizeMake(23, 20));
        }];
        
//        [self.weiBoLoginRoundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.qqLoginBtn);
//            make.size.mas_equalTo(CGSizeMake(55, 19));
//            make.right.equalTo(self.centerLineView.mas_left).offset(-20);
//        }];
        [self.weiBoLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.qqLoginBtn);
            make.right.equalTo(self.centerLineView.mas_left).offset(-20);
        }];
    }
    
    [self.qqTextLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.qqLoginBtn);
        make.left.equalTo(self.qqLoginBtn.mas_right).offset(3);
    }];
    [self.qqLoginTipLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.qqTextLB.mas_left);
        make.top.equalTo(self.qqTextLB.mas_bottom).offset(PADDING_5);
        make.size.mas_equalTo(CGSizeMake(58, 26));
    }];
}


- (void)phoneLoginMakeConstraints {
    
//    [self.themeLB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
//        make.top.equalTo(self).offset(PADDING_5);
//    }];
//
//    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.themeLB);
//        make.left.equalTo(self).offset(PADDING_15);
//        make.right.equalTo(self.themeLB.mas_left).offset(-18);
//        make.height.mas_equalTo(1);
//    }];
//
//    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.themeLB);
//        make.right.equalTo(self).offset(-PADDING_15);
//        make.left.equalTo(self.themeLB.mas_right).offset(18);
//        make.height.mas_equalTo(1);
//    }];
    
    [self.centerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(1, 1));
    }];
    
//    BOOL isInstall = [self checkClientIsInstall:UMSocialPlatformType_WechatSession];
//
//    self.weChatTextLB.hidden = !isInstall;
//
//    if (isInstall) {
//        [self.weChatLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.themeLB.mas_bottom).offset(PADDING_25*2);
//            make.right.equalTo(self.centerLineView.mas_left).offset(-27);
//            make.size.mas_equalTo(CGSizeMake(40, 40));
//        }];
//
//        [self.weChatTextLB mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.weChatLoginBtn);
//            make.top.equalTo(self.weChatLoginBtn.mas_bottom).offset(PADDING_15);
//        }];
//
//        [self.qqLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.weChatLoginBtn);
//            make.left.equalTo(self.centerLineView.mas_right).offset(27);
//            make.size.mas_equalTo(CGSizeMake(40, 40));
//        }];
//
//    }else{
//
//        [self.qqLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self);
//            make.top.equalTo(self.themeLB.mas_bottom).offset(PADDING_25*2);
//            make.size.mas_equalTo(CGSizeMake(40, 40));
//        }];
//    }
//
//    [self.qqTextLB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.qqLoginBtn);
//        make.top.equalTo(self.qqLoginBtn.mas_bottom).offset(PADDING_15);
//    }];
//
//    [self.weiBoLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
//        make.top.equalTo(self.themeLB.mas_bottom).offset(109);
//    }];
    
    BOOL isInstall = [self checkClientIsInstall:UMSocialPlatformType_WechatSession];
    self.weChatTextLB.hidden = !isInstall;
    
    if (isInstall) {
                
        [self.weChatLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(PADDING_25*2);
            make.centerX.equalTo(self).offset(-15);
            make.size.mas_equalTo(CGSizeMake(23, 20));
        }];
        
        [self.weChatTextLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.weChatLoginBtn);
            make.left.equalTo(self.weChatLoginBtn.mas_right).offset(PADDING_5);
        }];
        
        [self.qqLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.weChatLoginBtn);
            make.left.equalTo(self.weChatTextLB.mas_right).offset(40);
            make.size.mas_equalTo(CGSizeMake(23, 20));
        }];
        
        [self.weiBoLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.weChatLoginBtn);
            make.right.equalTo(self.weChatLoginBtn.mas_left).offset(-40);
        }];
        
    }else{
                
        [self.qqLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.centerLineView.mas_right).offset(20);
            make.top.equalTo(self.mas_top).offset(PADDING_25*2);
            make.size.mas_equalTo(CGSizeMake(23, 20));
        }];
        
        [self.weiBoLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.qqLoginBtn);
            make.right.equalTo(self.centerLineView.mas_left).offset(-20);
        }];
    }
    
    [self.qqTextLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.qqLoginBtn);
        make.left.equalTo(self.qqLoginBtn.mas_right).offset(3);
    }];
}



#pragma mark - 检查客户端是否安装 yes - 安装
- (BOOL)checkClientIsInstall:(NSInteger)clientCode {
    //    UMSocialPlatformType_QQ;  UMSocialPlatformType_WechatSession;   UMSocialPlatformType_Sina
    if (UMSocialPlatformType_WechatSession == clientCode) {
        return [WXApi isWXAppInstalled];
    }
    return [[UMSocialManager defaultManager]isInstall:clientCode];
}



//- (UILabel *)themeLB {
//    if (!_themeLB) {
//        _themeLB = [UILabel labelWithTitle:CGRectZero title:@"社交账号登录" titleColor:COLOR_A8ABBE_7B8196 titleFont:@"14" titleAligment:NSTextAlignmentCenter];
//        [_themeLB sizeToFit];
//    }
//    return _themeLB;
//}



- (UILabel*)qqTextLB {
    if (!_qqTextLB) {
        _qqTextLB = [UILabel labelWithTitle:CGRectZero title:@"QQ" titleColor:COLOR_7B8196_A8ABBE titleFont:@"14" titleAligment:NSTextAlignmentCenter];
    }
    return _qqTextLB;
}


- (UIImageView*)qqLoginTipLB {
    if (!_qqLoginTipLB) {
        _qqLoginTipLB = [[UIImageView alloc] init];
        _qqLoginTipLB.image = [UIImage imageNamed:@"toast_sociallogin_2_33"];
//        _qqLoginTipLB = [UILabel labelWithTitle:CGRectZero title:@"上次登录" titleColor:COLOR_7B8196_A8ABBE titleFont:@"14" titleAligment:NSTextAlignmentCenter];
//        _qqLoginTipLB.backgroundColor = [UIColor redColor];
    }
    return _qqLoginTipLB;
}

- (UIImageView*)weChatLoginTipLB {
    if (!_weChatLoginTipLB) {
        _weChatLoginTipLB = [[UIImageView alloc] init];
        _weChatLoginTipLB.image = [UIImage imageNamed:@"toast_sociallogin_2_33"];
//        _weChatLoginTipLB = [UILabel labelWithTitle:CGRectZero title:@"上次登录" titleColor:COLOR_7B8196_A8ABBE titleFont:@"14" titleAligment:NSTextAlignmentCenter];
//        _weChatLoginTipLB.backgroundColor = [UIColor redColor];
    }
    return _weChatLoginTipLB;
}



- (UILabel*)weChatTextLB {
    if (!_weChatTextLB) {
        _weChatTextLB = [UILabel labelWithTitle:CGRectZero title:@"微信" titleColor:COLOR_7B8196_A8ABBE titleFont:@"14" titleAligment:NSTextAlignmentCenter];
    }
    return _weChatTextLB;
}



- (UIView*)centerLineView {
    if (!_centerLineView) {
        _centerLineView = [UIView new];
        _centerLineView.backgroundColor = [UIColor clearColor];
    }
    return _centerLineView;
}

//- (UIView*)leftLineView {
//    if (!_leftLineView) {
//        _leftLineView = [UIView new];
//        _leftLineView.backgroundColor = COLOR_EFEFF6_7B8196;
//    }
//    return _leftLineView;
//}
//
//
//- (UIView*)rightLineView {
//    if (!_rightLineView) {
//        _rightLineView = [UIView new];
//        _rightLineView.backgroundColor = COLOR_EFEFF6_7B8196;
//    }
//    return _rightLineView;
//}


- (UIButton *)qqLoginBtn {
    
    if (!_qqLoginBtn) {
        _qqLoginBtn =  [self customBtnWithTitle:nil imageName:@"ic_qq_2_v2_23" tag:102 ];
        [_qqLoginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        [_qqLoginBtn setTitleEdgeInsets:UIEdgeInsetsMake(75,0, 0, 0)];
        //[_qqLoginBtn setEnlargeEdgeWithTop:PADDING_5 right:PADDING_35 bottom:PADDING_20 left:PADDING_5];
        [_qqLoginBtn setHKEnlargeEdge:PADDING_35];
    }
    return _qqLoginBtn;
}



- (UIButton *)weChatLoginBtn {
    
    if (!_weChatLoginBtn) {
        _weChatLoginBtn = [self customBtnWithTitle:nil imageName:@"ic_wechat_2_v2_23"  tag:104 ];
        [_weChatLoginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        [_weChatLoginBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        // 未安装客户端 隐藏 WeChat
        _weChatLoginBtn.hidden = ![self checkClientIsInstall:UMSocialPlatformType_WechatSession];
        //[_weChatLoginBtn setEnlargeEdgeWithTop:PADDING_5 right:PADDING_35 bottom:PADDING_20 left:PADDING_5];
        [_weChatLoginBtn setHKEnlargeEdge:PADDING_35];
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


- (UIButton*)weiBoLoginRoundBtn {
    if (!_weiBoLoginRoundBtn) {
        _weiBoLoginRoundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _weiBoLoginRoundBtn.tag = 106;
        [_weiBoLoginRoundBtn setTitle:@"微博登录" forState:UIControlStateNormal];
        [_weiBoLoginRoundBtn setTitleColor:COLOR_7B8196_A8ABBE forState:UIControlStateNormal];
        [_weiBoLoginRoundBtn.titleLabel setFont:HK_FONT_SYSTEM(10)];
        
        _weiBoLoginRoundBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [_weiBoLoginRoundBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        [_weiBoLoginRoundBtn setEnlargeEdgeWithTop:PADDING_5 right:PADDING_5 bottom:PADDING_20 left:PADDING_5];
        
        _weiBoLoginRoundBtn.size = CGSizeMake(55, 19);
        _weiBoLoginRoundBtn.hidden = YES;
        
        [_weiBoLoginRoundBtn sizeToFit];
        CGRect rect = CGRectMake(0, 0, 55, 19);
        [_weiBoLoginRoundBtn setRoundedCorners:UIRectCornerAllCorners radius:14 rect:rect lineWidth:1 strokeColor:COLOR_7B8196_A8ABBE];
    }
    return _weiBoLoginRoundBtn;
}




- (void)loginAction:(UIButton*)sender {
    
    if (self.socialLoginBlock) {
        self.socialLoginBlock(sender);
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
    }
    return _bubleImageView;
}

/** 上次登录 气泡提示 */
- (void)lastLoginPattern {
    
//    if (HKSocialLoginViewType_phoneLogin == self.socialLoginViewType ) {
        //登录方式 [0:手机 1:QQ,2:微信,3:微博 ]
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSInteger type = [defaults integerForKey:HK_LOGIN_TYPE];
        
        if (type >= 1 && type <=4) {
            CGRect rect = [self getFrame:type];
            switch (type) {
                case 1:{
                    [self setBubble:self.qqLoginBtn rect:rect];
                    self.qqLoginTipLB.hidden = NO;
                    self.weChatLoginTipLB.hidden = YES;
                    break;
                }
                case 2:{
                    [self setBubble:self.weChatLoginBtn rect:rect];
                    self.qqLoginTipLB.hidden = YES;
                    self.weChatLoginTipLB.hidden = NO;
                }
                    break;
                case 3:{
                    self.qqLoginTipLB.hidden = YES;
                    self.weChatLoginTipLB.hidden = YES;
                    //微博登陆 无需提示
                    //[self setBubble:self.weiBoLoginBtn rect:rect];
                    break;
                }
                    
                case 4:{
                    self.qqLoginTipLB.hidden = YES;
                    self.weChatLoginTipLB.hidden = YES;
                    //[self setBubble:self.phoneLoginBtn rect:rect];
                    break;
                }
                    
                default:
                    break;
            }
        }else{
            self.qqLoginTipLB.hidden = YES;
            self.weChatLoginTipLB.hidden = YES;
        }
    
    if (HKSocialLoginViewType_oneLoginSdk == self.socialLoginViewType) {
        self.bubleImageView.hidden = YES;
    }
//    }
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
            //rect = self.phoneLoginBtn.frame;
            break;
    }
    return rect;
}

/** 设置气泡提示 */
- (void)setBubble:(id)sender rect:(CGRect)rect {
    CGFloat W = rect.size.width;
    if (sender && (0 != rect.size.width )) {
        [self addSubview:self.bubleImageView];
        [self.bubleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(((UIView*)sender).mas_top).offset(3);
            make.centerX.equalTo(((UIView*)sender)).offset(W/2);
        }];
    }
}

@end
