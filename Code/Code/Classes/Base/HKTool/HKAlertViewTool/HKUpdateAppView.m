//
//  HKUpdateAppView.m
//  Code
//
//  Created by Ivan li on 2019/8/7.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKUpdateAppView.h"
#import "LEEAlert.h"
#import "UIImage+Helper.h"
#import "UIImage+SNFoundation.h"
#import "HKVersionModel.h"
#import "UIView+SNFoundation.h"


@interface HKUpdateAppView ()

@property (nonatomic , strong ) UIImageView *upIV; //图片

@property (nonatomic , strong ) UIImageView *downIV; //图片

@property (nonatomic , strong ) UILabel *titleLabel; //标题

@property (nonatomic , strong ) UIButton *updateButton; //更新按钮

@property (nonatomic , strong ) UIButton *colseButton; //关闭按钮

@property (nonatomic , strong ) UIButton *quitButton; //取消升级按钮

@property (nonatomic , strong ) UITextView *textView;

@property (nonatomic , strong ) UIView *bgView;

@end

@implementation HKUpdateAppView


- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        //初始化子视图
        [self initSubview];
    }
    return self;
}


- (void)initSubview{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bgView];
    [self addSubview:self.upIV];
    [self addSubview:self.downIV];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.updateButton];
    [self.bgView addSubview:self.colseButton];
    [self.bgView addSubview:self.textView];
    [self.bgView addSubview:self.quitButton];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self).offset(45);
    }];
    
    [self.upIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.bgView.mas_top);
    }];
    
    [self.downIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.bgView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(73);
        make.left.right.equalTo(self.bgView);
    }];
    
    [self.colseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(6);
        make.right.equalTo(self.bgView).offset(-6);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(20);
        make.right.equalTo(self.bgView).offset(-20);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(17);
        make.height.mas_equalTo(75);
    }];
    
    [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.quitButton.mas_top).offset(-12);
        make.centerX.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(215, 38));
    }];
    
    [self.quitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-20);
        make.centerX.equalTo(self.bgView);
    }];
}


- (UIView*)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.clipsToBounds = YES;
        _bgView.layer.cornerRadius = 5;
    }
    return _bgView;
}



- (UIImageView*)upIV {
    if (!_upIV) {
        _upIV = [[UIImageView alloc] init];
        _upIV.image = imageName(@"pic_bulb_top_v2_15");
    }
    return _upIV;
}


- (UIImageView*)downIV {
    if (!_downIV) {
        _downIV = [[UIImageView alloc] init];
        _downIV.image = imageName(@"pic_bulb_down_v2_15");
    }
    return _downIV;
}


- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTitle:CGRectZero title:@"发现新版本" titleColor:COLOR_27323F titleFont:@"15" titleAligment:1];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = HK_FONT_SYSTEM_WEIGHT(18, UIFontWeightSemibold);
    }
    return _titleLabel;
}

- (UIButton*)updateButton {
    if (!_updateButton) {
        _updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_updateButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [_updateButton setTitle:@"立即更新" forState:UIControlStateNormal];
        [_updateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_updateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_updateButton addTarget:self action:@selector(updateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIColor *color2 = [UIColor colorWithHexString:@"#FFB600"];
        UIColor *color1 = [UIColor colorWithHexString:@"#FFA300"];
        UIColor *color = [UIColor colorWithHexString:@"#FF8A00"];
        UIImage *image = [[UIImage alloc]createImageWithSize:CGSizeMake(215, 38) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.5),@(1)] gradientType:GradientFromLeftToRight];
        image = [image roundCornerImageWithRadius:19];
        
        [_updateButton setBackgroundImage:image forState:UIControlStateNormal];
        [_updateButton setBackgroundImage:image forState:UIControlStateHighlighted];
    }
    return _updateButton;
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


- (UIButton*)quitButton {
    if (!_quitButton) {
        _quitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_quitButton setTitleColor:COLOR_7B8196 forState:UIControlStateNormal];
        [_quitButton setTitleColor:COLOR_7B8196 forState:UIControlStateHighlighted];
        NSString *content= @"暂不升级";
        NSMutableAttributedString *string = [NSMutableAttributedString bottomLineAttributedString:content];
        [string addAttribute:NSForegroundColorAttributeName value:COLOR_7B8196 range:NSMakeRange(0, content.length)];
        
        [_quitButton.titleLabel setFont: HK_FONT_SYSTEM(14)];
        [_quitButton setAttributedTitle:string forState:UIControlStateNormal];
        [_quitButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_quitButton setHKEnlargeEdge:20];
    }
    return _quitButton;
}


- (UITextView*)textView {
    
    if (!_textView) {
        _textView = [UITextView new];
        _textView.font = HK_FONT_SYSTEM(14);
        _textView.textColor = COLOR_27323F;
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.backgroundColor = [UIColor whiteColor];
        //_textView.textContainerInset = UIEdgeInsetsMake(PADDING_10, PADDING_20, 0, PADDING_20);
        _textView.editable = NO;
    }
    return _textView;
}



- (void)updateButtonAction:(UIButton *)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_STORE_URL]];
    if (self.updateBlock) self.updateBlock();
}


#pragma mark - 关闭按钮点击事件
- (void)closeButtonAction:(UIButton *)sender{
    if (self.closeBlock) self.closeBlock();
}



- (void)setModel:(HKVersionModel *)model {
    _model = model;
    //强制更新
    BOOL isForce = [model.force_update isEqualToString:@"2"];
    self.quitButton.hidden = isForce;
    self.colseButton.hidden = isForce;
    
    NSString *text = (isEmpty(model.update_info) ?@"有新的版本,请立即升级" :model.update_info);
    _textView.attributedText = [NSMutableAttributedString changeLineAndTextSpaceWithTotalString:text LineSpace:8 textSpace:0 font:14 titleColor:COLOR_27323F];
}

@end

