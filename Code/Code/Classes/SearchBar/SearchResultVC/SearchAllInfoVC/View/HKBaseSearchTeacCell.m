//
//  HKBaseSearchTeacCell.m
//  Code
//
//  Created by Ivan li on 2017/11/29.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKBaseSearchTeacCell.h"

@implementation HKBaseSearchTeacCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    //self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.videoCountLabel];
    
    [self.contentView addSubview:self.lineLabel];
    [self.contentView addSubview:self.fanCountLabel];
    [self.contentView addSubview:self.focusBtn];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    WeakSelf;
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(PADDING_20);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(PADDING_15);
        make.size.mas_equalTo(IS_IPHONE6PLUS ? CGSizeMake(PADDING_30*2, PADDING_30*2) : CGSizeMake(55, 55));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(PADDING_15);
        make.top.equalTo(weakSelf.iconImageView.mas_top).offset(7);
        make.right.equalTo(weakSelf.focusBtn.mas_left).offset(-PADDING_5);
    }];
    
    [_fanCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel.mas_left);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(7);
    }];
    
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.fanCountLabel.mas_centerY);
        make.left.equalTo(weakSelf.fanCountLabel.mas_right).offset(PADDING_10);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(1);
    }];
    
    [_videoCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.lineLabel.mas_right).offset(PADDING_10);
        make.top.height.equalTo(weakSelf.fanCountLabel);
    }];
    
    [_focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.iconImageView.mas_centerY);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-PADDING_15);
        make.size.mas_equalTo(CGSizeMake(PADDING_30*2, PADDING_25));
    }];
}


- (UIImageView*)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.userInteractionEnabled = YES;
        [_iconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarClick)]];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = (IS_IPHONE6PLUS ?30:27.5);
    }
    return _iconImageView;
}

- (void)avatarClick {
    
    UIView *hightLightedView = [[UIView alloc] init];
    hightLightedView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.8];
    hightLightedView.frame = _iconImageView.bounds;
    hightLightedView.tag = 520;
    [_iconImageView addSubview:hightLightedView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (NSEC_PER_SEC * 0.2)), dispatch_get_main_queue(), ^{
        [[_iconImageView viewWithTag:520] removeFromSuperview];
        !self.avatorClickBlock? : self.avatorClickBlock();
    });
}


- (UILabel*)lineLabel {
    if (!_lineLabel) {
        _lineLabel  = [UILabel new];
        UIColor *bgColor = [UIColor hkdm_colorWithColorLight:COLOR_F8F9FA dark:COLOR_7B8196];
        _lineLabel.backgroundColor = bgColor;
    }
    return _lineLabel;
}


- (UILabel*)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:nil
                                    titleColor:COLOR_27323F_EFEFF6
                                     titleFont:nil
                                 titleAligment:NSTextAlignmentLeft];
        _titleLabel.font = HK_FONT_SYSTEM_WEIGHT(16, UIFontWeightMedium);
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}



- (UILabel*)fanCountLabel {
    if (!_fanCountLabel) {
        _fanCountLabel  = [UILabel labelWithTitle:CGRectZero title:nil
                                       titleColor:COLOR_A8ABBE_7B8196
                                        titleFont:nil
                                    titleAligment:NSTextAlignmentLeft];
        _fanCountLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14:13];
        _fanCountLabel.numberOfLines = 1;
    }
    return _fanCountLabel;
}


- (UILabel*)videoCountLabel {
    if (!_videoCountLabel) {
        _videoCountLabel  = [UILabel labelWithTitle:CGRectZero title:nil
                                         titleColor:COLOR_A8ABBE_7B8196
                                          titleFont:nil
                                      titleAligment:NSTextAlignmentLeft];
        _videoCountLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14:13];
    }
    return _videoCountLabel;
}






- (UIButton*)focusBtn {
    if (!_focusBtn) {
        _focusBtn = [UIButton buttonWithTitle:@"关注" titleColor:COLOR_27323F_FFFFFF titleFont:@"14" imageName:nil];
        [_focusBtn setTitle:@"已关注" forState:UIControlStateSelected];
        [_focusBtn setTitleColor:COLOR_7B8196_27323F forState:UIControlStateSelected];
        //[_focusBtn setImage:imageName(@"add_sign_black") forState:UIControlStateNormal];
        // 设置关注按钮
        _focusBtn.clipsToBounds = YES;
        _focusBtn.layer.borderWidth = 0.5;
        _focusBtn.layer.cornerRadius = PADDING_25 * 0.5;
        _focusBtn.layer.borderColor = COLOR_27323F.CGColor;
        [_focusBtn addTarget:self action:@selector(focusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _focusBtn;
}


#pragma mark - 关注 讲师
- (void)focusBtnClick:(UIButton*)btn {
    CAKeyframeAnimation *anima = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    NSValue *value1 = [NSNumber numberWithFloat:1.0];
    NSValue *value2 = [NSNumber numberWithFloat:1.2];
    NSValue *value3 = [NSNumber numberWithFloat:1.0];
    anima.values = @[value1,value2,value3];
    anima.duration = 0.2;
    [btn.layer addAnimation:anima forKey:@"scale"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (NSEC_PER_SEC * anima.duration)), dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(focusTeacher:)]) {
            [self.delegate focusTeacher:btn];
        }
        isLogin() ? [self followTeacherToServer:btn] : nil;
    });
    
}



- (void)setUserInfo:(HKUserModel *)userInfo {
    _userInfo = userInfo;
    if (!isEmpty(userInfo.name)) {
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.avator] placeholderImage:imageName(HK_Placeholder)];
        _titleLabel.text = [NSString stringWithFormat:@"%@",userInfo.name];
        _fanCountLabel.text = [NSString stringWithFormat:@"粉丝: %@",userInfo.follow];
        _videoCountLabel.text = [NSString stringWithFormat:@"教程: %@",userInfo.curriculum_num];
        //is_follow:1-已关注讲师 0-未关注
        _focusBtn.selected = userInfo.is_follow;
        [self setFocusBtnStyle:_focusBtn isFollow:userInfo.is_follow];
    }
}


#pragma mark - 关注／取消关注  老师
- (void)followTeacherToServer:(UIButton*)btn{
    __block UIButton *tempBtn = btn;
    WeakSelf;
    FWNetWorkServiceMediator *mange = [FWNetWorkServiceMediator sharedInstance];
    //type ---当前的关注状态, 1已关注，0未关注
    [mange followTeacherVideoWithToken:nil teacherId:self.userInfo.teacher_id type:((self.userInfo.is_follow)? @"1":@"0")completion:^(FWServiceResponse *response) {
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            
            [MobClick event:UM_RECORD_DETAIL_CONCERN];
            tempBtn.selected = !tempBtn.selected;
            
            weakSelf.userInfo.is_follow = !weakSelf.userInfo.is_follow;
            [weakSelf setFocusBtnStyle:tempBtn isFollow:weakSelf.userInfo.is_follow];
            showTipDialog(weakSelf.userInfo.is_follow ? @"关注成功" : @"取消关注");
        }
    } failBlock:^(NSError *error) {
        
    }];
    
    
}


#pragma mark -设置 关注按钮 样式
- (void)setFocusBtnStyle:(UIButton *)btn isFollow:(BOOL)isFollow {
    
//    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0,isFollow ? -PADDING_5 : PADDING_5, 0, 0)];
//    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, isFollow ? -PADDING_30*2: -PADDING_5, 0, 0)];
//    [btn setBackgroundColor:isFollow ? COLOR_EFEFF6:[UIColor whiteColor]];
//    btn.layer.borderColor = isFollow ? COLOR_EFEFF6.CGColor :COLOR_27323F.CGColor;
    
    [btn setBackgroundColor:isFollow ? COLOR_EFEFF6_7B8196:COLOR_FFFFFF_3D4752];
    btn.layer.borderColor = isFollow ? COLOR_EFEFF6_7B8196.CGColor :COLOR_27323F_FFFFFF.CGColor;
}


- (void)dmTraitCollectionDidChange:(DMTraitCollection *)previousTraitCollection {
    if (@available(iOS 13.0, *)) {
        [self setFocusBtnBorderColor];
    }
}



- (void)setFocusBtnBorderColor {
    if (_focusBtn) {
        [self setFocusBtnStyle:_focusBtn isFollow:_focusBtn.selected];
    }
}

@end

