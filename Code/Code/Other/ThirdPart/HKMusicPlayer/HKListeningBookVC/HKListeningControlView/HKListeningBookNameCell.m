//
//  HKListeningBookNameCell.m
//  Code
//
//  Created by Ivan li on 2019/7/18.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKListeningBookNameCell.h"
#import "HKBookModel.h"


@implementation HKListeningBookNameCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //self.backgroundColor = COLOR_FFFFFF_333D48;
        
        [self.contentView addSubview:self.shadowIV];
        [self.contentView addSubview:self.descrLB];
        [self.contentView addSubview:self.bookNameLB];
        
        [self.contentView addSubview:self.authorLB];
        [self.contentView addSubview:self.timeLB];
        [self.contentView addSubview:self.countLB];
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.shadowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
    }];
    
    [self.descrLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(37);
        make.right.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(PADDING_15);
    }];
    
    [self.bookNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descrLB.mas_bottom).offset(13);
        make.left.right.equalTo(self.descrLB);
    }];
    
    [self.authorLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bookNameLB.mas_bottom).offset(10);
        make.left.right.equalTo(self.descrLB);
    }];
    
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.authorLB.mas_bottom).offset(10);
        make.left.right.equalTo(self.descrLB);
    }];
    
    [self.countLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLB.mas_bottom).offset(10);
        make.left.right.equalTo(self.descrLB);
    }];
}



- (UIImageView*)shadowIV {
    if (!_shadowIV) {
        _shadowIV = [UIImageView new];
        UIImage *image = [UIImage hkdm_imageWithNameLight:@"bg_shadow_v2_14" darkImageName:@"bg_shadow_v2_14_dark"];
        _shadowIV.image = image;
    }
    return _shadowIV;
}


- (UILabel*)descrLB {

    if (!_descrLB) {
        _descrLB = [UILabel labelWithTitle:CGRectZero title:@"书籍介绍" titleColor:COLOR_27323F_EFEFF6 titleFont:@"17" titleAligment:NSTextAlignmentLeft];
        _descrLB.font = HK_FONT_SYSTEM_WEIGHT(17, UIFontWeightSemibold);
    }
    return _descrLB;
}


- (UILabel*)bookNameLB {
    
    if (!_bookNameLB) {
        _bookNameLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F_EFEFF6 titleFont:@"15" titleAligment:NSTextAlignmentLeft];
        //_bookNameLB.font = HK_FONT_SYSTEM_WEIGHT(15, UIFontWeightSemibold);
    }
    return _bookNameLB;
}


- (UILabel*)authorLB {
    
    if (!_authorLB) {
        _authorLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F_EFEFF6 titleFont:@"15" titleAligment:NSTextAlignmentLeft];
    }
    return _authorLB;
}


- (UILabel*)timeLB {
    
    if (!_timeLB) {
        _timeLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F_EFEFF6 titleFont:@"15" titleAligment:NSTextAlignmentLeft];
    }
    return _timeLB;
}


- (UILabel*)countLB {
    
    if (!_countLB) {
        _countLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F_EFEFF6 titleFont:@"15" titleAligment:NSTextAlignmentLeft];
    }
    return _countLB;
}



- (void)setModel:(HKBookModel *)model {
    _model = model;
    
    //书籍名称：《自控力：实操篇》
    if (!isEmpty(model.book_title)) {
        self.bookNameLB.text = [NSString stringWithFormat:@"书籍名称：%@",model.book_title];
    }
    //作者：凯利·麦格尼格尔
    if (!isEmpty(model.author)) {
        self.authorLB.text = [NSString stringWithFormat:@"作者：%@",model.author];
    }
    //更新时间：2019.07.03
    if (!isEmpty(model.last_updated_at)) {
        self.timeLB.text = [NSString stringWithFormat:@"更新时间：%@",model.last_updated_at];
    }
    //学习人数：1214人
    if (!isEmpty(model.listen_number)) {
        self.countLB.text = [NSString stringWithFormat:@"学习人数：%@人",model.listen_number];
    }
}

@end
