//
//  HKTeacherNavBarView.m
//  Code
//
//  Created by hanchuangkeji on 2018/3/22.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKTeacherNavBarView.h"

@interface HKTeacherNavBarView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConst;

@end

@implementation HKTeacherNavBarView


- (void)awakeFromNib {
    [super awakeFromNib];
    if (IS_IPHONE_X) {
        self.topConst.constant = self.topConst.constant + 20;
    }
}

- (IBAction)backClick:(id)sender {
    !self.backClickBlock? : self.backClickBlock();
}

- (IBAction)shareClick:(id)sender {
    !self.shareClickBlock? : self.shareClickBlock(self.user);
}


@end
