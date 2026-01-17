//
//  HKAlarmClockView.m
//  Code
//
//  Created by yxma on 2020/10/15.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKAlarmClockView.h"

@interface HKAlarmClockView ()
@property (weak, nonatomic) IBOutlet UIButton *SwithchBtn;

@end

@implementation HKAlarmClockView

+ (HKAlarmClockView *)createViewFrame:(CGRect)frame{
    HKAlarmClockView * view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HKAlarmClockView class]) owner:nil options:nil].lastObject;
    view.frame = frame;
    return view;
}

- (IBAction)timeBtnClick {
    if (self.timeBtnBlock) {
        self.timeBtnBlock();
    }
}

- (IBAction)tipSwithchBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    
    if (sender.selected) {
        [self.SwithchBtn setBackgroundImage:[UIImage imageNamed:@"ic_notice_sel"] forState:UIControlStateNormal];
    }else{
        [self.SwithchBtn setBackgroundImage:[UIImage imageNamed:@"ic_notice_nor"] forState:UIControlStateNormal];
    }
    [[NSUserDefaults standardUserDefaults]setBool:sender.selected forKey:HKCanlendarWitch];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
