//
//  HKPresentHeader.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/8.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKPresentHeader.h"
#import "HKVerticalDayButton.h"
#import "HKPresentHeaderModel.h"
#import "NSTimer+FOF.h"


@interface HKPresentHeader()

@property (weak, nonatomic) IBOutlet UILabel *HKCoinCountLB;// 金币总数

@property (weak, nonatomic) IBOutlet UILabel *presnetDaysLB;// 连续签到天数
@property (weak, nonatomic) IBOutlet UIView *progress;// 进度条灰色
@property (weak, nonatomic) IBOutlet UIView *orangeProgress;// 进度条橙色
@property (weak, nonatomic) IBOutlet HKVerticalDayButton *btn0;// day1
@property (weak, nonatomic) IBOutlet HKVerticalDayButton *btn1;// day2
@property (weak, nonatomic) IBOutlet HKVerticalDayButton *btn2;// day3
@property (weak, nonatomic) IBOutlet HKVerticalDayButton *btn3;// day4
@property (weak, nonatomic) IBOutlet HKVerticalDayButton *btn4;// day5
@property (weak, nonatomic) IBOutlet HKVerticalDayButton *btn5;// day6
@property (weak, nonatomic) IBOutlet HKVerticalDayButton *btn6;// day7
@property (weak, nonatomic) IBOutlet UILabel *six;
@property (nonatomic, weak)NSTimer *timer;

@property (nonatomic, assign)NSInteger coinAdd;

@property (weak, nonatomic) IBOutlet UIButton *finishPresentBtn;

@end


@implementation HKPresentHeader

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer tb_scheduledTimerWithTimeInterval:0.008 block:^{
            [self countingCoin];
        } repeats:YES];
    }
    return _timer;
}

- (void)countingCoin {
    self.coinAdd++;
    
    if (self.coinAdd <= self.model.gold_total.integerValue) {
        self.HKCoinCountLB.text = [NSString stringWithFormat:@"%ld", self.coinAdd];
    }else {
        self.coinAdd = 0;
        [self.timer invalidate];
        self.timer = nil;
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.finishPresentBtn.clipsToBounds = YES;
    self.finishPresentBtn.layer.cornerRadius = 25 * 0.5;
    
    
    // 设置按钮的选中与否
    [self initBtns];
}

- (void)initBtns {
    [self.btn0 setTextTop:@"+5" bottom:@"1天"];
    [self.btn1 setTextTop:@"+10" bottom:@"2天"];
    [self.btn2 setTextTop:@"大奖" bottom:@"3天"];
    [self.btn3 setTextTop:@"+15" bottom:@"4天"];
    [self.btn4 setTextTop:@"+20" bottom:@"5天"];
    [self.btn5 setTextTop:@"+20" bottom:@"6天"];
    [self.btn6 setTextTop:@"大奖" bottom:@"7天"];
    
    [self.btn0 setTitleColor:HKColorFromHex(0x999999, 1.0) forState:UIControlStateNormal];
    [self.btn1 setTitleColor:HKColorFromHex(0x999999, 1.0) forState:UIControlStateNormal];
    [self.btn2 setTitleColor:HKColorFromHex(0x999999, 1.0) forState:UIControlStateNormal];
    [self.btn3 setTitleColor:HKColorFromHex(0x999999, 1.0) forState:UIControlStateNormal];
    [self.btn4 setTitleColor:HKColorFromHex(0x999999, 1.0) forState:UIControlStateNormal];
    [self.btn5 setTitleColor:HKColorFromHex(0x999999, 1.0) forState:UIControlStateNormal];
    [self.btn6 setTitleColor:HKColorFromHex(0x999999, 1.0) forState:UIControlStateNormal];
    
    [self.btn0 setTitleColor:HKColorFromHex(0xff6600, 1.0) forState:UIControlStateSelected];
    [self.btn1 setTitleColor:HKColorFromHex(0xff6600, 1.0) forState:UIControlStateSelected];
    [self.btn2 setTitleColor:HKColorFromHex(0xff6600, 1.0) forState:UIControlStateSelected];
    [self.btn3 setTitleColor:HKColorFromHex(0xff6600, 1.0) forState:UIControlStateSelected];
    [self.btn4 setTitleColor:HKColorFromHex(0xff6600, 1.0) forState:UIControlStateSelected];
    [self.btn5 setTitleColor:HKColorFromHex(0xff6600, 1.0) forState:UIControlStateSelected];
    [self.btn6 setTitleColor:HKColorFromHex(0xff6600, 1.0) forState:UIControlStateSelected];
    
    [self.btn0 setImage:imageName(@"present_day_normal") forState:UIControlStateNormal];
    [self.btn1 setImage:imageName(@"present_day_normal") forState:UIControlStateNormal];
    [self.btn2 setImage:imageName(@"present_day_price_normal") forState:UIControlStateNormal];
    [self.btn3 setImage:imageName(@"present_day_normal") forState:UIControlStateNormal];
    [self.btn4 setImage:imageName(@"present_day_normal") forState:UIControlStateNormal];
    [self.btn5 setImage:imageName(@"present_day_normal") forState:UIControlStateNormal];
    [self.btn6 setImage:imageName(@"present_day_price_normal") forState:UIControlStateNormal];
    
    [self.btn0 setImage:imageName(@"present_day_selected") forState:UIControlStateSelected];
    [self.btn1 setImage:imageName(@"present_day_selected") forState:UIControlStateSelected];
    [self.btn2 setImage:imageName(@"present_day_price_selected") forState:UIControlStateSelected];
    [self.btn3 setImage:imageName(@"present_day_selected") forState:UIControlStateSelected];
    [self.btn4 setImage:imageName(@"present_day_selected") forState:UIControlStateSelected];
    [self.btn5 setImage:imageName(@"present_day_selected") forState:UIControlStateSelected];
    [self.btn6 setImage:imageName(@"present_day_price_selected") forState:UIControlStateSelected];
}

// 签到按钮
- (IBAction)finishBtnClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(finishPresenBtnClcik:)]) {
        [self.delegate finishPresenBtnClcik:self.model];
    }
    
}

- (void)setSelectedBtn:(HKPresentHeaderModel *)model {
    int day = model.continue_num.intValue;
    self.btn0.selected = day >= 1;
    self.btn1.selected = day >= 2;
    self.btn2.selected = day >= 3;
    self.btn3.selected = day >= 4;
    self.btn4.selected = day >= 5;
    self.btn5.selected = day >= 6;
    self.btn6.selected = day >= 7;
    
    // 更新当前天数选中的颜色
    if (day <= 0)return;
    int currentDay = model.is_price? day - 1 : day;
    UIButton *currentBtn = nil;
    switch (currentDay) {
        case 1:
            currentBtn = self.btn0;
            break;
        case 2:
            currentBtn = self.btn1;
            break;
            
        case 3:
            currentBtn = self.btn2;
            break;
        case 4:
            currentBtn = self.btn3;
            break;
        case 5:
            currentBtn = self.btn4;
            break;
        case 6:
            currentBtn = self.btn5;
            break;
        case 7:
            currentBtn = self.btn6;
            break;
        default:
            break;
    }
    UIImage *currentImage = (currentDay == 3 || currentDay == 7)? imageName(@"present_day_price_current") : imageName(@"present_day_current");
    [currentBtn setImage:currentImage forState:UIControlStateSelected];
    [currentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    // 设置签到按钮的状态
    self.finishPresentBtn.selected = model.is_show == 0 || model.is_show == 1;
    if (!self.finishPresentBtn.selected) {
        self.finishPresentBtn.backgroundColor = [UIColor whiteColor];
        [self.finishPresentBtn setTitleColor:HKColorFromHex(0xff6600, 1.0) forState:UIControlStateNormal];
    } else {
        [MobClick event:UM_RECORD_SIGNIN_PAGE_SIGN_BUTTON];
        [self.finishPresentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.finishPresentBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        self.finishPresentBtn.layer.borderWidth = 1.0;
        self.finishPresentBtn.backgroundColor = [UIColor clearColor];
    }
    
}

- (void)setModel:(HKPresentHeaderModel *)model {
    _model = model;
    // 还原设置
    [self initBtns];
    
    self.HKCoinCountLB.text = model.gold_total;
    self.six.text = model.continue_num;
    // 设置按钮的选中
    [self setSelectedBtn:model];

    // 设置进度条
    CGFloat width = (UIScreenWidth - 18 * 2) / 7.0 * (model.continue_num.intValue - 1);
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:2.5 animations:^{
            self.orangeProgress.width = width > 0? width : 0;
        }];
    });

}

// 调整各个按钮的位置x
- (void)changeBtnCenterX {
    self.btn0.centerX = 18 + self.btn0.width * 0.5;
    self.btn6.centerX = self.btn6.superview.width - 18 - self.btn6.width * 0.5;
    
    self.btn3.centerX = self.btn3.superview.width * 0.5;
    
    self.btn1.centerX = (self.btn3.centerX - self.btn0.centerX ) / 3.0 + self.btn0.centerX;
    self.btn2.centerX = (self.btn3.centerX - self.btn0.centerX ) / 3.0 * 2.0 + self.btn0.centerX;
    
    self.btn4.centerX = (self.btn3.centerX - self.btn0.centerX ) / 3.0 * 4 + self.btn0.centerX;
    self.btn5.centerX = (self.btn3.centerX - self.btn0.centerX ) / 3.0 * 5 + self.btn0.centerX;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self changeBtnCenterX];
    });
}

- (void)dealloc{
    
}

@end




