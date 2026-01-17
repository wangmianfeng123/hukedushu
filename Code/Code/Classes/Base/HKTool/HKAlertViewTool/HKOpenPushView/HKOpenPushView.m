//
//  HKOpenPushView.m
//  Code
//
//  Created by Ivan li on 2019/8/6.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKOpenPushView.h"
#import "LEEAlert.h"
#import "UIImage+Helper.h"
#import "UIImage+SNFoundation.h"
#import "UIView+SNFoundation.h"


@interface HKOpenPushView ()

@property (nonatomic , strong ) UIImageView *imageView; //图片

@property (nonatomic , strong ) UILabel *titleLabel; //标题

@property (nonatomic , strong ) UIButton *settingButton; //设置按钮

@property (nonatomic , strong ) UIButton *colseButton; //关闭按钮

@property (nonatomic , strong ) UIView *bgView; 

@end

@implementation HKOpenPushView


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        //初始化子视图
        [self initSubview];
    }
    return self;
}


- (void)initSubview {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bgView];
    [self addSubview:self.imageView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.settingButton];
    
    [self.imageView addSubview:self.colseButton];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(-35);
        make.left.bottom.right.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(19+25);
        make.left.equalTo(self.bgView).offset(38);
        make.right.equalTo(self.bgView).offset(-23);
    }];
    
    [self.colseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView).offset(55);
        make.right.equalTo(self.imageView).offset(-12);
    }];
    
    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(17);
        make.centerX.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(215, 38));
    }];
    [self.bgView setRoundedCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight radius:5];
}


- (UIView*)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.clipsToBounds = YES;
    }
    return _bgView;
}


- (UIImageView*)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:imageName(@"pic_push_v2_15")];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}


- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTitle:CGRectZero title:@"更多精品好课、设计资讯，第一时间告诉你~" titleColor:COLOR_27323F titleFont:@"15" titleAligment:0];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIButton*)settingButton {
    if (!_settingButton) {
        _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [_settingButton setTitle:@"好的，开启通知" forState:UIControlStateNormal];
        [_settingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_settingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_settingButton addTarget:self action:@selector(settingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIColor *color2 = [UIColor colorWithHexString:@"#FFB600"];
        UIColor *color1 = [UIColor colorWithHexString:@"#FFA300"];
        UIColor *color = [UIColor colorWithHexString:@"#FF8A00"];
        UIImage *image = [[UIImage alloc]createImageWithSize:CGSizeMake(215, 38) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.5),@(1)] gradientType:GradientFromLeftToRight];
        image = [image roundCornerImageWithRadius:19];
        
        [_settingButton setBackgroundImage:image forState:UIControlStateNormal];
        [_settingButton setBackgroundImage:image forState:UIControlStateHighlighted];
    }
    return _settingButton;
}

- (UIButton*)colseButton {
    if (!_colseButton) {
        _colseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_colseButton setImage:imageName(@"ic_close_v2_15") forState:UIControlStateNormal];
        [_colseButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_colseButton setHKEnlargeEdge:20];
    }
    return _colseButton;
}


- (void)settingButtonAction:(UIButton *)sender{
    
    [MobClick event:um_pop_notice_open];
    
    [LEEAlert closeWithCompletionBlock:^{
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if (HKSystemVersion > 10.0) {
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                    
                }];
            }
        }else{
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }];
}


#pragma mark - 关闭按钮点击事件
- (void)closeButtonAction:(UIButton *)sender {
    
    [MobClick event:um_pop_notice_close];
    if (self.closeBlock) self.closeBlock();
}

@end

