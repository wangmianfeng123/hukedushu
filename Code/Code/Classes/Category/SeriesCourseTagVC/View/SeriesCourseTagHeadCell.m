
//
//  SeriesCourseTagHeadCell.m
//  Code
//
//  Created by Ivan li on 2017/10/26.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "SeriesCourseTagHeadCell.h"
#import "SeriseCourseModel.h"

@interface SeriesCourseTagHeadCell ()

@property(nonatomic,strong)UILabel     *courselabel;
@property(nonatomic,strong)UIImageView     *angleImageView;
@property(nonatomic,strong)UIView     *blankView;
@end


@implementation SeriesCourseTagHeadCell



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.courselabel];
    [self.contentView addSubview:self.angleImageView];
    [self.contentView addSubview:self.blankView];
    WeakSelf;
    [_courselabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(PADDING_15, PADDING_15, PADDING_30, PADDING_15));
    }];
    [_angleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(weakSelf.courselabel);
    }];
    [_blankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.courselabel.mas_bottom).offset(PADDING_15);
        make.bottom.left.right.equalTo(weakSelf.contentView);
    }];
}

- (UILabel*)courselabel {
    if (!_courselabel) {
        _courselabel = [UILabel labelWithTitle:CGRectZero title:@"全部教程" titleColor:COLOR_666666 titleFont:IS_IPHONE6PLUS ? @"18":@"16"
                                 titleAligment:NSTextAlignmentCenter];
        _courselabel.layer.borderColor = COLOR_dddddd.CGColor;
        _courselabel.layer.borderWidth = 0.5;
    }
    return _courselabel;
}

- (UIImageView*)angleImageView {
    
    if (!_angleImageView) {
        _angleImageView = [[UIImageView alloc]initWithImage:imageName(@"angle_right")];
        _angleImageView.hidden = YES;
    }
    return _angleImageView;
}

- (UIView*)blankView {
    
    if (!_blankView) {
        _blankView = [UIView new];
        _blankView.backgroundColor = COLOR_F6F6F6;
    }
    return _blankView;
}

- (void)setModel:(SeriseTagModel *)model {
    _model = model;
    _courselabel.text = model.name;
    _angleImageView.hidden = !model.isSelected;
}



@end


