
//
//  SeriesCourseTagCell.m
//  Code
//
//  Created by Ivan li on 2017/10/26.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "SeriesCourseTagCell.h"
#import "SeriseCourseModel.h"


@interface SeriesCourseTagCell ()

@property(nonatomic,strong)UILabel     *tagLabel;
@property(nonatomic,strong)UIImageView     *angleImageView;

@end


@implementation SeriesCourseTagCell




- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.tagLabel];
    [self.contentView addSubview:self.angleImageView];
    WeakSelf;
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.contentView);
    }];
    [_angleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(weakSelf.contentView);
    }];
}



- (UILabel*)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_666666 titleFont:IS_IPHONE6PLUS ? @"16":@"14"
                                 titleAligment:NSTextAlignmentCenter];
    }
    return _tagLabel;
}



- (UIImageView*)angleImageView {
    
    if (!_angleImageView) {
        _angleImageView = [[UIImageView alloc]initWithImage:imageName(@"angle_right")];
        _angleImageView.hidden = YES;
    }
    return _angleImageView;
}

- (void)showAngleImage:(BOOL)isShow {
    _angleImageView.hidden = !isShow;
}

- (void)setModel:(SeriseTagModel *)model {
    _model = model;
    _tagLabel.text = model.name;
    _angleImageView.hidden = !model.isSelected;
    _tagLabel.textColor = model.isSelected ?COLOR_333333 :COLOR_666666;
    
}

@end
