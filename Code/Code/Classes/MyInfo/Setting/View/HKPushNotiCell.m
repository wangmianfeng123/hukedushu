//
//  HKPushNotiCell.m
//  Code
//
//  Created by eon Z on 2022/2/10.
//  Copyright © 2022 pg. All rights reserved.
//

#import "HKPushNotiCell.h"
#import "HKSwitchBtn.h"
#import "HKPushNoticeModel.h"
#import "UIView+HKLayer.h"

@interface HKPushNotiCell ()<HKSwitchBtnDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *txtLabel;
@property (weak, nonatomic) IBOutlet UIButton *setBtn;

@property (strong, nonatomic) HKSwitchBtn *switchBtn;

@end

@implementation HKPushNotiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.contentView addSubview:self.switchBtn];
    
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).with.offset(-11);
    }];
    [self hkDarkModel];
}

- (IBAction)setBtnClick {
    if (self.setBtnBlock) {
        self.setBtnBlock();
    }
}

- (void)hkDarkModel {
    self.titleLabel.textColor = [UIColor hkdm_colorWithColorLight:COLOR_333333 dark:COLOR_EFEFF6];
    self.txtLabel.textColor = [UIColor hkdm_colorWithColorLight:COLOR_666666 dark:COLOR_7B8196];
    [self.setBtn setTitleColor:[UIColor hkdm_colorWithColorLight:COLOR_666666 dark:COLOR_7B8196] forState:UIControlStateNormal];
    [self.setBtn addCornerRadius:8 addBoderWithColor:[UIColor hkdm_colorWithColorLight:COLOR_666666 dark:COLOR_7B8196]];
    //self.sepView.backgroundColor = COLOR_F8F9FA_333D48;
}

- (HKSwitchBtn *)switchBtn {
    if(_switchBtn == nil) {
        _switchBtn = [[HKSwitchBtn alloc]init];
        _switchBtn.transform = CGAffineTransformMakeScale(0.8, 0.8);
        _switchBtn.delegate = self;
//        _switchBtn.hidden = YES;
        //BOOL on = [[NSUserDefaults standardUserDefaults]boolForKey:HKScreenShotSwitch];
        //_switchBtn.on = on;
    }
    return _switchBtn;
}

-(void)setNoticeModel:(HKPushNoticeModel *)noticeModel{
    _noticeModel = noticeModel;
    self.titleLabel.text = noticeModel.name;
    
    if (isLogin()) {
        self.switchBtn.on = _noticeModel.value;
    }else{
        self.switchBtn.on = NO;
    }
    //提醒时间：21：00，周一至周五
    
    
    self.txtLabel.text = [NSString stringWithFormat:@"提醒时间：%@:%@，%@",noticeModel.j_push_hour,noticeModel.j_push_hour_typeString,noticeModel.pushFrequency];
}
- (void)switchClick:(UISwitch *)sender {
    self.switchBlock ?self.switchBlock(sender) :nil;
}

@end
