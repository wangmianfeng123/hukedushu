//
//  HKBookTimerCell.m
//  Code
//
//  Created by Ivan li on 2019/7/17.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBookTimerCell.h"
#import "HKBookModel.h"

@interface HKBookTimerCell()

@property (strong, nonatomic)  UILabel *titleLB;

@property (strong, nonatomic)  UIImageView *selectIV;

@end

@implementation HKBookTimerCell

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
    [self.contentView addSubview:self.selectIV];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(PADDING_15);
        make.right.equalTo(self.selectIV.mas_left);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.selectIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-PADDING_15);
        make.centerY.equalTo(self.titleLB);
    }];
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F titleFont:@"15" titleAligment:NSTextAlignmentLeft];
    }
    return _titleLB;
}


- (UIImageView*)selectIV {
    if (!_selectIV) {
        _selectIV = [UIImageView new];
        _selectIV.image = imageName(@"ic_right1_v2_14");
        _selectIV.hidden = YES;
    }
    return _selectIV;
}



- (void)setTitleWithStr:(NSString*)title {
    self.titleLB.text = title;
}


- (void)setBookModel:(HKBookModel *)bookModel {
    _bookModel = bookModel;
    self.selectIV.hidden = !bookModel.is_selected;
    
    self.titleLB.text = bookModel.title;
    self.titleLB.textColor = bookModel.is_selected ? COLOR_FF3221 :COLOR_27323F_EFEFF6;
}


@end
