//
//  HKAirPlayFailCell.m
//  Code
//
//  Created by Ivan li on 2019/5/6.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKAirPlayFailCell.h"


@interface HKAirPlayFailCell()

@property (nonatomic,strong) UILabel *bigTitleLb;

@property (nonatomic,strong) UILabel *firstLb;

@property (nonatomic,strong) UILabel *secondLb;

@property (nonatomic,strong) UILabel *thirdLb;

@end

@implementation HKAirPlayFailCell

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
        [self.contentView addSubview:self.bigTitleLb];
        [self.contentView addSubview:self.firstLb];
        [self.contentView addSubview:self.secondLb];
        [self.contentView addSubview:self.thirdLb];
        
        [self setValue];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bigTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(PADDING_15);
        make.left.equalTo(self.contentView).offset(PADDING_15);
        make.right.equalTo(self.contentView);
    }];
    
    [self.firstLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bigTitleLb.mas_bottom).offset(PADDING_15);
        make.left.equalTo(self.contentView).offset(PADDING_15);
        make.right.equalTo(self.contentView).offset(-PADDING_15);
    }];
    
    [self.secondLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstLb.mas_bottom).offset(PADDING_15);
        make.left.equalTo(self.contentView).offset(PADDING_15);
        make.right.equalTo(self.contentView).offset(-PADDING_15);
    }];
    
    [self.thirdLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondLb.mas_bottom).offset(PADDING_15);
        make.left.equalTo(self.contentView).offset(PADDING_15);
        make.right.equalTo(self.contentView).offset(-PADDING_15);
    }];
}



- (UILabel*)bigTitleLb {
    if (!_bigTitleLb) {
        _bigTitleLb = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F_EFEFF6 titleFont:@"18" titleAligment:NSTextAlignmentLeft];
        _bigTitleLb.font = HK_FONT_SYSTEM_BOLD(18);
    }
    return _bigTitleLb;
}

- (UILabel*)firstLb {
    if (!_firstLb) {
        _firstLb = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F_EFEFF6 titleFont:@"14" titleAligment:NSTextAlignmentLeft];
        _firstLb.numberOfLines = 2;
    }
    return _firstLb;
}


- (UILabel*)secondLb {
    if (!_secondLb) {
        _secondLb = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F_EFEFF6 titleFont:@"14" titleAligment:NSTextAlignmentLeft];
        _secondLb.numberOfLines = 2;
    }
    return _secondLb;
}

- (UILabel*)thirdLb {
    if (!_thirdLb) {
        _thirdLb = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F_EFEFF6 titleFont:@"14" titleAligment:NSTextAlignmentLeft];
        _thirdLb.numberOfLines = 2;
    }
    return _thirdLb;
}


- (void)setValue {
    
    self.bigTitleLb.text = @"为什么投屏失败？";
    
    self.firstLb.text = @"1、手机与电视没有连接到同一个WiFi下";
    
    self.secondLb.text = @"2、请查看智能电视/盒子设备说明，确保设备是否支持DLNA或Airplay协议";
    
    self.thirdLb.text = @"3、确认无法投屏后，手机可尝试进行镜像投屏";
}

@end
