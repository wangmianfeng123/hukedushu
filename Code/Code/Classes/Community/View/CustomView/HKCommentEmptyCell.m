//
//  HKCommentEmptyCell.m
//  Code
//
//  Created by Ivan li on 2021/1/28.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKCommentEmptyCell.h"

@interface HKCommentEmptyCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HKCommentEmptyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.textColor = COLOR_A8ABBE_7B8196;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
