//
//  HKAudioTeachView.m
//  Code
//
//  Created by Ivan li on 2018/3/27.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKAudioTeachView.h"


@implementation HKAudioTeachView


- (instancetype)init {
    
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {

    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.focusBtn];
    [self addClickGesture];
}



- (void)addClickGesture {
    UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avatarClick)];
    [self addGestureRecognizer:gest];
}


- (void)removeView {
    //移除手势
    for (UIGestureRecognizer *ges in self.gestureRecognizers) {
        [self removeGestureRecognizer:ges];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    // 100
    WeakSelf;
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(PADDING_10);
        make.left.equalTo(weakSelf.mas_left).offset(PADDING_15);
        make.size.mas_equalTo(CGSizeMake(PADDING_30, PADDING_30));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(PADDING_10);
        make.centerY.equalTo(weakSelf.iconImageView);
        make.right.equalTo(weakSelf.focusBtn.mas_left).offset(-PADDING_5);
    }];
    
    
    [_focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.iconImageView.mas_centerY);
        make.right.equalTo(weakSelf.mas_right).offset(-PADDING_15);
        make.height.mas_equalTo(22);
        //make.size.mas_equalTo(CGSizeMake(PADDING_25*2, 22));
    }];
}


- (UIImageView*)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.userInteractionEnabled = YES;
        //[_iconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarClick)]];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = PADDING_15;
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



- (UILabel*)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:nil
                                    titleColor:[UIColor whiteColor]
                                     titleFont:nil
                                 titleAligment:NSTextAlignmentLeft];
        _titleLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 15:14];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}



- (UIButton*)focusBtn {
    if (!_focusBtn) {
        _focusBtn = [UIButton buttonWithTitle:@"关注" titleColor:COLOR_ffffff titleFont:@"14" imageName:nil];
        [_focusBtn setTitle:@"已关注" forState:UIControlStateSelected];
        [_focusBtn setTitleColor:[COLOR_ffffff colorWithAlphaComponent:0.6] forState:UIControlStateSelected];
        
        // 设置关注按钮
        _focusBtn.clipsToBounds = YES;
        _focusBtn.layer.borderWidth = 1;
        _focusBtn.layer.cornerRadius = 11;
        _focusBtn.layer.borderColor = COLOR_ffffff.CGColor;
        _focusBtn.backgroundColor = [UIColor clearColor];
        [_focusBtn addTarget:self action:@selector(focusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //内容边距
        _focusBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 9, 0, 9);
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
        //is_follow:1-已关注讲师 0-未关注
        _focusBtn.selected = userInfo.is_follow;
        [self setFocusBtnStyle:self.focusBtn isFollow:userInfo.is_follow];
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
    
    btn.layer.borderColor = isFollow ? [COLOR_ffffff colorWithAlphaComponent:0.6].CGColor :COLOR_ffffff.CGColor;
}


@end
