//
//  HKHomeSoftwareCell.m
//  Code
//
//  Created by ivan on 2020/6/22.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKHomeSoftwareCell.h"
#import "SoftwareModel.h"

@implementation HKHomeSoftwareCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    
    [self.contentView addSubview:self.iconIV];
    [self.contentView addSubview:self.nameLB];
    
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.iconIV.mas_bottom).offset(8);
    }];
}


- (void)setModel:(SoftwareModel *)model {

    _model = model;
    self.nameLB.text = model.name;
    [self.iconIV sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:model.img_url]) placeholderImage:imageName(HK_Placeholder)];
}


- (UIImageView*)iconIV {
    if (!_iconIV) {
        _iconIV = [UIImageView new];
        _iconIV.clipsToBounds = YES;
        _iconIV.layer.cornerRadius = 20;
    }
    return _iconIV;
}

- (UILabel*)nameLB {
    if (!_nameLB) {
        _nameLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F_EFEFF6 titleFont:@"12" titleAligment:NSTextAlignmentCenter];
    }
    return _nameLB ;
}


@end
