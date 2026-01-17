


//
//  HKTaskDetailUserCommentHeadView.m
//  Code
//
//  Created by Ivan li on 2018/7/20.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKTaskDetailUserCommentHeadView.h"


@interface HKTaskDetailUserCommentHeadView()

@property (nonatomic,strong) UILabel *textLB;

@end

@implementation HKTaskDetailUserCommentHeadView

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    
    self.contentView.backgroundColor =  [UIColor whiteColor];
    [self.contentView addSubview:self.textLB];

    [self.textLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(PADDING_15);
        make.bottom.equalTo(self).offset(PADDING_10);;
    }];
}


- (UILabel*)textLB {
    if (!_textLB) {
        _textLB = [UILabel labelWithTitle:CGRectZero title:@"精彩评论" titleColor:COLOR_27323F titleFont:@"17" titleAligment:0];
        _textLB.font = HK_FONT_SYSTEM_WEIGHT(17, UIFontWeightMedium);
    }
    return _textLB;
}


@end
