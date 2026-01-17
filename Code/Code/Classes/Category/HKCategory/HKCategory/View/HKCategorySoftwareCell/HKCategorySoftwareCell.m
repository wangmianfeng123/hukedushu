//
//  HKCategorySoftwareCell.m
//  Code
//
//  Created by Ivan li on 2018/4/16.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKCategorySoftwareCell.h"
#import "HKCategoryTreeModel.h"


@interface HKCategorySoftwareCell()


@property(nonatomic,strong)UIImageView *iconImageView;
/** 软件标题 */
@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *bottomLineLabel;

@end



@implementation HKCategorySoftwareCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];
    }
    return self;
}



- (void)createUI {
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.bottomLineLabel];
}



- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(10);
        make.right.left.equalTo(self.contentView);
    }];
        
    [self.bottomLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
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
                                     titleFont:nil titleAligment:NSTextAlignmentCenter];
        _titleLabel.font = HK_FONT_SYSTEM_WEIGHT(12, UIFontWeightMedium);
    }
    return _titleLabel;
}



- (UILabel*)bottomLineLabel {
    if (!_bottomLineLabel) {
        _bottomLineLabel = [UILabel new];
        _bottomLineLabel.backgroundColor = COLOR_F8F9FA;
        _bottomLineLabel.hidden = YES;
    }
    return _bottomLineLabel;
}



- (void)setChilderenModel:(HKcategoryChilderenModel *)childerenModel {
    
    _childerenModel = childerenModel;
    _titleLabel.text = childerenModel.name;
    
    
    if (childerenModel.is_more) {
        UIImage *image = [UIImage hkdm_imageWithNameLight:@"ic_takeaplace_v2_18" darkImageName:@"ic_takeaplace_v2_18_dark"];
        _iconImageView.image = image;
    }else{
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:childerenModel.img_url]] placeholderImage: imageName(HK_Placeholder)];
    }
    
    _titleLabel.textColor = childerenModel.is_more ?COLOR_A8ABBE_7B8196 :COLOR_27323F_A8ABBE;
}


- (void)showBottomLine:(NSInteger)row {
    
    //_bottomLineLabel.hidden = (row == 0) ?YES :NO;
}


@end


