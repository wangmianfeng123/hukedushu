//
//  HKMyInfoVipAdCell.m
//  Code
//
//  Created by Ivan li on 2019/4/12.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKMyInfoNotLoginCell.h"

@implementation HKMyInfoNotLoginCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tagLB.textColor = COLOR_7B8196_A8ABBE;
    self.backgroundColor = COLOR_FFFFFF_3D4752;
}



- (IBAction)loginBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(notLoginBtnDidClick:)]) {
        [self.delegate notLoginBtnDidClick:sender];
    }
}


@end
