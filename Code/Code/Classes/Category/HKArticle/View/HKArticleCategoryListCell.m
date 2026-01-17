//
//  HKArticleCategoryListCell.m
//  Code
//
//  Created by hanchuangkeji on 2018/8/3.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKArticleCategoryListCell.h"


@interface HKArticleCategoryListCell()
@property (weak, nonatomic) IBOutlet UILabel *myLabel;

@end

@implementation HKArticleCategoryListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.myLabel.clipsToBounds = YES;
    self.myLabel.layer.cornerRadius = (IS_IPHONEMORE4_7INCH? 32 : 28) * 0.5;
}

- (void)setModel:(HKArticleCategoryModel *)model {
    _model = model;
    self.myLabel.text = model.name;
    if (!model.isSelected) {
        UIColor *bgColor = [UIColor hkdm_colorWithColorLight:COLOR_F8F9FA dark:COLOR_A8ABBE];
        self.myLabel.textColor =COLOR_7B8196_27323F; //HKColorFromHex(0x7B8196, 1.0);
        [self.myLabel setBackgroundColor:bgColor];
    } else {
        self.myLabel.textColor = HKColorFromHex(0xFF7820, 1.0);
        [self.myLabel setBackgroundColor:HKColorFromHex(0xFFF6ED, 1.0)];
    }
}
@end
