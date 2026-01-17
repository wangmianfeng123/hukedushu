//
//  HKPostMomentTopView.m
//  Code
//
//  Created by Ivan li on 2021/1/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKPostMomentTopView.h"

@interface HKPostMomentTopView ()

@end

@implementation HKPostMomentTopView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = COLOR_F8F9FA_333D48;
    [self.topicBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
    [self.topicBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    [self.rightLabel setTitleColor:COLOR_A8ABBE_7B8196 forState:UIControlStateNormal];
//    [self.rightLabel layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleRight imageTitleSpace:0];
//    [self.rightLabel setImage:[UIImage imageNamed:@"arrow_right_gray"] forState:UIControlStateNormal];

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self addGestureRecognizer:tap];
}

- (void)tapClick{
    if (self.didTapBlock) {
        self.didTapBlock();
    }
}


@end
