//
//  HKGoodsDetailBottomCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/29.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKGoodsDetailBottomCell.h"


@interface HKGoodsDetailBottomCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;


@end

@implementation HKGoodsDetailBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
