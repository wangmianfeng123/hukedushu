//
//  HKJobPathCourseListCell.m
//  Code
//
//  Created by Ivan li on 2019/6/11.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKJobPathCourseListCell.h"
#import "HKCustomMarginLabel.h"


@interface HKJobPathCourseListCell()

@property (strong, nonatomic)  UILabel *titleLB;

@property (strong, nonatomic)  HKCustomMarginLabel *countLB;

@property (strong, nonatomic)  UIView *seprarator;

@end

@implementation HKJobPathCourseListCell


- (void)awakeFromNib {
    [super awakeFromNib];
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
        [self.contentView addSubview:self.countLB];
    }
    return self;
}


- (void)layoutSubviews {
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(45);
    }];
    
    [self.countLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.lessThanOrEqualTo(self.contentView).offset(-3);
        make.left.equalTo(self.titleLB.mas_right).offset(PADDING_5);
    }];
}



- (UILabel*)titleLB {
    if (!_titleLB) {
        _titleLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F_EFEFF6 titleFont:@"14" titleAligment:0];
        _titleLB.font = HK_FONT_SYSTEM_WEIGHT(14, UIFontWeightMedium);
    }
    return _titleLB;
}



- (HKCustomMarginLabel*)countLB {
    if (!_countLB) {
        
        _countLB = [[HKCustomMarginLabel alloc]init];
        _countLB.textAlignment = NSTextAlignmentCenter;
        
        _countLB.font = HK_FONT_SYSTEM(11);
        _countLB.textInsets = UIEdgeInsetsMake(1, 5, 1, 5);
        _countLB.textColor = COLOR_A8ABBE_7B8196;

        _countLB.clipsToBounds = YES;
        _countLB.layer.cornerRadius = 5;
        _countLB.layer.borderWidth = 1;
        _countLB.layer.borderColor = COLOR_A8ABBE_7B8196.CGColor;
        [_countLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _countLB;
}


- (void)setModel:(HKCourseModel *)model {
    _model = model;
    
//    _titleLB.text =  [NSString stringWithFormat:@"%@ %@", model.praticeNO, model.title];
    _titleLB.text =  [NSString stringWithFormat:@"%@", model.title];
    
    _countLB.text = [NSString stringWithFormat:@"%ld节", model.course_count];
    _countLB.hidden = model.course_count ?NO : YES;
}





@end
