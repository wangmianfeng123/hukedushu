


//
//  HKMyInfoShareCell.m
//  Code
//
//  Created by Ivan li on 2018/9/26.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKMyInfoShareCell.h"
#import "UIView+SNFoundation.h"

@interface HKMyInfoShareCell()

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UIImageView *iconIV;

@property (nonatomic,strong) UILabel *intrLB;

@property (nonatomic,strong) UILabel *descLB;
/** 邀请用户 */
@property (nonatomic,strong) UIImageView *inviteUserIV;

@end



@implementation HKMyInfoShareCell



- (instancetype)initWithFrame:(CGRect)frame {
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
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.inviteUserIV];
    CGFloat inviteUserIVHeight = 50.0 * SCREEN_WIDTH / 375.0;
    [self.inviteUserIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(PADDING_15);
        make.right.equalTo(self.contentView).offset(-PADDING_15);
        make.height.mas_equalTo(inviteUserIVHeight);
    }];
    
//    [self.contentView addSubview:self.bgView];
//    [self.bgView addSubview:self.iconIV];
//    [self.bgView addSubview:self.intrLB];
//    [self.bgView addSubview:self.descLB];
}



- (void)makeConstraints {
    
//    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.contentView);
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 55));
//    }];
//
//    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.bgView);
//        make.left.equalTo(self.bgView).offset(23);
//    }];
//
//    [self.intrLB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.bgView);
//        make.left.equalTo(self.iconIV.mas_right).offset(25/2);
//    }];
//
//    [self.descLB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.bgView);
//        make.right.equalTo(self.bgView).offset(-18);
//    }];
}


- (UIView*)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        //_bgView.clipsToBounds = YES;
        _bgView.layer.cornerRadius = PADDING_10;
        _bgView.backgroundColor = [UIColor whiteColor];
        [_bgView addShadowWithColor:[UIColor colorWithHexString:@"#ecf0f4"] alpha:1 radius:2.5 offset:CGSizeMake(0, 1.0)];
    }
    return _bgView;
}




- (UIImageView*)inviteUserIV {
    if (!_inviteUserIV) {
        _inviteUserIV = [UIImageView new];
        _inviteUserIV.contentMode = UIViewContentModeScaleAspectFit;
        _inviteUserIV.image =  imageName(IS_IPAD ? @"ic_friend_share_ipad_v2_9" : @"ic_friend_share_v2_9");
    }
    return _inviteUserIV;
}



- (UIImageView*)iconIV {
    if (!_iconIV) {
        _iconIV = [UIImageView new];
        _iconIV.contentMode = UIViewContentModeScaleAspectFit;
        _iconIV.image = imageName(@"ic_friend_share");
    }
    return _iconIV;
}



- (UILabel*)intrLB {
    if (!_intrLB) {
        _intrLB = [UILabel labelWithTitle:CGRectZero title:@"邀请好友下载APP" titleColor:COLOR_27323F titleFont:@"14" titleAligment:NSTextAlignmentCenter];
    }
    return _intrLB;
}



- (UILabel*)descLB {
    if (!_descLB) {
        _descLB = [UILabel new];
        _descLB.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *attrString = [NSMutableAttributedString mutableAttributedString:@"有机会得虎课币  " font:HK_FONT_SYSTEM(11) titleColor:COLOR_7B8196 image:[UIImage imageNamed:@"ic_vip_go"] bounds:CGRectMake(0, 0, 5, 8)];
        _descLB.attributedText = attrString;
    }
    return _descLB;
}




@end







