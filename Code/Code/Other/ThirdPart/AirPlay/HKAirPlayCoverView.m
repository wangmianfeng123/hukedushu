
//
//  HKAirPlayCoverView.m
//  Code
//
//  Created by Ivan li on 2019/4/28.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKAirPlayCoverView.h"
#import "ZFHKNormalUtilities.h"



@interface HKAirPlayCoverView ()

@property (nonatomic,strong) UIImageView *headBgIV;
/** 连接状态 */
@property (nonatomic,strong) UILabel *stateLB;

@property (nonatomic,strong) UILabel *airNameLB;

@property (nonatomic,strong) UIButton *backBtn;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIImageView *bgIV;

@property (nonatomic,strong) UIButton *repeatBtn;
/** 不支持 投屏 提示 */
@property (nonatomic,strong) UILabel *tipLabel;

@end




@implementation HKAirPlayCoverView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


- (instancetype)init{
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    
    [self addSubview:self.bgIV];
    [self addSubview:self.headBgIV];
    
    [self addSubview:self.stateLB];
    [self addSubview:self.airNameLB];
    
    [self addSubview:self.quitBtn];
    [self addSubview:self.changeDeviceBtn];
    
    //[self.bgIV addSubview:self.quitBtn];
    //[self.bgIV addSubview:self.changeDeviceBtn];
    
    [self addSubview:self.backBtn];
    [self addSubview:self.titleLabel];
    [self addSubview:self.repeatBtn];
    
    [self addSubview:self.tipLabel];
    
    self.repeatBtn.hidden = YES;
    self.backgroundColor = [UIColor blackColor];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.headBgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(iPhoneX ? 15 :0);
        make.centerX.equalTo(self);
    }];
    
    [self.airNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.headBgIV);
        make.centerY.equalTo(self.headBgIV).offset(5);
    }];
    
    [self.stateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.airNameLB.mas_top).offset(-5);
        make.right.left.equalTo(self.airNameLB);
    }];
    
    if (self.isPickSucess) {
        if (self.isFullScreen) {
            [self.quitBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.bottom.equalTo(self.mas_bottom).offset(-80 );
                make.centerX.equalTo(self).offset(-47);
                make.centerY.equalTo(self).offset(-20);
                make.size.mas_equalTo(CGSizeMake(90, 27));
            }];
        }else{
            [self.quitBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.mas_bottom).offset(-45);
                make.centerX.equalTo(self).offset(-47);
                make.size.mas_equalTo(CGSizeMake(90, 27));
            }];
        }
        
        
        [self.changeDeviceBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.quitBtn);
            make.left.equalTo(self.quitBtn.mas_right).offset(4);
            make.size.mas_equalTo(CGSizeMake(90, 27));
        }];
    }else{
        [self.quitBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(self.isFullScreen ?-80 :-45);
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(90, 27));
        }];
    }
    
    [self.repeatBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.quitBtn.mas_top).offset(self.isFullScreen ?-30 :-15);
        make.size.mas_equalTo(CGSizeMake(90, 27));
    }];
    
    [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.quitBtn.mas_top).offset(self.isFullScreen ?-30 :-15);
        make.left.right.equalTo(self);
    }];

    CGFloat min_x = (iPhoneX && self.isFullScreen) ? 60: 15;
    CGFloat min_y = (iPhoneX ? 30 : 25);
    
    [self.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(min_y);
        make.left.equalTo(self).offset(min_x);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.backBtn.mas_trailing).offset(15);
        make.centerY.equalTo(self.backBtn.mas_centerY);
        make.width.mas_lessThanOrEqualTo(IS_IPHONE5S ?300 :400);
    }];
    
    //self.titleLabel.hidden = !self.isFullScreen;
    self.titleLabel.hidden = YES;
    self.headBgIV.image = imageName(self.isFullScreen ?@"bg_video_big_tv_v2_12" :@"bg_video_small_tv_v2_12");
}



- (UIImageView*)bgIV {
    if (!_bgIV) {
        _bgIV = [UIImageView new];
        _bgIV.backgroundColor = [UIColor blackColor];
    }
    return _bgIV;
}


- (UIImageView*)headBgIV {
    if (!_headBgIV) {
        _headBgIV = [UIImageView new];
    }
    return _headBgIV;
}


- (UILabel*)airNameLB {
    if (!_airNameLB) {
        _airNameLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE titleFont:@"14" titleAligment:NSTextAlignmentCenter];
    }
    return _airNameLB;
}



- (UILabel*)stateLB {
    if (!_stateLB) {
        _stateLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:[UIColor whiteColor] titleFont:@"18" titleAligment:NSTextAlignmentCenter];
        _stateLB.font = HK_FONT_SYSTEM_BOLD(18);
    }
    return _stateLB;
}



- (UIButton*)quitBtn {
    if (!_quitBtn) {
        _quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_quitBtn setTitle:@"退出投屏" forState:UIControlStateNormal];
        [_quitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_quitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        _quitBtn.titleLabel.font = HK_FONT_SYSTEM(14);
        [_quitBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_quitBtn sizeToFit];
        //[_quitBtn setHKEnlargeEdge:30];
        
        [_quitBtn setBackgroundImage:imageName(@"ic_route_v211") forState:UIControlStateNormal];
        [_quitBtn setBackgroundImage:imageName(@"ic_route_v211") forState:UIControlStateHighlighted];
        _quitBtn.tag = 20;
    }
    return _quitBtn;
}


- (UIButton*)changeDeviceBtn {
    if (!_changeDeviceBtn) {
        _changeDeviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeDeviceBtn setTitle:@"换设备" forState:UIControlStateNormal];
        [_changeDeviceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _changeDeviceBtn.titleLabel.font = HK_FONT_SYSTEM(14);
        [_changeDeviceBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_changeDeviceBtn sizeToFit];
        //[_changeDeviceBtn setHKEnlargeEdge:35];
        _changeDeviceBtn.tag = 30;
        
        [_changeDeviceBtn setBackgroundImage:imageName(@"ic_route_right_v211") forState:UIControlStateNormal];
        [_changeDeviceBtn setBackgroundImage:imageName(@"ic_route_right_v211") forState:UIControlStateHighlighted];
        _changeDeviceBtn.hidden = YES;
    }
    return _changeDeviceBtn;
}



- (UIButton *)repeatBtn {
    if (!_repeatBtn) {
        _repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_repeatBtn setImage:imageName(@"ic_refresh_yellow_v2_12") forState:UIControlStateNormal];
        [_repeatBtn setImage:imageName(@"ic_refresh_yellow_v2_12") forState:UIControlStateHighlighted];
        [_repeatBtn setTitle:@"重新连接" forState:UIControlStateNormal];
        [_repeatBtn setTitleColor:COLOR_FFD305 forState:UIControlStateNormal];
        [_repeatBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_repeatBtn setHKEnlargeEdge:5];
        _repeatBtn.tag = 40;
        _repeatBtn.titleLabel.font = HK_FONT_SYSTEM(12);
    }
    return _repeatBtn;
}



- (void)btnClick:(UIButton*)btn {
    
    NSInteger tag = btn.tag;
    if (20 == tag) {
        //退出
        if (self.delegate && [self.delegate respondsToSelector:@selector(hKAirPlayCoverView:quitBtn:)]) {
            [self.delegate hKAirPlayCoverView:self quitBtn:btn];
        }
        
    }else if (30 == tag) {
        //切换设备
        if (self.delegate && [self.delegate respondsToSelector:@selector(hKAirPlayCoverView:changeDeviceBtn:)]) {
            [self.delegate hKAirPlayCoverView:self changeDeviceBtn:btn];
        }
    }else if (40 == tag) {
        // 重新连接
        if (self.delegate && [self.delegate respondsToSelector:@selector(hKAirPlayCoverView:repeatBtn:)]) {
            [self.delegate hKAirPlayCoverView:self repeatBtn:btn];
        }
    }
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = HK_FONT_SYSTEM(15);
    }
    return _titleLabel;
}




- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = COLOR_FFD305;
        _tipLabel.font = HK_FONT_SYSTEM(12);
        _tipLabel.text = @"已下载的视频，暂不支持投屏播放。";
        _tipLabel.hidden = YES;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}



- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:imageName(@"nac_back_white") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setHKEnlargeEdge:30];
        _backBtn.hidden = YES;
    }
    return _backBtn;
}


- (void)backButtonClickAction:(UIButton*)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(hKAirPlayCoverView:backBtn:)]) {
        [self.delegate hKAirPlayCoverView:self backBtn:sender];
    }
}




- (void)changeStateWithText:(NSString*)text {
    
    self.stateLB.text = text;
}


- (void)setPortNameWithText:(NSString*)text {
    
    self.airNameLB.text = text;
}


- (void)setTitleWithText:(NSString*)text {
    
    self.titleLabel.text = text;
}


- (void)setIsPickSucess:(BOOL)isPickSucess {
    _isPickSucess = isPickSucess;
    [self.quitBtn setBackgroundImage:imageName(isPickSucess ?@"ic_route_left_v211" : @"ic_route_v211") forState:UIControlStateNormal];
    [self.quitBtn setBackgroundImage:imageName(isPickSucess ?@"ic_route_left_v211" :@"ic_route_v211") forState:UIControlStateHighlighted];
    
    self.changeDeviceBtn.hidden = !isPickSucess;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setIsDownFinish:(BOOL)isDownFinish {
    _isDownFinish = isDownFinish;
    self.tipLabel.hidden = !isDownFinish;
}



@end



