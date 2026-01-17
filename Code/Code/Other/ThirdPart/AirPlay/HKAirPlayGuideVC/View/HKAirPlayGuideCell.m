//
//  HKAirPlayGuideCell.m
//  Code
//
//  Created by Ivan li on 2019/4/16.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKAirPlayGuideCell.h"

@implementation HKAirPlayGuideCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLB];
        [self.contentView addSubview:self.iconIV];
        [self.contentView addSubview:self.detailLB];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(PADDING_15);
        make.right.equalTo(self.contentView).offset(-PADDING_15);
    }];
    
    [self.detailLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLB.mas_bottom).offset(8);
        make.left.equalTo(self.contentView).offset(PADDING_15);
        make.right.equalTo(self.contentView).offset(-PADDING_15);
    }];
    
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.detailLB);
        make.top.equalTo(self.detailLB.mas_bottom).offset(8);
    }];
}



- (UILabel*)titleLB {
    if (!_titleLB) {
        _titleLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F_EFEFF6 titleFont:@"14" titleAligment:NSTextAlignmentLeft];
        _titleLB.numberOfLines = 0;
    }
    return _titleLB;
}


- (UIImageView*)iconIV {
    if (!_iconIV) {
        _iconIV = [UIImageView new];
        _iconIV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconIV;
}


- (UILabel*)detailLB {
    if (!_detailLB) {
        _detailLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_7B8196_A8ABBE titleFont:@"13" titleAligment:NSTextAlignmentLeft];
        _detailLB.numberOfLines = 0;
    }
    return _detailLB;
}





@end




