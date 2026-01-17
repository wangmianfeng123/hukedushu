




//
//  HKAirPlayDeviceCell.m
//  Code
//
//  Created by Ivan li on 2019/5/6.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKAirPlayDeviceCell.h"


@interface HKAirPlayDeviceCell()

@property (nonatomic,strong) UILabel *titleLb;

@property (nonatomic,strong) UIView *line;

@property (nonatomic,strong)UIImageView *connectionStatusImageView;

@end



@implementation HKAirPlayDeviceCell

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
        [self.contentView addSubview:self.titleLb];
        [self.contentView addSubview:self.line];
        [self.contentView addSubview:self.connectionStatusImageView];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(74/2);
        make.right.centerY.equalTo(self.contentView);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.8);
    }];
    
    [self.connectionStatusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLb.mas_left).offset(-5);
        make.centerY.equalTo(self.titleLb);
    }];
}



- (UILabel*)titleLb {
    if (!_titleLb) {
        _titleLb = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F_EFEFF6 titleFont:@"14" titleAligment:NSTextAlignmentLeft];
        _titleLb.font = HK_FONT_SYSTEM_WEIGHT(14, UIFontWeightMedium);
    }
    return _titleLb;
}


- (UIView*)line {
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = COLOR_F8F9FA_333D48;
    }
    return _line;
}


- (UIImageView *)connectionStatusImageView{
    if (!_connectionStatusImageView) {
        _connectionStatusImageView = [UIImageView new];
    }
    return _connectionStatusImageView;
}



- (void)setTitleWithText:(NSString *)text  showStatusImage:(BOOL)showStatusImageView {
    self.titleLb.text = isEmpty(text)?@" " :text;
    self.connectionStatusImageView.image = showStatusImageView ? [UIImage imageNamed:@"ic_selected_v2_12"] :nil;
}


@end
