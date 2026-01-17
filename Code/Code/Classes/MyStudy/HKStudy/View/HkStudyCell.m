//
//  OtherSetUpCell2.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/8.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HkStudyCell.h"

@interface HkStudyCell()

@end


@implementation HkStudyCell

- (UIView *)sep {
    if (_sep == nil) {
        UIView *sepView = [[UIView alloc] init];
        [self.contentView addSubview:sepView];
        sepView.backgroundColor = HKColorFromHex(0xF8F9FA, 1.0);
        _sep = sepView;
    }
    return _sep;
}

- (UIImageView *)leftImageV {
    if (_leftImageV == nil) {
        UIImageView *iv = [[UIImageView alloc] init];
        [self.contentView addSubview:iv];
        _leftImageV = iv;
    }
    return _leftImageV;
}

- (UILabel *)leftLab {
    if (_leftLab == nil) {
        UILabel *lb = [[UILabel alloc] init];
        [self.contentView addSubview:lb];
        lb.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
        lb.textColor = HKColorFromHex(0x0A1A39, 1.0);
        _leftLab = lb;
    }
    return _leftLab;
}

- (UIImageView *)rightImageV {
    if (_rightImageV == nil) {
        UIImageView *iv = [[UIImageView alloc] init];
        iv.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:iv];
        iv.image = imageName(@"arrow_right_gray");
        _rightImageV = iv;
    }
    return _rightImageV;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    [self.leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(20, 18));
        make.left.mas_equalTo(15.0);
    }];
    
    [self.leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.leftImageV);
        make.left.mas_equalTo(self.leftImageV.mas_right).offset(8.0);
    }];
    
    [self.rightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.right.mas_equalTo(self.contentView).offset(-10.0);;
    }];
    
    [self.sep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(1.0);
        make.left.mas_equalTo(self.leftImageV);
    }];
    
    [self set_DMContentViewBGColor];
    self.leftLab.textColor = [UIColor hkdm_colorWithColorLight:COLOR_0A1A39 dark:COLOR_EFEFF6];
    self.sep.backgroundColor = COLOR_F8F9FA_333D48;
}


@end

