
//
//  HKUserEditTitleCell.m
//  Code
//
//  Created by Ivan li on 2018/3/15.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKUserEditTitleCell.h"
#import "HKCellBottomView.h"


@implementation HKUserEditTitleCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


+ (instancetype)initCellWithTableView:(UITableView *)tableView{
    
    HKUserEditTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKEditTitleCell"];
    if (!cell) {
        cell = [[HKUserEditTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HKEditTitleCell"];
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
    //self.textLabel.text = @"昵称";
    [self.textLabel setTextColor:COLOR_27323F];
    [self.textLabel setFont:HK_FONT_SYSTEM(15)];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.cellBottomView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:imageName(@"arrow_right_gray")];
    self.accessoryView = imageView;
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-13);
        make.left.greaterThanOrEqualTo(self.contentView.mas_left).offset(PADDING_25*2);
    }];
    
    [_cellBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    [self.textLabel setTextColor:COLOR_27323F_EFEFF6];
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_FF6400
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


- (void)setIsBind:(BOOL)isBind {
    _isBind = isBind;
    //[_titleLabel setTextColor:isBind ?COLOR_A8ABBE :COLOR_FF6400];
    [_titleLabel setTextColor:isBind ?COLOR_A8ABBE_7B8196 :COLOR_FF6400];
}


@end
