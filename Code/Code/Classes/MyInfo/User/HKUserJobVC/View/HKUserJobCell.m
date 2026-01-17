//
//  HKUserJobCell.m
//  Code
//
//  Created by Ivan li on 2018/6/5.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKUserJobCell.h"
#import "HKCellBottomView.h"


@implementation HKUserJobCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


+ (instancetype)initCellWithTableView:(UITableView *)tableView{
    
    HKUserJobCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKUserJobCell"];
    if (!cell) {
        cell = [[HKUserJobCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HKUserJobCell"];
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
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:imageName(@"arrow_right_gray")];
    self.accessoryView = imageView;
    
    [self.textLabel setTextColor:COLOR_27323F];
    [self.textLabel setFont:HK_FONT_SYSTEM(15)];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.cellBottomView];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-13);
        make.left.greaterThanOrEqualTo(self.contentView.mas_left).offset(PADDING_25*2);
    }];
    
    [_cellBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    [self hkDarkModel];
}


- (void)hkDarkModel {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.textLabel setTextColor:COLOR_27323F_EFEFF6];
    self.backgroundColor = COLOR_FFFFFF_3D4752;
}


- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE_7B8196
                                    titleFont:@"13" titleAligment:NSTextAlignmentRight];
    }
    return  _titleLabel;
}


- (HKCellBottomView*)cellBottomView {
    if (!_cellBottomView) {
        _cellBottomView = [HKCellBottomView new];
    }
    return _cellBottomView;
}



- (void)setTitle:(NSString *)title {
    _title = title;
    [_titleLabel setText:title];
}


@end
