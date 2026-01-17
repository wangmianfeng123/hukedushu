
//
//  HKEditTitleCell.m
//  Code
//
//  Created by Ivan li on 2017/12/20.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKEditTitleCell.h"

@implementation HKEditTitleCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


+ (instancetype)initCellWithTableView:(UITableView *)tableView{
    
    HKEditTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKEditTitleCell"];
    if (!cell) {
        cell = [[HKEditTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HKEditTitleCell"];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    self.textLabel.text = @"名称";
    [self.textLabel setTextColor:COLOR_27323F_EFEFF6];
    [self.textLabel setFont:HK_FONT_SYSTEM(PADDING_15)];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.rightIV];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.rightIV.mas_left).offset(-PADDING_15);
        make.left.greaterThanOrEqualTo(self.contentView.mas_left).offset(PADDING_25*2);
    }];
    
    [self.rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-PADDING_15);
    }];
}


- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F_EFEFF6
                                    titleFont:nil titleAligment:NSTextAlignmentRight];
        [_titleLabel setFont:HK_FONT_SYSTEM(15)];
    }
    return  _titleLabel;
}



- (UIImageView*)rightIV {
    if (!_rightIV) {
        _rightIV = [UIImageView new];
        _rightIV.contentMode = UIViewContentModeScaleAspectFit;
        _rightIV.image = imageName(@"arrow_right_gray");
    }
    return  _rightIV;
}


- (void)setTitle:(NSString *)title {
    _title = title;
    [_titleLabel setText:title];
}


@end
