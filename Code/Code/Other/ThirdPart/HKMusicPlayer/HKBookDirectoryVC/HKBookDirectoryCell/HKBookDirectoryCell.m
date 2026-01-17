//
//  HKBookDirectoryCell.m
//  Code
//
//  Created by Ivan li on 2019/7/16.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBookDirectoryCell.h"
#import "HKBookModel.h"


@interface HKBookDirectoryCell()

@property (strong, nonatomic)  UILabel *titleLB;

@end

@implementation HKBookDirectoryCell

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
        [self createUI];
    }
    return self;
}



- (void)createUI {
    [self.contentView addSubview:self.titleLB];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(PADDING_15);
        make.right.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
    }];
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F titleFont:@"15" titleAligment:NSTextAlignmentLeft];
    }
    return _titleLB;
}



- (void)setModel:(HKBookModel *)model {
    _model =  model;
    self.titleLB.text = model.title;

    // 设置看过的颜色
    if (model.is_study) {
        //已学
        self.titleLB.textColor = COLOR_A8ABBE;
    }else {
        // 未学
        self.titleLB.textColor = COLOR_27323F_EFEFF6;
    }
    if (model.is_playing) {
        self.titleLB.textColor = COLOR_FF3221;
    }
}


@end
