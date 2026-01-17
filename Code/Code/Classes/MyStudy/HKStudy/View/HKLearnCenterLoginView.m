//
//  HKLearnCenterLoginView.m
//  Code
//
//  Created by hanchuangkeji on 2018/1/30.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKLearnCenterLoginView.h"
#import "UIView+SNFoundation.h"

@interface HKLearnCenterLoginView()
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation HKLearnCenterLoginView

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.containerView.clipsToBounds = YES;
//    self.containerView.layer.cornerRadius = 5.0;
    /** 阴影*/
    [self.containerView addShadowWithColor:COLOR_E1E7EB alpha:0.8 radius:4 offset:CGSizeMake(0, 2)];
}

- (IBAction)loginBtnClick:(id)sender {
    
    !self.logBtnClickBlock? : self.logBtnClickBlock();
}


@end
