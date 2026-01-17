//
//  HKLivePlayerInfoView.m
//  Code
//
//  Created by hanchuangkeji on 2018/10/19.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKLivePlayerInfoView.h"
#import "NSTimer+FOF.h"
#import <YYText/YYText.h>
#import <YYText/YYTextContainerView.h>
#import "HKLiveListModel.h"


@interface HKLivePlayerInfoView()
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *middleBtn;
@property (weak, nonatomic) IBOutlet UILabel *infoLB;
@property (nonatomic, strong)LOTAnimationView *animation;
@property (weak, nonatomic) IBOutlet UIView *blackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backBtnCon;

@property (weak, nonatomic) IBOutlet UIView *blackView10Percent;
// 正在直播
@property (weak, nonatomic) IBOutlet UIButton *livingBtn;
@property (strong, nonatomic) YYLabel *livingLB;

// 直播倒计时
@property (nonatomic, weak)NSTimer *timer;

@property (nonatomic, assign)NSInteger countDown;
@property (weak, nonatomic) IBOutlet UILabel *waittingForLookBackLB;

@end

@implementation HKLivePlayerInfoView

- (YYLabel *)livingLB {
    if (_livingLB == nil) {
        _livingLB = [[YYLabel alloc] init];
        _livingLB.font = [UIFont systemFontOfSize:15.0];
        _livingLB.textColor = [UIColor whiteColor];
    }
    return _livingLB;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.middleBtn.clipsToBounds = YES;
    self.middleBtn.layer.cornerRadius = self.middleBtn.height * 0.5;
    self.middleBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.middleBtn.layer.borderWidth = 1.0;
    
    [self addSubview:self.livingLB];
    [self.livingLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.infoLB).offset(5);
    }];
    
    // 动画的宽高
    self.animation.height = 11;
    self.animation.width = 15;
    
    self.infoLB.hidden = YES;
    self.middleBtn.hidden = YES;
    self.waittingForLookBackLB.hidden = YES;
    self.livingBtn.hidden = YES;
    self.livingLB.hidden = YES;
    
    if (IS_IPHONE_X) {
        self.backBtnCon.constant = 40;
    }
    
}

- (IBAction)backBtnClick:(id)sender {
    !self.backBtnClickBlock? : self.backBtnClickBlock();
}

- (IBAction)shareBtnClick:(id)sender {
    !self.shareBtnClickBlock? : self.shareBtnClickBlock();
}

- (IBAction)middleBtnClick:(id)sender {
    !self.middleBtnClickBlock? : self.middleBtnClickBlock();
}

- (void)setModel:(HKLiveDetailModel *)model {
    
    
    // 设置中间信息按钮Btn
    switch (model.live.live_status) {
        case HKLiveStatusNotStart:// 尚未开始直播
        {
            model.free_learn = NO;
            NSString *title = nil;
            if (!model.isEnroll) {
                title = model.live.free_learn ?@"免费试学" :@"报名后观看直播";
            } else {
                title = model.live.free_learn ?@"免费试学" :@"点击进入直播间";
            }
            [self.middleBtn setTitle:title forState:UIControlStateNormal];
        }
            break;
        case HKLiveStatusLiving: // 开始直播
        {
            NSString *title = nil;
            if (!model.isEnroll) {
                title = model.live.free_learn ?@"开始免费试学,进入直播间" :@"报名后观看直播";
            } else {
                title = model.live.free_learn ?@"点击观看直播" :@"点击观看直播";
            }
            [self.middleBtn setTitle:title forState:UIControlStateNormal];
        }
            break;
        case HKLiveStatusEnd: // 已经结束直播
        {
            NSString *title = nil;
            if (!model.isEnroll) {
                title = model.live.free_learn ?@"开始免费试学" :@"报名后观看回放";
                
            } else {
                title = model.live.free_learn ?@"点击观看回放" :@"点击观看回放";
            }
            [self.middleBtn setTitle:title forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
    
    // 设置中间信息按钮Label
    self.infoLB.hidden = YES;
    self.middleBtn.hidden = YES;
    self.waittingForLookBackLB.hidden = YES;
    self.livingBtn.hidden = YES;
    self.livingLB.hidden = YES;
    
    // 重置倒计时
    self.countDown = model.live.coutDownForLive;
    [self resetMyTimer];
    
    // 不足一个小时倒计时 并还没开始直播
    if (model.live.coutDownForLive > 0 && model.live.live_status == HKLiveStatusNotStart) {// 倒计时
        self.middleBtn.hidden = NO;
        self.infoLB.hidden = NO;

    } else if (([model.live.video_id isEqualToString:@"0"] || model.live.video_id == nil) && model.live.live_status == HKLiveStatusEnd) { // 录播视频即将上线

        self.waittingForLookBackLB.hidden = NO;
        
        // 修改行间距
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:4];
        
        NSMutableAttributedString *attrString = nil;
        
        if (!model.live.can_replay) {
            attrString = [[NSMutableAttributedString alloc] initWithString:@"本期直播已结束"];
            [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium] range:NSMakeRange(0, attrString.length)];
            [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attrString.length)];
            [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrString.length)];
        } else {
            attrString = [[NSMutableAttributedString alloc] initWithString:@"本期直播已结束\n录播视频即将上线"];
            [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium] range:NSMakeRange(0, attrString.length)];
            [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(7, attrString.length - 7)];
            [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attrString.length)];
            [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrString.length)];
        }
        
        
        self.waittingForLookBackLB.attributedText = attrString;

    } else if (model.live.video_id.intValue != 0 && model.live.live_status == HKLiveStatusEnd) { // 录播视频已可观看

        // 回放
        self.middleBtn.hidden = NO;
        
    } else if ((model.live.live_status == HKLiveStatusLiving || (model.live.live_status == HKLiveStatusNotStart && model.live.coutDownForLive < 0)) && ((!model.isEnroll && model.live.price.doubleValue > 0) || ![HKAccountTool shareAccount])) {
        // 正在直播并且需要付费，并且没有报名 或者没有登录
        self.middleBtn.hidden = NO;
        self.infoLB.hidden = NO;
        self.infoLB.text = [NSString stringWithFormat:@"正在直播中"];
    } else if (model.live.live_status == HKLiveStatusLiving || (model.live.live_status == HKLiveStatusNotStart && model.live.coutDownForLive < 0)) { // 正在直播
        
        self.livingBtn.hidden = NO;
        self.livingLB.hidden = NO;
        
        
        // 嵌入 UIView
        NSMutableAttributedString *text = [NSMutableAttributedString new];
        UIFont *font = [UIFont systemFontOfSize:15];
        
        NSMutableAttributedString *attachment = nil;
        
        attachment = [NSMutableAttributedString yy_attachmentStringWithContent:self.animation contentMode:UIViewContentModeBottom attachmentSize:self.animation.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        [text appendAttributedString: attachment];
        
        // 标题
        NSString *practiceString = @"  正在直播，点击进入学习~";
        attachment = [[NSMutableAttributedString alloc] initWithString:practiceString];
        [attachment addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, practiceString.length)];
        [attachment addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, practiceString.length)];
        [text appendAttributedString:attachment];
        self.livingLB.attributedText = text;

    } else if (model.live.coutDownMoreThanOneHourForLive) {
        // 直播开始时间大于一个小时
        self.middleBtn.hidden = YES;
    } else {
        self.middleBtn.hidden = NO;
        self.infoLB.hidden = YES;
        self.self.waittingForLookBackLB.hidden = YES;
    }
    
    // 遮罩层
    self.blackView.hidden = (!self.middleBtn.hidden || !self.livingBtn.hidden || !self.infoLB.hidden || !self.waittingForLookBackLB.hidden)? NO : YES;
    self.blackView10Percent.hidden = !self.blackView.hidden;

}


- (LOTAnimationView *)animation {
    if (!_animation) {
        _animation = [LOTAnimationView animationNamed:@"playing.json"];
        _animation.loopAnimation = YES;
        [_animation playWithCompletion:^(BOOL animationFinished) {
            
        }];
    }
    return _animation;
}

- (IBAction)playingBtnClick:(id)sender {
    !self.livingBtnClickBlock? : self.livingBtnClickBlock();
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
        
        NSString *str = [NSString stringWithFormat:@"直播开始倒计时  00:%@:%@", minuteString, secondString];
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, attrString.length)];
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attrString.length)];
        [attrString addAttribute:NSForegroundColorAttributeName value:HKColorFromHex(0xFFD305, 1.0) range:NSMakeRange(attrString.length - 8, 8)];
        
        self.infoLB.attributedText = attrString;
        
        if (self.countDown == 0) {
            // 通知倒计时结束，正在直播了
            !self.countdownEndDataBlock? : self.countdownEndDataBlock();
        }
        
    }else {
        !self.timer? : [self.timer invalidate];
        self.timer = nil;
    }
}


- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
