
//
//  HKJobSelectCell.m
//  Code
//
//  Created by Ivan li on 2018/6/5.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKJobSelectCell.h"
#import "HKCellBottomView.h"


@implementation HKJobSelectCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


+ (instancetype)initCellWithTableView:(UITableView *)tableView{
    
    HKJobSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKJobSelectCell"];
    if (!cell) {
        cell = [[HKJobSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HKJobSelectCell"];
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
    
    [self.textLabel setTextColor:COLOR_27323F_EFEFF6];
    //[self.textLabel setTextColor:COLOR_27323F];
    [self.textLabel setFont:HK_FONT_SYSTEM(15)];
    
    [self.contentView addSubview:self.cellBottomView];
    [self.contentView addSubview:self.rightIV];
    
    [_cellBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    [_rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-16);
    }];
}


- (HKCellBottomView*)cellBottomView {
    if (!_cellBottomView) {
        _cellBottomView = [HKCellBottomView new];
    }
    return _cellBottomView;
}


- (UIImageView*)rightIV {
    if (!_rightIV) {
        _rightIV = [UIImageView new];
        _rightIV.contentMode = UIViewContentModeScaleAspectFit;
        _rightIV.image = imageName(@"hook_blue");
        _rightIV.hidden = YES;
    }
    return _rightIV;
}



- (void)setIsSelectJob:(BOOL)isSelectJob {
    _isSelectJob = isSelectJob;
    _rightIV.hidden = !isSelectJob;
}

@end





