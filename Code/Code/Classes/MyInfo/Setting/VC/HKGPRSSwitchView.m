//
//  HKGPRSSwitchView.m
//  Code
//
//  Created by Ivan li on 2019/6/3.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKGPRSSwitchView.h"
#import "HKSwitchBtn.h"


#define   HKGPRSSwitch  @"HKGPRSSwitch"
//#define   HKRemindMeMarkBtn  @"RemindMeMarkBtn"


@interface HKGPRSSwitchView() <HKSwitchBtnDelegate>

@property (strong, nonatomic) HKSwitchBtn *switchBtn;

@property (nonatomic, strong) UIButton * markBtn;

@end


@implementation HKGPRSSwitchView


- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (UIButton *) markBtn{
    if (!_markBtn) {
        _markBtn = [[UIButton alloc] init];
        _markBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_markBtn setBackgroundColor:[UIColor whiteColor]];
        [_markBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_markBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_markBtn setImage:[UIImage imageNamed:@"ic_notice_nor"] forState:UIControlStateNormal];
        [_markBtn setImage:[UIImage imageNamed:@"ic_notice_sel"] forState:UIControlStateSelected];
        [_markBtn addTarget:self action:@selector(markBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _markBtn.hidden = YES;
    }
    return _markBtn;
}

-(void)setShowMarkBtn:(BOOL)showMarkBtn{
    _showMarkBtn = showMarkBtn;
    _markBtn.hidden = NO;
    _switchBtn.hidden = YES;
}

- (void)markBtnClick:(UIButton *)btn{
//    btn.selected = !btn.selected;
//    [[NSUserDefaults standardUserDefaults]setBool:btn.selected forKey:HKCanlendarWitch];
}

- (void)createUI  {
    
    [self addSubview:self.titleLB];
    [self addSubview:self.switchBtn];
    [self addSubview:self.markBtn];
    
    
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(-10);
    }];
    
    [self.markBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.switchBtn.mas_right).offset(-10);
        make.width.height.equalTo(@(15));
    }];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(self);
        make.left.equalTo(self.switchBtn.mas_right);
    }];
}

- (HKSwitchBtn *)switchBtn {
    if(_switchBtn == nil) {
        _switchBtn = [[HKSwitchBtn alloc]init];
        _switchBtn.transform = CGAffineTransformMakeScale(0.6, 0.6);
        _switchBtn.delegate = self;
        BOOL on = [[NSUserDefaults standardUserDefaults]boolForKey:HKGPRSSwitch];
        _switchBtn.on = on;
    }
    return _switchBtn;
}



- (UILabel*)titleLB {
    if (!_titleLB) {
        _titleLB = [UILabel labelWithTitle:CGRectZero title:@"开启“允许3G/4G等流量播放”,不再弹窗提醒哦" titleColor:COLOR_030303 titleFont:@"11" titleAligment:NSTextAlignmentLeft];
        _titleLB.numberOfLines = 2;
        _titleLB.userInteractionEnabled = YES;
        [_titleLB setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _titleLB;
}



- (void)switchClick:(UISwitch *)sender {
    //self.switchBlock ?self.switchBlock(sender) :nil;
    [[NSUserDefaults standardUserDefaults]setBool:sender.on forKey:HKGPRSSwitch];
    
    [MobClick event:UM_RECORD_GPRS_ALERT_ALLOW_4G];
}



- (void)setHiddenSwitch:(BOOL)hiddenSwitch {
    _hiddenSwitch = hiddenSwitch;
    _switchBtn.hidden = hiddenSwitch;
}



@end
