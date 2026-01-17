//
//  HKMyInfoSetChildCell.m
//  Code
//
//  Created by Ivan li on 2018/9/26.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKMyInfoSetChildCell.h"
#import "HKMyInfoUserModel.h"


@interface HKMyInfoSetChildCell()

@property (nonatomic, copy)NSString *iconUrl;

@end



@implementation HKMyInfoSetChildCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    [self.contentView addSubview:self.iconIV];
    [self.contentView addSubview:self.nameLB];
    [self.contentView addSubview:self.bridgeLB];
    [self hkDarkModel];
}

- (void)hkDarkModel {
    self.contentView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.nameLB.textColor = COLOR_27323F_EFEFF6;
}


//// 夜间模式主题模式 发生改变
//- (void)dmTraitCollectionDidChange:(DMTraitCollection *)previousTraitCollection {
//    if (@available(iOS 13.0, *)) {
//        [self hkDarkModel];
//    }
//}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView);
        //make.size.mas_lessThanOrEqualTo(CGSizeMake(70, 70));
        if (IS_IPHONE) {
            make.size.mas_equalTo(CGSizeMake(40 * Ratio, 40 * Ratio));
        }
        make.size.mas_lessThanOrEqualTo(CGSizeMake(40 * Ratio, 40 * Ratio));
    }];
    
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.iconIV);
        make.right.left.equalTo(self.contentView);
        make.top.equalTo(self.iconIV.mas_bottom).offset(0);
    }];
    
    [self.bridgeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIV.mas_top);
        make.width.mas_greaterThanOrEqualTo(16);
        make.right.equalTo(self.iconIV.mas_right).offset(8);
        make.right.mas_lessThanOrEqualTo(self.contentView).offset(-1).priority(100);
    }];
    
    [self.bridgeLB setNeedsLayout];
    [self.bridgeLB layoutIfNeeded];
    self.bridgeLB.layer.cornerRadius = self.bridgeLB.height/2;
}


- (UIImageView*)iconIV {
    if (!_iconIV) {
        _iconIV = [UIImageView new];
        _iconIV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconIV;
}


- (UILabel*)nameLB {
    if (!_nameLB) {
        _nameLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F titleFont:@"12" titleAligment:NSTextAlignmentCenter];
    }
    return _nameLB;
}


- (HKCustomMarginLabel*)bridgeLB {
    if (!_bridgeLB) {
        _bridgeLB = [[HKCustomMarginLabel alloc]init];
        _bridgeLB.font = HK_FONT_SYSTEM_WEIGHT(10, UIFontWeightMedium);
        _bridgeLB.textInsets = UIEdgeInsetsMake(2, 4, 2, 4);
        
        _bridgeLB.backgroundColor = COLOR_FF3221;
        _bridgeLB.textColor = [UIColor whiteColor];
        _bridgeLB.clipsToBounds = YES;
        _bridgeLB.textAlignment = NSTextAlignmentCenter;
    }
    return _bridgeLB;
}


- (void)setMapModel:(HKMyInfoMapPushModel *)mapModel {
    //mapModel.icon_message = @"99+";
    _mapModel = mapModel;
    _nameLB.text = mapModel.title;
    // 未登录 和 文本 为空 隐藏角标
    _bridgeLB.hidden = (isEmpty(mapModel.icon_message)|| [mapModel.icon_message isEqualToString:@"0"]|| !isLogin())  ? YES :NO;
    
    
    
    _bridgeLB.text = (isEmpty(mapModel.icon_message) || [mapModel.icon_message isEqualToString:@"0"])? nil :mapModel.icon_message;
    if ([mapModel.icon_message intValue]>99) {
        _bridgeLB.text = @"99+";
    }
    
    self.iconUrl = mapModel.icon;
    [_iconIV sd_setImageWithURL:HKURL(mapModel.icon) placeholderImage:nil];
    _nameLB.textColor = COLOR_27323F_EFEFF6;

//    if (DEBUG) {
//        [_iconIV sd_setImageWithURL:HKURL(mapModel.icon) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            if (error) {
//                NSLog(@"%@",error);
//            }
//        }];
//    }
}

@end




