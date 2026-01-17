//
//  HKCategoryLeftCell.m
//  Code
//
//  Created by Ivan li on 2018/4/13.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKCategoryLeftCell.h"
#import "HKCategoryTreeModel.h"
#import "HKLeftMenuModel.h"
#import "HKImageTextIV.h"
#import "UIView+HKLayer.h"

@interface HKCategoryLeftCell ()
@property (nonatomic, strong)HKImageTextIV *animationIV; // 正在播放的动画
@end

@implementation HKCategoryLeftCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubviews];
    }
    return self;
}


- (void)createSubviews {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.bottomLineView];
    [self.contentView addSubview:self.signLabel];
    [self.contentView addSubview:self.leftView];
    [self.contentView addSubview:self.animationIV];
    
    [self.animationIV addCornerRadius:7.5];
    [self.animationIV text:@"直播中" hiddenIfTextEmpty:NO];

    
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nameLabel.mas_left).offset(-7.5);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(4, 18));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-13);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.left.equalTo(@0);
        make.height.equalTo(@1);
    }];
    
    [self.signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(PADDING_5);
        make.right.equalTo(self.contentView.mas_right).offset(-1);
        make.size.mas_equalTo(CGSizeMake(36, 15));
    }];
    
    [self.animationIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(PADDING_5);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(@15);
        make.width.mas_equalTo(@60);
    }];
}


- (UILabel*)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = COLOR_7B8196;
        _nameLabel.font = HK_FONT_SYSTEM(15);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [_nameLabel sizeToFit];
    }
    return _nameLabel;
}


- (UIView*)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [UIView new];
        _bottomLineView.backgroundColor = [UIColor clearColor]; //COLOR_E7E7F0;
    }
    return _bottomLineView;
}


- (UILabel*)signLabel {
    if (!_signLabel) {
        UIColor *textColor = [UIColor hkdm_colorWithColorLight:COLOR_ffffff dark:COLOR_ffffff];
        _signLabel = [UILabel labelWithTitle:CGRectZero title:@"小白" titleColor:textColor titleFont:@"11" titleAligment:NSTextAlignmentCenter];
        _signLabel.backgroundColor = COLOR_FF3221;
        _signLabel.clipsToBounds = YES;
        _signLabel.layer.cornerRadius = 6.5;
        _signLabel.hidden = YES;
    }
    return _signLabel;
}

- (HKImageTextIV*)animationIV {
    if (!_animationIV) {
        _animationIV = [[HKImageTextIV alloc]init];
        _animationIV.isRemoveRoundedCorner = YES;
        _animationIV.liveAnimationType = HKCategaryAnimationType_liveList;
        _animationIV.textColor = [UIColor whiteColor];
        _animationIV.font = [UIFont systemFontOfSize:11];
        _animationIV.isCategoryLeftCell = YES;
    }
    return _animationIV;
}
- (void)setModel:(HKCategoryTreeModel *)model {
    _model = model;
    _signLabel.hidden = !model.isNew;
    if ([model.title isEqualToString:@"软件入门"]) {
        self.signLabel.text = @"小白";
    } else if ([model.title isEqualToString:@"虎课读书"]) {
        self.signLabel.text = @"New";
    }
    _nameLabel.text = model.title;
}

-(void)setMenuModel:(HKLeftMenuModel *)menuModel{
    _menuModel = menuModel;
    _signLabel.hidden = menuModel.corner_word.length ? NO : YES;
    _signLabel.text = menuModel.corner_word;
    _nameLabel.text = menuModel.name;
        
    self.animationIV.isAnimation = (menuModel.ID == 7 && [menuModel.has_free_living intValue] == 1) ? YES : NO;
    self.animationIV.hidden = (menuModel.ID == 7 && [menuModel.has_free_living intValue] == 1)  ? NO : YES;
    self.animationIV.font = [UIFont systemFontOfSize:11];
    if (menuModel.ID == 7 ) {
        _signLabel.hidden = [menuModel.has_free_living intValue] == 1 ? YES : NO;
    }

}


- (UIView*)leftView {
    if (!_leftView) {
        _leftView = [UIView new];
        _leftView.backgroundColor = COLOR_FFD305;
        _leftView.hidden = YES;
    }
    return _leftView;
}


- (void)setIsSelected:(BOOL)isSelected {
    [self setUIConfig:isSelected];
}


- (void)setUIConfig:(BOOL)selected {
    
    self.nameLabel.font = selected ? HK_FONT_SYSTEM_WEIGHT(15, UIFontWeightMedium) : HK_FONT_SYSTEM(15);
    //self.nameLabel.textColor = selected ?COLOR_27323F :COLOR_7B8196;
    //self.contentView.backgroundColor = selected ?[UIColor whiteColor] :COLOR_F8F9FA;
    self.leftView.hidden = !selected;
    
    self.nameLabel.textColor = selected ?COLOR_27323F_EFEFF6 :COLOR_7B8196;
    self.contentView.backgroundColor = selected ?COLOR_FFFFFF_3D4752 :COLOR_F8F9FA_333D48;
}



- (void)injected {
    
}

@end






