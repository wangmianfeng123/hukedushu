//
//  HKTeacherNavBarView.m
//  Code
//
//  Created by hanchuangkeji on 2018/3/22.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKYellowNavBarView.h"

@interface HKYellowNavBarView ()

@end


@implementation HKYellowNavBarView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentMode = UIViewContentModeTop | UIViewContentModeScaleAspectFill;
    
    
}

- (IBAction)backClick:(id)sender {
    !self.backClickBlock? : self.backClickBlock();
}

- (IBAction)shareClick:(id)sender {
    !self.shareClickBlock? : self.shareClickBlock(self.user);
}


@end
