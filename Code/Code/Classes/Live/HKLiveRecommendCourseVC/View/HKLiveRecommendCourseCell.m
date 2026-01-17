
//
//  HKLiveRecommendCourseCell.m
//  Code
//
//  Created by ivan on 2020/8/26.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKLiveRecommendCourseCell.h"
#import "HKLiveRecommendCourseModel.h"
#import "HKCoverBaseIV.h"
#import "HKCustomMarginLabel.h"
#import "UIView+SNFoundation.h"
#import "UIView+LayoutSubviewsCallback.h"
#import "UIView+Banner.h"


@implementation HKLiveRecommendCourseCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    self.contentView.backgroundColor = COLOR_FFFFFF_333D48;
    [self.contentView addSubview:self.coverIV];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.iconIV];
    
    [self.contentView addSubview:self.secondIconIV];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.countLB];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    [self.coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.left.equalTo(self.contentView).offset(15);;
        make.size.mas_equalTo(CGSizeMake(120, 74));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverIV);
        make.left.equalTo(self.coverIV.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.contentView);
    }];
    
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.coverIV);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.secondIconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(10);
        make.centerY.equalTo(self.iconIV);
        if (self.model.teachers.count>1) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }else{
            make.size.mas_equalTo(CGSizeZero);
        }
    }];

    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(5);
        make.centerY.equalTo(self.iconIV);
        make.right.lessThanOrEqualTo(self.countLB).offset(-1);
    }];
    
    [self.countLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconIV);
        make.right.equalTo(self.contentView).offset(-15);
    }];
}



- (HKCoverBaseIV*)coverIV {
    if (!_coverIV) {
        _coverIV = [[HKCoverBaseIV alloc]init];
        _coverIV.contentMode = UIViewContentModeScaleAspectFill;
        _coverIV.textLBHeight = 20;
        _coverIV.hasPictext = YES;
        _coverIV.hiddenText = NO;
        _coverIV.textFont = HK_FONT_SYSTEM(11);
        _coverIV.textInsets = UIEdgeInsetsMake(0, 13, 0, 0);
        _coverIV.size = (CGSizeMake(120, 74));
        [_coverIV addRoundedCornersWithRadius:5 byRoundingCorners:UIRectCornerAllCorners];
    }
    return _coverIV;
}


- (UIImageView*)iconIV {
    if (!_iconIV) {
        _iconIV = [[UIImageView alloc]init];
        _iconIV.clipsToBounds = YES;
        _iconIV.layer.cornerRadius = 10.0;
        _iconIV.size =CGSizeMake(20, 20);
        _iconIV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconIV;
}


- (UIImageView*)secondIconIV {
    if (!_secondIconIV) {
        _secondIconIV = [[UIImageView alloc]init];
        _secondIconIV.clipsToBounds = YES;
        _secondIconIV.layer.cornerRadius = 10.0;
        _secondIconIV.contentMode = UIViewContentModeScaleAspectFit;
        _secondIconIV.hidden = YES;
    }
    return _secondIconIV;
}






- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F_EFEFF6 titleFont:@"15" titleAligment:NSTextAlignmentLeft];
        _titleLabel.font = HK_FONT_SYSTEM_WEIGHT(15, UIFontWeightMedium);
    }
    return _titleLabel;
}

    
    
- (UILabel*)nameLabel {
    if (!_nameLabel) {
        _nameLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_7B8196_A8ABBE titleFont:@"12" titleAligment:NSTextAlignmentLeft];
        [_nameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _nameLabel;
}



- (UILabel*)countLB {
    if (!_countLB) {
        _countLB  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE_7B8196 titleFont:@"12" titleAligment:NSTextAlignmentLeft];
    }
    return _countLB;
}



    
- (void)setModel:(HKLiveRecommendCourseModel *)model {
    _model = model;
    
    _titleLabel.text = model.name;
    self.countLB.text = model.checkin_num;
    
//    if (DEBUG) {
//        HKUserModel *userM = [HKUserModel new];
//        userM.avator = model.teachers[0].avator;
//        [model.teachers addObject:userM];
//    }
    
    [model.teachers enumerateObjectsUsingBlock:^(HKUserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (0 == idx) {
            _nameLabel.text = model.teachers[0].name;
            [self.iconIV sd_setImageWithURL:HKURL(model.teachers[0].avator) placeholderImage:imageName(HK_Placeholder)];
        }
        if (1 == idx) {
            // 多个老师 则不显示昵称
            _nameLabel.text = nil;
            self.secondIconIV.hidden = NO;
            [self.secondIconIV sd_setImageWithURL:HKURL(model.teachers[1].avator) placeholderImage:imageName(HK_Placeholder)];
        }
    }];
    
    self.coverIV.textLB.text = model.start_live_at_cn;
    [self.coverIV sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:model.detail_cover]) placeholderImage:imageName(HK_Placeholder)];
}





@end




