//
//  HNewbieTaskView.m
//  Code
//
//  Created by yxma on 2020/11/10.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HNewbieTaskView.h"

@interface HNewbieTaskView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV1;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV2;
@property (weak, nonatomic) IBOutlet UILabel *txtLabel1;
@property (weak, nonatomic) IBOutlet UILabel *txtLabel2;
@property (weak, nonatomic) IBOutlet UILabel *txtLabel3;

@end

@implementation HNewbieTaskView

+ (HNewbieTaskView *)createView{
    HNewbieTaskView * authView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HNewbieTaskView class]) owner:nil options:nil].lastObject;
    //authView.frame = CGRectMake(0, 0, 260, 308);
    return authView;
}

- (IBAction)finishBtnClick {
    if (self.finishBtnBlock) {
        self.finishBtnBlock();
    }
}


-(void)setAlertType:(int)alertType{
    //1.新手任务第一步 5.新手任务第二步 6.新手任务第三步
    //黄色 FF7820  灰色 #A8ABBE  黑色
    _alertType = alertType;
    if (_alertType == 1) {
        self.iconImgV1.image = [UIImage imageNamed:@"ic_step1_ongoing"];
        self.iconImgV2.image = [UIImage imageNamed:@"ic_step2_incomplete"];
        self.txtLabel1.textColor = [UIColor colorWithHexString:@"FF7820"];
        self.txtLabel2.textColor = [UIColor blackColor];
        self.txtLabel3.textColor = [UIColor blackColor];
        [self.finishBtn setTitle:@"去注册" forState:UIControlStateNormal];
    }else if (_alertType == 5){
        self.iconImgV1.image = [UIImage imageNamed:@"ic_step_complete"];
        self.iconImgV2.image = [UIImage imageNamed:@"ic_step2_ongoing"];
        self.txtLabel1.textColor = [UIColor colorWithHexString:@"A8ABBE"];
        self.txtLabel2.textColor = [UIColor colorWithHexString:@"FF7820"];
        self.txtLabel3.textColor = [UIColor blackColor];
        [self.finishBtn setTitle:@"去学习" forState:UIControlStateNormal];
    }else if (_alertType == 6){
        self.iconImgV1.image = [UIImage imageNamed:@"ic_step_complete"];
        self.iconImgV2.image = [UIImage imageNamed:@"ic_step_complete"];
        self.txtLabel1.textColor = [UIColor colorWithHexString:@"A8ABBE"];
        self.txtLabel2.textColor = [UIColor colorWithHexString:@"A8ABBE"];
        self.txtLabel3.textColor = [UIColor colorWithHexString:@"FF7820"];
        [self.finishBtn setTitle:@"领取奖励" forState:UIControlStateNormal];
    }
}
@end
