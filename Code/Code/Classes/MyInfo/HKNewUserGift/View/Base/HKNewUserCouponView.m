

//
//  HKNewUserCouponView.m
//  Code
//
//  Created by Ivan li on 2018/8/3.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKNewUserCouponView.h"
#import "HKHomeGiftModel.h"




@implementation HKNewUserCouponView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }return self;
}


- (instancetype)init{
    if (self = [super init]) {
        [self createUI];
    }return self;
}



- (void)createUI {
    
    [self addSubview:self.leftBgIV];
    [self addSubview:self.rightBgIV];
    
    [self.leftBgIV addSubview:self.leftLB];
    [self.rightBgIV addSubview:self.rightLB];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}



- (void)makeConstraints {
    
    [self.leftBgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
    }];
    
    [self.rightBgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftBgIV.mas_right).priorityHigh();
        make.top.equalTo(self.leftBgIV);
    }];
    
    [self.leftLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.leftBgIV);
        make.width.equalTo(self.leftBgIV);
    }];
    
    [self.rightLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.rightBgIV);
        make.width.equalTo(self.rightBgIV);
    }];
    
}



- (void)setModel:(HKHomeGiftModel *)model {
    _model = model;
    self.leftLB.text = [NSString stringWithFormat:@"%ld天",model.first_day_gift.express_vip.days];
    
    NSString *vipName = model.first_day_gift.express_vip.type_name;
    if (!isEmpty(vipName)) {
        NSString *title = [NSString stringWithFormat:@"%@\n当天使用",vipName];
        UIFont *font = HK_FONT_SYSTEM_WEIGHT(18, UIFontWeightSemibold);
        NSMutableAttributedString *attributed = [NSMutableAttributedString changeFontAndColor:font Color:[UIColor whiteColor]
                                                                                  TotalString:title
                                                                               SubStringArray:@[vipName]];
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 3;
        style.alignment = NSTextAlignmentCenter;
        [attributed addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, title.length)];
        
        self.rightLB.attributedText = attributed;
    }
    
}


- (UILabel*)leftLB {
    if (!_leftLB) {
        _leftLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:[UIColor whiteColor] titleFont:@"16" titleAligment:NSTextAlignmentCenter];
        _leftLB.font = HK_FONT_SYSTEM_WEIGHT(16, UIFontWeightSemibold);
    }
    return _leftLB;
}


- (UILabel*)rightLB {
    if (!_rightLB) {
        
        _rightLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:[UIColor whiteColor] titleFont:@"12" titleAligment:NSTextAlignmentCenter];
        _rightLB.numberOfLines = 0;
        
//        NSString *title = @"全站通VIP\n体验卷";
//        UIFont *font = HK_FONT_SYSTEM_WEIGHT(16, UIFontWeightSemibold);
//        NSMutableAttributedString *attributed = [NSMutableAttributedString changeFontAndColor:font Color:[UIColor whiteColor]
//                                                                                  TotalString:title
//                                                                               SubStringArray:@[@"全站通VIP"]];
//
//        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//        style.lineSpacing = 3;
//        style.alignment = NSTextAlignmentCenter;
//        [attributed addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, title.length)];
//
//        _rightLB.attributedText = attributed;
    }
    return _rightLB;
}



- (UIImageView*)leftBgIV {
    if (!_leftBgIV) {
        _leftBgIV = [UIImageView new];
        _leftBgIV.image = imageName(@"bg_orange_left");
        //_leftBgIV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _leftBgIV;
}


- (UIImageView*)rightBgIV {
    if (!_rightBgIV) {
        _rightBgIV = [UIImageView new];
        _rightBgIV.image = imageName(@"bg_orange_right");
        //_rightBgIV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _rightBgIV;
}


@end



















