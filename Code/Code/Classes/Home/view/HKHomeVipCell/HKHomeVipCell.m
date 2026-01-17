//
//  HKHomeVipCell.m
//  Code
//
//  Created by ivan on 2020/6/23.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKHomeVipCell.h"
#import "HKHomeVipModel.h"


@interface HKHomeVipCell()

@property (nonatomic, strong)UILabel *textLB;

@end



@implementation HKHomeVipCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    [self.contentView addSubview:self.textLB];
    [self.textLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(PADDING_10);
        make.left.equalTo(self.contentView).offset(PADDING_5);
        make.size.mas_equalTo(CGSizeMake(78, 26));
    }];
}


- (UILabel*)textLB {
    if (!_textLB) {
        _textLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE_27323F titleFont:@"13" titleAligment:NSTextAlignmentCenter];
        _textLB.font = HK_TIME_FONT(13);
        _textLB.clipsToBounds = YES;
        _textLB.layer.cornerRadius = 13;
        UIColor *bgColor = [UIColor hkdm_colorWithColorLight:COLOR_F3F3F6 dark:COLOR_7B8196];
        _textLB.backgroundColor = bgColor;
        [_textLB sizeToFit];
    }
    return _textLB;
}




- (void)setVipModel:(HKHomeVipModel *)vipModel {
    _vipModel = vipModel;
    self.textLB.text = vipModel.name;
}



@end
