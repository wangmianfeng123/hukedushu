//
//  HKRequestionCountCell.m
//  Code
//
//  Created by Ivan li on 2021/4/7.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKRequestionCountCell.h"

@interface HKRequestionCountCell ()
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@end

@implementation HKRequestionCountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = COLOR_F8F9FA_333D48;
    self.requestionCountLabel.textColor = COLOR_A8ABBE_7B8196;
    self.rightLabel.textColor = COLOR_A8ABBE_7B8196;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
