//
//  HKAPPInfoCell.m
//  Code
//
//  Created by Ivan li on 2019/7/3.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKAPPInfoCell.h"

@implementation HKAPPInfoCell

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
        [self.contentView addSubview:self.infoLB];
        
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(PADDING_15);
    }];
    
    [self.infoLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-PADDING_15);
        make.centerY.equalTo(self.contentView);
    }];
}



- (UILabel*)titleLB {
    if (!_titleLB) {
        _titleLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F titleFont:@"15" titleAligment:0];
    }
    return _titleLB;
}



- (UILabel*)infoLB {
    if (!_infoLB) {
        _infoLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F titleFont:@"12" titleAligment:0];
    }
    return _infoLB;
}



- (void)setTitle:(NSString*)title  info:(NSString*)info {
    _titleLB.text = title;
    _infoLB.text = info;
}


@end

