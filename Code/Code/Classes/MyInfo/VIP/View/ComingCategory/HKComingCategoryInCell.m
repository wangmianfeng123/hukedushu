//
//  HKOtherVipInCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/28.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKComingCategoryInCell.h"

@interface HKComingCategoryInCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLB;

@end

@implementation HKComingCategoryInCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.contentView.clipsToBounds = YES;
    self.contentView.layer.cornerRadius = 5.0;
    [self sendSubviewToBack:self.contentView];
}


- (void)setModel:(HKVipPrivilegeModel *)model {
    _model = model;
    self.nameLB.text = model.name;
    self.nameLB.textColor =  COLOR_27323F_EFEFF6;
}



@end
