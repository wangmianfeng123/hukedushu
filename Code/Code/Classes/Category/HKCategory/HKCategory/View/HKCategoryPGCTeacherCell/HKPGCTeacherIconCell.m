//
//  HKPGCTeacherIconCell.m
//  Code
//
//  Created by Ivan li on 2018/4/16.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKPGCTeacherIconCell.h"
#import "HKCategoryTreeModel.h"


@interface HKPGCTeacherIconCell()

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIImageView *iconImageView;

@end



@implementation HKPGCTeacherIconCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.iconImageView];
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(12);
        make.left.equalTo(self.contentView).offset(1);
        make.size.mas_equalTo(CGSizeMake(60, 60));
        //make.right.equalTo(self.contentView).offset(-PADDING_35);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.iconImageView);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(PADDING_5);
        //make.left.equalTo(self.contentView);
    }];
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.iconImageView.layer.cornerRadius = self.iconImageView.height/2;
    });
}





- (UIImageView*)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        //_iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImageView.clipsToBounds = YES;
    }
    return _iconImageView;
}



- (UILabel*)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F
                                     titleFont:@"14" titleAligment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}




- (void)setChilderenModel:(HKcategoryChilderenModel *)childerenModel {
    
    _childerenModel = childerenModel;
    self.titleLabel.text = childerenModel.name;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:childerenModel.avator] placeholderImage:imageName(HK_Placeholder)];
    
}


@end






