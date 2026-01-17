//
//  HKDropMenuFilterHeader.m
//  Code
//
//  Created by Ivan li on 2019/1/7.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKDropMenuFilterHeader.h"
#import "HKDropMenuModel.h"



@implementation HKDropMenuFilterHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}


- (void)configuration {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}


- (void)tap:(UITapGestureRecognizer *)gesture {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropMenuFilterHeader:dropMenuModel:)]) {
        [self.delegate dropMenuFilterHeader:self dropMenuModel:self.dropMenuModel];
    }
}


- (void)setupUI {
    [self addSubview:self.title];
    [self addSubview:self.details];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self);
    }];
    
    [self.details mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_lessThanOrEqualTo(200);
        make.right.equalTo(self.mas_right).offset(-PADDING_15);
        make.centerY.equalTo(self);
    }];
}


- (void)setDropMenuModel:(HKDropMenuModel *)dropMenuModel {
    
    _dropMenuModel = dropMenuModel;
    self.title.text = dropMenuModel.sectionHeaderTitle;
    
//    if (0 == dropMenuModel.tagId) {
//        //全部 tag
//        self.details.text = nil;
//    }else{
//        self.details.text = dropMenuModel.sectionHeaderDetails.length ?dropMenuModel.sectionHeaderDetails :nil;
//    }
    
    if ([dropMenuModel.sectionHeaderDetails isEqualToString:@"全部"]) {
        self.details.text = nil;
    }else {
        self.details.text = dropMenuModel.sectionHeaderDetails.length ?dropMenuModel.sectionHeaderDetails :nil;
    }
}


- (UILabel *)details {
    if (_details == nil) {
        _details = [[UILabel alloc]init];
        _details.textAlignment = NSTextAlignmentRight;
        //_details.userInteractionEnabled = YES;
        _details.font = [UIFont systemFontOfSize:11];
        _details.textColor = COLOR_FF7820;
    }
    return _details;
}


- (UILabel *)title {
    if (_title == nil) {
        _title = [[UILabel alloc]init];
        _title.textAlignment = NSTextAlignmentLeft;
        //_title.userInteractionEnabled = YES;
        _title.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _title.textColor = COLOR_27323F_EFEFF6;
    }
    return _title;
}

@end
