
//
//  HKEditTagCell.m
//  Code
//／
//  Created by Ivan li on 2017/12/20.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKEditTagCell.h"
#import "HKCustomMarginLabel.h"
#import "HKCategoryAlbumModel.h"


@implementation HKEditTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)initCellWithTableView:(UITableView *)tableView{
    
    HKEditTagCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKEditTagCell"];
    if (!cell) {
        cell = [[HKEditTagCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HKEditTagCell"];
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
    self.textLabel.text = @"标签";
    [self.textLabel setTextColor:COLOR_333333];
    [self.textLabel setFont:HK_FONT_SYSTEM_BOLD(PADDING_15)];
    [self.contentView addSubview:self.firstLabel];
    [self.contentView addSubview:self.secondLabel];
    [self.contentView addSubview:self.thirdLabel];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    [_firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-13);
        //make.height.mas_equalTo(PADDING_20);
        //make.width.mas_greaterThanOrEqualTo(PADDING_25*2);
    }];
    
    [_secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(_firstLabel.mas_left).offset(-PADDING_10);
    }];
    
    [_thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(_secondLabel.mas_left).offset(-PADDING_10);
    }];
}


- (HKCustomMarginLabel*)firstLabel {
    if (!_firstLabel) {
        _firstLabel = [self setLabel];
    }
    return  _firstLabel;
}


- (HKCustomMarginLabel*)secondLabel {
    if (!_secondLabel) {
        _secondLabel = [self setLabel];
    }
    return  _secondLabel;
}

- (HKCustomMarginLabel*)thirdLabel {
    if (!_thirdLabel) {
        _thirdLabel = [self setLabel];
    }
    return  _thirdLabel;
}


- (HKCustomMarginLabel*)setLabel {
    
    HKCustomMarginLabel *label = [HKCustomMarginLabel new];
    label.textInsets = UIEdgeInsetsMake(0, 8, 0, 8); // 设置内边距
    label.font = HK_FONT_SYSTEM(12);
    //label.text = @"标签课";
    label.textColor = COLOR_999999;
    label.clipsToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 8;
    label.layer.borderWidth = 0.5;
    label.layer.borderColor = COLOR_dddddd.CGColor;
    label.adjustsFontSizeToFitWidth = YES;
    return label;
}



- (void)setModel:(HKCategoryAlbumModel *)model {
    
    NSInteger count =  model.labels.count;
    switch (count) {
        case 0:
            break;
        case 1:
            _firstLabel.text = model.labels[0].name;
            break;
        case 2:
            _firstLabel.text = model.labels[0].name;
            _secondLabel.text = model.labels[1].name;
            break;
        case 3:
            _firstLabel.text = model.labels[0].name;
            _secondLabel.text = model.labels[1].name;
            _thirdLabel.text = model.labels[2].name;
            break;
        default:
            break;
    }
}




@end









