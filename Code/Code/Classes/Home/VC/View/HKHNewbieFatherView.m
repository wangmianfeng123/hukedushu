//
//  HKHNewbieFatherView.m
//  Code
//
//  Created by yxma on 2020/11/10.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKHNewbieFatherView.h"
#import "HNewbieTaskView.h"
#import "HKNewTaskModel.h"

@interface HKHNewbieFatherView ()

@end

@implementation HKHNewbieFatherView

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.taskView = [HNewbieTaskView createView];
        @weakify(self)
        self.taskView.finishBtnBlock = ^{
            @strongify(self)
            if (self.finishBtnBlock) {
                self.finishBtnBlock();
            }
        };
        [self addSubview:self.taskView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.taskView.frame = self.bounds;
}


-(void)setAlertType:(int)alertType{
    _alertType = alertType;
    if (_alertType == 1 || _alertType == 5 || _alertType == 6) {
        self.taskView.centerContentView.hidden = NO;
        self.taskView.centerTxtLabel.hidden = YES;
        self.taskView.topImgView.hidden = YES;
        self.taskView.otherLabel.hidden = YES;
        self.taskView.alertType = self.alertType;
    }else if (_alertType == 2){
        self.taskView.centerContentView.hidden = YES;
        self.taskView.centerTxtLabel.hidden = NO;
        self.taskView.topImgView.hidden = YES;
        self.taskView.otherLabel.hidden = YES;
        [self.taskView.finishBtn setTitle:@"领取免费训练营" forState:UIControlStateNormal];
    }else if (_alertType == 3){
        self.taskView.centerContentView.hidden = YES;
        self.taskView.centerTxtLabel.hidden = YES;
        self.taskView.countDownLabel.hidden = YES;
        self.taskView.topImgView.hidden = YES;
        self.taskView.otherLabel.hidden = YES;
        [self.taskView.finishBtn setTitle:@"立即体验" forState:UIControlStateNormal];
    }else if (_alertType == 4){
        self.taskView.topView.hidden = YES;
        self.taskView.countDownLabel.hidden = YES;
        self.taskView.centerContentView.hidden = YES;
        self.taskView.centerTxtLabel.hidden = YES;
        self.taskView.topImgView.hidden = NO;
        self.taskView.otherLabel.hidden = NO;
        [self.taskView.finishBtn setTitle:@"查看老用户福利" forState:UIControlStateNormal];
    }
}

-(void)setModel:(HKNewTaskModel *)model{
    _model = model;
    self.taskView.tipLabel.text = [NSString stringWithFormat:@"完成任务赠送%d小时VIP",_model.hour];
    self.taskView.descLabel.text = _model.desc;
}
@end
