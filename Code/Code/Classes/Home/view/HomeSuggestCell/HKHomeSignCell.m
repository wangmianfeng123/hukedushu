//
//  HKHomeSignCell.m
//  Code
//
//  Created by eon Z on 2021/8/31.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKHomeSignCell.h"
#import "UIView+HKLayer.h"
#import "HKHomeSignModel.h"

@interface HKHomeSignCell ()

@end

@implementation HKHomeSignCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //self.contentView.backgroundColor = COLOR_FFFFFF_3D4752;
    
    [self.signLabel addCornerRadius:17.5 addBoderWithColor:COLOR_27323F_A8ABBE];
    self.signLabel.textColor = COLOR_27323F_A8ABBE;
    self.signLabel.backgroundColor = COLOR_FFFFFF_3D4752;
    self.signLabel.layer.borderColor = COLOR_27323F_EFEFF6.CGColor;
    self.signLabel.layer.borderWidth = 1.0;
}

-(void)setSignModel:(HKHomeSignModel *)signModel{
    _signModel = signModel;
    self.signLabel.text = signModel.name;

    if (signModel.is_check) {
        self.signLabel.textColor = COLOR_FF7820;
        self.signLabel.backgroundColor = COLOR_FFF0E6;
        self.signLabel.layer.borderColor = [UIColor clearColor].CGColor;
    }else{
        self.signLabel.textColor = COLOR_27323F_EFEFF6;
        self.signLabel.backgroundColor = COLOR_FFFFFF_3D4752;
        self.signLabel.layer.borderColor = COLOR_27323F_EFEFF6.CGColor;
    }
}

@end
