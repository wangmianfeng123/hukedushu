

//
//  HKSwitchBtn.m
//  Code
//
//  Created by Ivan li on 2018/7/11.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKSwitchBtn.h"
#import "UISwitch+EnlargeEdge.h"
  

@implementation HKSwitchBtn


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setConfig];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setConfig];
}

- (instancetype)init {
    if (self = [super init]) {
        [self setConfig];
    }
    return self;
}



- (void)setConfig {
    //默认 大小（51x31）
    self.layer.masksToBounds = YES;
    //self.layer.cornerRadius = self.height/2.0;
    [self addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
//    [self setBackgroundColor:COLOR_DFDFE3];
    //开启状态
    [self setOnTintColor:COLOR_1ADB7B];
    //关闭状态
    [self setTintColor:COLOR_DFDFE3];
    //开关的状态钮颜色
    [self setThumbTintColor:[UIColor whiteColor]];
}



- (void)switchAction:(UISwitch*)sender {
    
    if ([self.delegate respondsToSelector:@selector(switchClick:)]) {
        [self.delegate switchClick:sender];
    }
}




@end





