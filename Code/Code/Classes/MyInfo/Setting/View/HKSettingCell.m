//
//  HKSettingCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/12/12.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKSettingCell.h"
#import "HKSwitchBtn.h"
#import "HKPushNoticeModel.h"

@interface HKSettingCell() <HKSwitchBtnDelegate>


@property (weak, nonatomic) IBOutlet UILabel *leftDetailLB;
@property (weak, nonatomic) IBOutlet UIView *sepView;


@end

@implementation HKSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView addSubview:self.switchBtn];
    
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).with.offset(-11);
    }];
    [self hkDarkModel];
}


- (void)hkDarkModel {
    self.titleLB.textColor = [UIColor hkdm_colorWithColorLight:COLOR_333333 dark:COLOR_EFEFF6];
    self.leftDetailLB.textColor = [UIColor hkdm_colorWithColorLight:COLOR_666666 dark:COLOR_7B8196];
    self.sepView.backgroundColor = COLOR_F8F9FA_333D48;
    //[UIColor hkdm_colorWithColorLight:COLOR_F6F6F6 dark:COLOR_333D48];
}


- (void)setModel:(HKSettingModel *)model {
    _model = model;
    self.leftDetailLB.hidden = !model.leftDetail.length;
    self.leftDetailLB.text = model.leftDetail;
    self.titleLB.text = model.titleName;
}


-(void)setNoticeModel:(HKPushNoticeModel *)noticeModel{
    _noticeModel = noticeModel;
    self.titleLB.text = noticeModel.name;
    self.leftDetailLB.hidden = YES;
    
    if (isLogin()) {
        self.switchBtn.on = _noticeModel.value;
    }else{
        self.switchBtn.on = NO;
    }
}

- (HKSwitchBtn *)switchBtn {
    if(_switchBtn == nil) {
        _switchBtn = [[HKSwitchBtn alloc]init];
        _switchBtn.transform = CGAffineTransformMakeScale(0.8, 0.8);
        _switchBtn.delegate = self;
        _switchBtn.hidden = YES;
        BOOL on = [[NSUserDefaults standardUserDefaults]boolForKey:HKScreenShotSwitch];
        _switchBtn.on = on;
    }
    return _switchBtn;
}


- (void)switchClick:(UISwitch *)sender {
    self.switchBlock ?self.switchBlock(sender) :nil;
}


- (void)setHiddenSwitch:(BOOL)hiddenSwitch {
    _hiddenSwitch = hiddenSwitch;
    _switchBtn.hidden = hiddenSwitch;
}


- (void)setSiwtchBtnState:(BOOL)on {
    _switchBtn.on = on;
}



@end
