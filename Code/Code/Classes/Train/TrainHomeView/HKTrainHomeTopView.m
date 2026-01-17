//
//  HKTrainHomeTopView.m
//  Code
//
//  Created by Ivan li on 2021/4/2.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKTrainHomeTopView.h"
#import "UIView+HKLayer.h"
#import "HKTrainDetailModel.h"

@interface HKTrainHomeTopView ()
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIButton *previousBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIButton *weekBtn;
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;

@end

@implementation HKTrainHomeTopView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = COLOR_FFFFFF_3D4752;;
    [self.centerView addCornerRadius:5];
    [self.centerView addGradientLayerColors:@[(id)[UIColor colorWithHexString:@"#56E1A7"].CGColor,(id)[UIColor colorWithHexString:@"#33CEB2"].CGColor]];
    [self.previousBtn setTitleColor:COLOR_A8ABBE_7B8196 forState:UIControlStateNormal];
    [self.nextBtn setTitleColor:COLOR_A8ABBE_7B8196 forState:UIControlStateNormal];
}

- (IBAction)previousClick {
    if (self.previousBlock) {
        self.previousBlock();
    }
}

- (IBAction)nextClick {
    if (self.nextBlock) {
        self.nextBlock();
    }
}

- (IBAction)timeClick {
    if (self.timeClickBlock) {
        self.timeClickBlock();
    }
}

- (IBAction)signInBtnClick {
    if (self.signInClickBlock) {
        self.signInClickBlock(self.detailModel);
    }
}

-(void)setTaskCalendarModel:(HKTrainDetailTaskCalendarModel *)taskCalendarModel{
    _taskCalendarModel = taskCalendarModel;
    if ([taskCalendarModel.date containsString:@"/"]) {
        NSString * datestr = [taskCalendarModel.date stringByReplacingOccurrencesOfString:@"/" withString:@"月"];
        [self.timeBtn setTitle:[NSString stringWithFormat:@"%@日",datestr] forState:UIControlStateNormal];
    }
    [self.weekBtn setTitle:taskCalendarModel.week forState:UIControlStateNormal];
}

-(void)setDetailModel:(HKTrainDetailModel *)detailModel{
    _detailModel = detailModel;
    if (detailModel.task_list.is_clock) {
        [self.signInBtn setTitle:@"已打卡" forState:UIControlStateNormal];
    }else{
        [self.signInBtn setTitle:@"未打卡" forState:UIControlStateNormal];
    }
}
@end
