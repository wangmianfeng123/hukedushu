//
//  SoftwareCell.m
//  Code
//
//  Created by Ivan li on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "SoftwareCell.h"
#import "SoftwareModel.h"


@interface SoftwareCell()

@property(nonatomic,strong)UIImageView     *iconImageView;
@property(nonatomic,strong)UILabel     *categoryLabel;

@property(nonatomic,strong)UILabel     *courseNumLabel;
@property(nonatomic,strong)UILabel     *exerciseNumLabel;
@property(nonatomic,strong)UILabel     *lineLabel;



@end


@implementation SoftwareCell

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
    self.tb_hightedLigthedIndex = CollectionViewIndexContentViewBack;
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.categoryLabel];
    
    [self.contentView addSubview:self.courseNumLabel];
    [self.contentView addSubview:self.exerciseNumLabel];
    [self.contentView addSubview:self.lineLabel];
}

- (void)makeConstraints {
    
    WeakSelf;
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(PADDING_15);
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.width.height.mas_lessThanOrEqualTo(PADDING_20*2);
    }];
    [_categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImageView.mas_bottom).offset(PADDING_15);
        make.centerX.equalTo(weakSelf.contentView);
        make.height.mas_lessThanOrEqualTo(PADDING_15);
    }];
    [_courseNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.categoryLabel.mas_bottom).offset(PADDING_10);
        make.right.equalTo(weakSelf.lineLabel.mas_left).offset(-8);
        make.left.equalTo(weakSelf.contentView);
        make.bottom.lessThanOrEqualTo(weakSelf.contentView.mas_bottom).offset(-PADDING_5);
    }];
    
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.5);
        make.height.equalTo(@12);
        make.centerY.equalTo(weakSelf.courseNumLabel);
        make.centerX.equalTo(weakSelf.contentView);
    }];
    
    [_exerciseNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(weakSelf.courseNumLabel);
        make.left.equalTo(weakSelf.lineLabel.mas_right).offset(8);
        make.right.equalTo(weakSelf.contentView);
    }];
}


- (UIImageView*)iconImageView {
    
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    return _iconImageView;
}



- (UILabel*)categoryLabel {
    
    if (!_categoryLabel) {
        _categoryLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_333333
                                        titleFont:IS_IPHONE6PLUS ?@"16" :@"14" titleAligment:NSTextAlignmentCenter];
    }
    return _categoryLabel;
}

- (UILabel*)courseNumLabel {
    
    if (!_courseNumLabel) {
        _courseNumLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_999999
                                        titleFont:IS_IPHONE6PLUS ?@"14" :@"12" titleAligment:NSTextAlignmentRight];
        _courseNumLabel.numberOfLines = 1;
    }
    return _courseNumLabel;
}


- (UILabel*)exerciseNumLabel {
    
    if (!_exerciseNumLabel) {
        _exerciseNumLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_999999
                                         titleFont:IS_IPHONE6PLUS ?@"14" :@"12" titleAligment:NSTextAlignmentLeft];
        _exerciseNumLabel.numberOfLines = 1;
    }
    return _exerciseNumLabel;
}


- (UILabel*)lineLabel {
    
    if (!_lineLabel) {
        _lineLabel  = [UILabel new];
        _lineLabel.backgroundColor = COLOR_999999;
    }
    return _lineLabel;
}



- (void)setModel:(SoftwareModel *)model {
    _model = model;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.small_img_url]] placeholderImage:imageName(HK_Placeholder)];
    _categoryLabel.text = model.name;
    _courseNumLabel.text = [NSString stringWithFormat:@"%@课",model.master_video_total];
    _exerciseNumLabel.text =[NSString stringWithFormat:@"%@练习", model.slave_video_total];
}



@end

















