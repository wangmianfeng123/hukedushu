

//
//  HKNewUserSecondView.m
//  Code
//
//  Created by Ivan li on 2018/8/6.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKNewUserSecondView.h"
#import "HKNewUserCouponView.h"
#import "HKTagBtnTool.h"
#import "HKShareSucessView.h"
#import "HKHomeGiftModel.h"


@implementation HKNewUserSecondView


- (void)createUI {
    [super createUI];
    
    [self.waterBgView addSubview:self.couponBgView];
    [self.waterBgView addSubview:self.giftTagLB];
    [self.waterBgView addSubview:self.timeLB];
    
    [self.couponBgView addSubview:self.tagLB];
    [self.couponBgView addSubview:self.shareLB];

    [self.giftTagLB setTextColor:COLOR_27323F];
    [self.giftTagLB setFont:HK_FONT_SYSTEM_WEIGHT(22, UIFontWeightSemibold)];
    
    [self.tagLB setTextColor:COLOR_A8AFB8];
    self.tagLB.numberOfLines = 0;
    [self.tagLB setFont:HK_FONT_SYSTEM(12)];
    [self.tagLB setTextAlignment:NSTextAlignmentLeft];
    
    self.giftTagTitle = @"新人3日大礼包";
    [self.tagBtnTool setTagTitle:@"明日再来更惊喜哦~" fontSize:14];
    //self.bottomTagTitle = @"温馨提示：赠送VIP已过期，普通用户每日仅可看一个教程";
    
    [self addSubview:self.headIV];
}



- (void)setModel:(HKHomeGiftModel *)model {
    _model = model;
    
    _shareLB.text = isEmpty(model.share_data.desc_up)? @"" :model.share_data.desc_up;
    self.bottomTagTitle = isEmpty(model.share_data.desc_down)? @"" :model.share_data.desc_down;

    if (model.is_shared) {
        [self setShareSucessView];
        
    }else{
        // 分享
        for (SocialChannelModel *channelM in model.share_data.channel_list) {
            [self setPlatformWithModel:channelM];
        }
        
        if (self.array.count) {
            [self.array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:PADDING_25*2
                                         leadSpacing:PADDING_25 tailSpacing:PADDING_25];
            
            [self.array mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.shareLB.mas_bottom).offset(PADDING_25);
                make.size.mas_equalTo(CGSizeMake(PADDING_25*2, PADDING_25*2));
            }];
        }
    }
}




/** 创建可分享平台 */
- (void)setPlatformWithModel:(SocialChannelModel*)model {
    
    NSString *channel = model.channel;
    if ([channel isEqualToString:@"1"] ) {
        [self.array addObject:self.qqLoginBtn];
        [self.couponBgView addSubview:self.qqLoginBtn];
    }
    
    if ([channel isEqualToString:@"3"] ) {
        [self.array addObject:self.weChatLoginBtn];
        [self.couponBgView addSubview:self.weChatLoginBtn];
    }
    
    if ([channel isEqualToString:@"4"] ) {
        [self.array addObject:self.friendLoginBtn];
        [self.couponBgView addSubview:self.friendLoginBtn];
    }
    
    if ([channel isEqualToString:@"5"]) {
        [self.array addObject:self.weiBoLoginBtn];
        [self.couponBgView addSubview:self.weiBoLoginBtn];
    }
}





- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    [super makeConstraints];
    
    [self.headIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.giftTagLB.mas_top);
        make.centerX.equalTo(self.giftTagLB);
    }];
    
    [self.couponBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.waterBgView).offset(-PADDING_30);
        make.left.equalTo(self.waterBgView).offset(PADDING_30);
        make.height.mas_equalTo(415/2);
    }];
    
    [self.giftTagLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.timeLB.mas_top).offset(-3);
        make.right.left.equalTo(self.couponBgView);
    }];
    
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.couponBgView.mas_top).offset(-PADDING_10);
        make.right.left.equalTo(self.couponBgView);
    }];
    
    [self.shareLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.couponBgView).offset(PADDING_25);
        make.right.left.equalTo(self.couponBgView);
    }];
    
    [self.tagLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.couponBgView).offset(-12);
        make.left.equalTo(self.couponBgView).offset(20);
        make.right.equalTo(self.couponBgView).offset(-20);
    }];
    
}


- (NSMutableArray<UIButton*>*)array {
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}



- (UILabel*)shareLB {
    if (!_shareLB) {
        _shareLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_7B8196 titleFont:@"13" titleAligment:NSTextAlignmentCenter];
    }
    return _shareLB;
}


- (UILabel*)timeLB {
    if (!_timeLB) {
        _timeLB =  [UILabel labelWithTitle:CGRectZero title:@"第二天恭喜获得" titleColor:COLOR_27323F titleFont:@"13" titleAligment:NSTextAlignmentCenter];
    }
    return _timeLB;
}



- (UIButton *)qqLoginBtn {
    
    if (!_qqLoginBtn) {
        _qqLoginBtn =  [self customBtnWithTitle:@"QQ" imageName:@"qq_login" tag:102 ];
        [_qqLoginBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [_qqLoginBtn setTitleEdgeInsets:UIEdgeInsetsMake(75,0, 0, 0)];
        [_qqLoginBtn setEnlargeEdgeWithTop:PADDING_5 right:PADDING_5 bottom:PADDING_20 left:PADDING_5];
    }
    return _qqLoginBtn;
}



- (UIButton *)weChatLoginBtn {
    
    if (!_weChatLoginBtn) {
        _weChatLoginBtn = [self customBtnWithTitle:@"微信" imageName:@"weChat_login"  tag:104 ];
        [_weChatLoginBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [_weChatLoginBtn setTitleEdgeInsets:UIEdgeInsetsMake(75,0, 0, 0)];
        [_weChatLoginBtn setEnlargeEdgeWithTop:PADDING_5 right:PADDING_5 bottom:PADDING_20 left:PADDING_5];
    }
    return _weChatLoginBtn;
}



- (UIButton*)weiBoLoginBtn {
    if (!_weiBoLoginBtn) {
        _weiBoLoginBtn = [self customBtnWithTitle:@"微博" imageName:@"weibo"  tag:106];
        [_weiBoLoginBtn setTitleEdgeInsets:UIEdgeInsetsMake(75,0, 0, 0)];
        [_weiBoLoginBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [_weiBoLoginBtn setEnlargeEdgeWithTop:PADDING_5 right:PADDING_5 bottom:PADDING_20 left:PADDING_5];
    }
    return _weiBoLoginBtn;
}



- (UIButton *)friendLoginBtn {
    
    if (!_friendLoginBtn) {
        _friendLoginBtn = [self customBtnWithTitle:@"朋友圈" imageName:@"wechat_friend_1"  tag:108 ];
        [_friendLoginBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [_friendLoginBtn setTitleEdgeInsets:UIEdgeInsetsMake(75,0, 0, 0)];
        [_friendLoginBtn setEnlargeEdgeWithTop:PADDING_5 right:PADDING_5 bottom:PADDING_20 left:PADDING_5];
    }
    return _friendLoginBtn;
}



- (UIButton*)customBtnWithTitle:(NSString *)title
                      imageName:(NSString *)imageName
                            tag:(NSInteger )tag{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_A8ABBE forState:UIControlStateNormal];
    [btn.titleLabel setFont:HK_FONT_SYSTEM(13)];
    [btn setBackgroundImage:imageName(imageName) forState:UIControlStateNormal];
    [btn setBackgroundImage:imageName(imageName) forState:UIControlStateHighlighted];
    return  btn;
}



- (UIImageView*)headIV {
    
    if (!_headIV) {
        _headIV = [UIImageView new];
        _headIV.image = imageName( @"hk_gift_two");
        _headIV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _headIV;
}




#pragma mark - 检查客户端是否安装 yes - 安装
- (BOOL)checkClientIsInstall:(NSInteger)clientCode {
    return [[UMSocialManager defaultManager]isInstall:clientCode];
}


- (HKShareSucessView*)shareSucessView {
    if (!_shareSucessView) {
        _shareSucessView = [[HKShareSucessView alloc]init];
    }
    return _shareSucessView;
}


- (void)setShareSucessView {
    [self addSubview:self.shareSucessView];
    [self.shareSucessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shareLB.mas_bottom);
        make.left.right.equalTo(self.couponBgView);
        make.bottom.equalTo(self.tagLB.mas_top);
    }];
}

- (void)shareAction:(UIButton*)btn {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(newUserShare:btn:platform:)]) {
        NSInteger tag = btn.tag;
        UMSocialPlatformType platform = UMSocialPlatformType_UnKnown;
        
        switch (tag) {
            case 102:
                //QQ
            {
                platform = UMSocialPlatformType_QQ;
                if (![self checkClientIsInstall:platform]) {
                    showTipDialog(@"请安装先QQ客户端");
                    return;
                }
                break;
            }
            case 104:
                //微信
            {
                platform = UMSocialPlatformType_WechatSession;
                if (![self checkClientIsInstall:platform]) {
                    showTipDialog(@"请安装先微信客户端");
                    return;
                }
                break;
            }
            case 106:
                //微博
            {
                platform = UMSocialPlatformType_Sina;
                if (![self checkClientIsInstall:platform]) {
                    showTipDialog(@"请安装先微博客户端");
                    return;
                }
                break;
            }
                
            case 108:
                //朋友圈
            {
                platform = UMSocialPlatformType_WechatTimeLine;
                if (![self checkClientIsInstall:platform]) {
                    showTipDialog(@"请安装先微博客户端");
                    return;
                }
                break;
            }
        }
        
        [self.delegate newUserShare:self btn:btn platform:platform];
    }
}





@end





