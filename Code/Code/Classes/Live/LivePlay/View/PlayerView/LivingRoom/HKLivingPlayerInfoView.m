//
//  HKLivingPlayerInfoView.m
//  Code
//
//  Created by hanchuangkeji on 2018/10/22.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKLivingPlayerInfoView.h"
#import "NSTimer+FOF.h"


@interface HKLivingPlayerInfoView()

@property (weak, nonatomic) IBOutlet UILabel *lvingRightNowLB;
@property (weak, nonatomic) IBOutlet UILabel *countDownLB;

@property (weak, nonatomic) IBOutlet UILabel *teacherComingSoonLB;
@property (weak, nonatomic) IBOutlet UIView *waitingTeacherAnimationView;

@property (weak, nonatomic) IBOutlet UILabel *titleLB;

// 等待教师loading
@property (nonatomic, strong)LOTAnimationView *animation;
@property (nonatomic, assign)NSInteger countDown;

// 直播倒计时
@property (nonatomic, weak)NSTimer *timer;

@end

@implementation HKLivingPlayerInfoView

- (void)awakeFromNib {
    [super awakeFromNib];

    self.lvingRightNowLB.hidden = YES;
    self.countDownLB.hidden = YES;
    self.teacherComingSoonLB.hidden = YES;
    self.self.waitingTeacherAnimationView.hidden = YES;
    
    self.backgroundColor = [UIColor clearColor];
    [self.waitingTeacherAnimationView addSubview:self.animation];
    
}

- (IBAction)backBtnClick:(id)sender {
    !self.backBtnClickBlock? : self.backBtnClickBlock();
}

- (IBAction)fullOrSmallBtnClick:(id)sender {
    !self.fullOrSmallBtnClickBlock? : self.fullOrSmallBtnClickBlock();
}

- (IBAction)refreshBtnClick:(id)sender {
    !self.refreshBtnClickBlock? : self.refreshBtnClickBlock();
}

- (IBAction)courseDetailBtnClick:(id)sender {
    !self.courseDetailBtnClickBlock? : self.courseDetailBtnClickBlock();
}


- (LOTAnimationView *)animation {
    if (!_animation) {
        _animation = [LOTAnimationView animationNamed:@"playerLoading.json"];
        _animation.loopAnimation = YES;
        [_animation playWithCompletion:^(BOOL animationFinished) {
            
        }];
        _animation.height = 18 * 2;
        _animation.width = 91;
    }
    return _animation;
}

- (void)setModel:(HKLiveDetailModel *)model {
    _model = model;
    self.titleLB.text = model.course.name;
    
    self.lvingRightNowLB.hidden = YES;
    self.countDownLB.hidden = YES;
    self.teacherComingSoonLB.hidden = YES;
    self.self.waitingTeacherAnimationView.hidden = YES;
    
    // 重置倒计时
    self.countDown = model.live.coutDownForLive;
    [self resetMyTimer];
    
    // 倒计时
    if (model.live.coutDownForLive > 0 && model.live.live_status != HKLiveStatusLiving && model.live.live_status != HKLiveStatusEnd) {
         self.countDownLB.hidden = self.lvingRightNowLB.hidden = NO;
    } else if (model.live.coutDownForLive < 0 && model.live.live_status != HKLiveStatusLiving && model.live.live_status != HKLiveStatusEnd) { // 老师正在赶来2
        self.waitingTeacherAnimationView.hidden = self.teacherComingSoonLB.hidden = NO;
    } else if (model.live.live_status == HKLiveStatusEnd) {// 直播结束了
        self.lvingRightNowLB.text = @"本期直播已结束";
        self.lvingRightNowLB.hidden = NO;
    }
    
    if (model.playerPlaying || model.live.live_status == HKLiveStatusLiving) {
        self.hidden = YES;
    }else {
       self.hidden = NO;
    }
}

- (void)resetMyTimer {
    
    if (self.countDown > 0 && _timer == nil) {
        _timer = [NSTimer tb_scheduledTimerWithTimeInterval:1.0 block:^{
            [self countingCoin];
        } repeats:YES];
    } else if (self.countDown <= 0) {
        
        if (self.timer != nil) {
            [self.timer invalidate];
            self.timer = nil;
        }
    }
}


- (void)countingCoin {
    
    self.countDown--;
    
    if (self.countDown >= 0 && self.model.live.live_status == HKLiveStatusNotStart) {
        NSInteger minute = self.countDown / 60;
        NSInteger second = self.countDown - minute * 60;
        
        NSString *minuteString = minute >= 10? [NSString stringWithFormat:@"%ld", minute] : [NSString stringWithFormat:@"0%ld", minute];
        NSString *secondString = second >= 10? [NSString stringWithFormat:@"%ld", second] : [NSString stringWithFormat:@"0%ld", second];
        
        NSString *str = [NSString stringWithFormat:@"倒计时  00:%@:%@", minuteString, secondString];
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium] range:NSMakeRange(0, attrString.length)];
        [attrString addAttribute:NSForegroundColorAttributeName value:HKColorFromHex(0xFFD305, 1.0) range:NSMakeRange(0, attrString.length)];
        
        self.countDownLB.attributedText = attrString;
        
        if (self.countDown == 0) {
            !self.refreshBtnClickBlock? : self.refreshBtnClickBlock();
        }
        
    }else {
        !self.timer? : [self.timer invalidate];
        self.timer = nil;
    }
}

@end
