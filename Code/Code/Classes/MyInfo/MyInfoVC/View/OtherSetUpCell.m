//
//  OtherSetUpCell.m
//  Code
//
//  Created by pg on 2017/2/14.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "OtherSetUpCell.h"

@implementation OtherSetUpCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return  self;
}


- (void)createUI {
    self.imageView.contentMode = UIViewContentModeCenter;
    [self.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:self.lineLabel];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.textLabel.font = [UIFont systemFontOfSize:15.0];
    self.textLabel.textColor = COLOR_333333;
    WeakSelf;
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.15);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-0.15);
        make.left.right.equalTo(weakSelf);
        //make.left.equalTo(weakSelf.textLabel);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.size = CGSizeMake(18, 18);
    self.imageView.centerY = self.height * 0.5;
}


- (UILabel*)lineLabel {
    
    if (!_lineLabel) {
        _lineLabel = [UILabel new];
        _lineLabel.backgroundColor = COLOR_eeeeee;
    }
    return _lineLabel;
}


- (void)hideLine {
    
    self.lineLabel.hidden = YES;
}


@end
