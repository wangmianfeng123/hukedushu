//
//  HKDropMenuCell.m
//  Code
//
//  Created by Ivan li on 2019/1/7.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKDropMenuCell.h"
#import "HKDropMenuModel.h"


@implementation HKDropMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.imgView];
    [self set_DMContentViewBGColor];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(PADDING_20);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-PADDING_20);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
        make.height.mas_equalTo(@1);
    }];
}


- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc]init];
        _imgView.image = [UIImage imageNamed:@"right_orange"];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.hidden = YES;
    }
    return _imgView;
}

- (UIView *)line {
    if (_line == nil) {
        _line = [[UIView alloc]init];
        //_line.backgroundColor = COLOR_F6F6F6;
        _line.backgroundColor = [UIColor hkdm_colorWithColorLight:COLOR_F6F6F6 dark:COLOR_333D48];
    }
    return _line;
}


- (UILabel *)title {
    if (_title == nil) {
        _title = [[UILabel alloc]init];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.font = [UIFont systemFontOfSize:14];
    }
    return _title;
}


- (void)setDropMenuModel:(HKDropMenuModel *)dropMenuModel {
    _dropMenuModel = dropMenuModel;
    self.title.text = dropMenuModel.title;
    self.title.textColor = dropMenuModel.cellSeleted ? COLOR_ff7c00 :COLOR_7B8196;
    self.imgView.hidden = !dropMenuModel.cellSeleted;
}


@end


