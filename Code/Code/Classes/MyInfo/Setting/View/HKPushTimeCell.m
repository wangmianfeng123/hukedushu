//
//  HKPushTimeCell.m
//  Code
//
//  Created by eon Z on 2022/2/10.
//  Copyright © 2022 pg. All rights reserved.
//

#import "HKPushTimeCell.h"

@implementation HKPushTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    self.lineView.backgroundColor = COLOR_F8F9FA_333D48;
}

-(void)setModel:(HKPushTimeModel *)model{
    _model = model;
    self.titleLabel.text = model.name;
    self.rightIcon.hidden = !model.selected;
}

@end

@implementation HKPushTimeModel

@end
