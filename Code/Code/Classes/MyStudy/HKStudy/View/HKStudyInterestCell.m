//
//  HKStudyInterestCell.m
//  Code
//
//  Created by hanchuangkeji on 2019/6/13.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKStudyInterestCell.h"

@interface HKStudyInterestCell()

@property (weak, nonatomic) IBOutlet UIView *redBGView;

@end

@implementation HKStudyInterestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.redBGView.clipsToBounds = YES;
    self.redBGView.layer.cornerRadius = 15.0;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.contentView.backgroundColor = [UIColor hkdm_colorWithColorLight:COLOR_ffffff dark:COLOR_3C4651];
}


@end
