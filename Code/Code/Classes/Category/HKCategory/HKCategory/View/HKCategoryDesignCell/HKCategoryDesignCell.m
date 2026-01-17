

//
//  HKCategoryDesignCell.m
//  Code
//
//  Created by Ivan li on 2018/12/18.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKCategoryDesignCell.h"
#import "HKCategoryTreeModel.h"
#import "UIView+SNFoundation.h"


@interface HKCategoryDesignCell()

@property(nonatomic,strong)UIImageView *iconImageView;
/** 软件标题 */
@property(nonatomic,strong)UILabel *titleLabel;
/** 课程数 */
@property(nonatomic,strong)UILabel *courseLabel;

@property(nonatomic,strong)UIImageView *bgIV;


@end



@implementation HKCategoryDesignCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];
    }
    return self;
}



- (void)createUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = PADDING_5;
    
    [self.contentView addSubview:self.bgIV];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.courseLabel];
    
    self.contentView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    self.courseLabel.textColor = COLOR_A8ABBE_7B8196;
    
    [self showOrHiddenBackGroundView];
}



- (void)dmTraitCollectionDidChange:(DMTraitCollection *)previousTraitCollection {
    if (@available(iOS 13.0, *)) {
        [self showOrHiddenBackGroundView];
    }
}


- (void)showOrHiddenBackGroundView {
    if (@available(iOS 13.0, *)) {
        UIColor *darkColor = nil;
        if (IS_IPAD) {
            self.bgIV.hidden = YES;
            darkColor = COLOR_333D48;
        }else{
            self.bgIV.hidden = (DMUserInterfaceStyleDark == DMTraitCollection.currentTraitCollection.userInterfaceStyle) ? NO :YES;
            darkColor = [UIColor clearColor];
        }
        UIColor *shadowColor = [UIColor hkdm_colorWithColorLight:[UIColor colorWithHexString:@"D6DFE5"]  dark:darkColor];
        [self addShadowWithColor:shadowColor alpha:0.4 radius:5 offset:CGSizeMake(0, 2)];

    }else{
        self.bgIV.hidden = YES;
        [self addShadowWithColor:[UIColor colorWithHexString:@"D6DFE5"] alpha:0.4 radius:5 offset:CGSizeMake(0, 2)];
    }
}




- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    [self.bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(5);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(PADDING_5);
        make.right.equalTo(self.contentView).offset(-2);
        make.top.equalTo(self.iconImageView);
    }];
    
    [self.courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView).offset(-2);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(7);
    }];
}



- (UIImageView*)bgIV {
    if (!_bgIV) {
        _bgIV = [[UIImageView alloc]init];
        _bgIV.contentMode = UIViewContentModeScaleAspectFill;
        _bgIV.image = imageName(@"bg_design_2_20");
        _bgIV.hidden = YES;
    }
    return _bgIV;
}



- (UIImageView*)iconImageView {
    if (!_iconImageView) {
        
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}



- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F
                                     titleFont:nil titleAligment:NSTextAlignmentLeft];
        
        _titleLabel.font = HK_FONT_SYSTEM_WEIGHT(15, UIFontWeightMedium);
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}



- (UILabel*)courseLabel {
    if (!_courseLabel) {
        _courseLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE
                                      titleFont:@"11" titleAligment:NSTextAlignmentLeft];
        _courseLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _courseLabel;
}


- (void)setChilderenModel:(HKcategoryChilderenModel *)childerenModel {
    
    _childerenModel = childerenModel;
    _titleLabel.text = childerenModel.name;
    _courseLabel.text = [NSString stringWithFormat:@"%@", childerenModel.string_1];
    [_iconImageView sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:childerenModel.img_url]) placeholderImage:imageName(HK_Placeholder)];
}


- (void)showBottomLine:(NSInteger)row {
    
}

- (void)injected {
    
    
}

@end




