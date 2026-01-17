
//
//  HKBaseTaskCell.m
//  Code
//
//  Created by Ivan li on 2018/7/15.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKBaseTaskCell.h"

@implementation HKBaseTaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (UIButton *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 20;
        //_iconImageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconImageView;
}


- (UILabel*)nameLabel {
    if (!_nameLabel) {
        _nameLabel  = [UILabel labelWithTitle:CGRectZero title:nil
                                    titleColor:COLOR_27323F
                                     titleFont:nil
                                 titleAligment:NSTextAlignmentLeft];
        _nameLabel.font = HK_FONT_SYSTEM_WEIGHT(14,UIFontWeightSemibold);
        _nameLabel.numberOfLines = 1;
        _nameLabel.userInteractionEnabled = YES;
    }
    return _nameLabel;
}



- (UILabel*)detailINfoLabel {
    if (!_detailINfoLabel) {
        _detailINfoLabel  = [UILabel labelWithTitle:CGRectZero title:nil
                                         titleColor:COLOR_27323F
                                          titleFont:nil
                                      titleAligment:NSTextAlignmentLeft];
        _detailINfoLabel.font = HK_FONT_SYSTEM(15);
        _detailINfoLabel.numberOfLines = 0;
        _detailINfoLabel.userInteractionEnabled = YES;
    }
    return _detailINfoLabel;
}



- (UILabel*)timeLabel {
    
    if (!_timeLabel) {
        _timeLabel  = [UILabel labelWithTitle:CGRectZero title:nil
                                   titleColor:COLOR_A8ABBE
                                    titleFont:nil
                                titleAligment:NSTextAlignmentRight];
        _timeLabel.font = HK_FONT_SYSTEM(12);
    }
    return _timeLabel;
}


- (UIImageView*)vipImageView {
    if (!_vipImageView) {
        _vipImageView = [UIImageView new];
        _vipImageView.contentMode = UIViewContentModeScaleAspectFit;
        _vipImageView.userInteractionEnabled = YES;
    }
    return _vipImageView;
}


- (UIImageView*)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [UIImageView new];
        _coverImageView.layer.masksToBounds = YES;
        _coverImageView.layer.cornerRadius = 5;
    }
    return _coverImageView;
}


@end






