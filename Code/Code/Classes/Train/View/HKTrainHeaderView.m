
//
//  HKTrainHeaderView.m
//  Code
//
//  Created by hanchuangkeji on 2019/1/15.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKTrainHeaderView.h"
#import "UIView+SNFoundation.h"
#import "HKTrainProblemView.h"


@interface HKTrainHeaderView()

@property (weak, nonatomic) IBOutlet UIView *containerView0;//开启训练营
@property (weak, nonatomic) IBOutlet UIImageView *bgIV;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UILabel *daysLB;
@property (weak, nonatomic) IBOutlet UILabel *dayDaysDesLB;

@property (weak, nonatomic) IBOutlet UIView *greenProgressV;
@property (weak, nonatomic) IBOutlet UIView *whiteProgressV;
@property (weak, nonatomic) IBOutlet UIButton *progressBtn;
@property (weak, nonatomic) IBOutlet UILabel *progressZeroLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *greenWidth;

// 已经结束
@property (weak, nonatomic) IBOutlet UIView *containerView1; //已结束
@property (weak, nonatomic) IBOutlet UIImageView *bgIV2;
@property (weak, nonatomic) IBOutlet UILabel *endStateLB;
@property (weak, nonatomic) IBOutlet UILabel *endStateDetailLB;
@property (weak, nonatomic) IBOutlet UIButton *seeCerBtn;


@end

@implementation HKTrainHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 背景渐变
    UIColor *color = [UIColor colorWithHexString:@"#54dfa8"];
    UIColor *color1 = [UIColor colorWithHexString:@"#44d7ac"];
    UIColor *color2 = [UIColor colorWithHexString:@"#35cfb2"];
    UIImage *imageTemp = [[UIImage alloc]createImageWithSize:CGSizeMake(375, 98 * 0.5) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.3),@(1)] gradientType:GradientFromLeftToRight];
    self.bgIV.image = imageTemp;
    self.containerView0.clipsToBounds = YES;
    self.containerView0.layer.cornerRadius = 5.0;
    self.bgIV.clipsToBounds = YES;
    self.bgIV.layer.cornerRadius = 5.0;
    self.bgIV2.image = imageTemp;
    self.containerView1.clipsToBounds = YES;
    self.containerView1.layer.cornerRadius = 5.0;
    self.bgIV2.clipsToBounds = YES;
    self.bgIV2.layer.cornerRadius = 5.0;
    [self.containerView1 sendSubviewToBack:self.bgIV2];
    
    // 圆角
    self.greenProgressV.clipsToBounds = YES;
    self.greenProgressV.layer.cornerRadius = self.greenProgressV.height * 0.5;
    self.whiteProgressV.clipsToBounds = YES;
    self.whiteProgressV.layer.cornerRadius = self.whiteProgressV.height * 0.5;
    self.seeCerBtn.clipsToBounds = YES;
    self.seeCerBtn.layer.cornerRadius = self.greenProgressV.height * 0.5;
    
    // 阴影
    [self.whiteProgressV addShadowWithColor:HKColorFromHex(0x25BEA2, 1.0) alpha:1.0 radius:8 offset:CGSizeMake(0, 2)];
    [self.containerView0 addShadowWithColor:HKColorFromHex(0xE1E7EB, 1.0) alpha:1.0 radius:6 offset:CGSizeMake(0, 3)];
    [self.containerView1 addShadowWithColor:HKColorFromHex(0xE1E7EB, 1.0) alpha:1.0 radius:6 offset:CGSizeMake(0, 3)];
    [self setShadowColor];
    self.backgroundColor = COLOR_FFFFFF_3D4752;
}


- (void)dmTraitCollectionDidChange:(DMTraitCollection *)previousTraitCollection {
    if (@available(iOS 13.0, *)) {
        // 主题模式 发生改变
        [self setShadowColor];
    }
}



- (void)setShadowColor {
    UIColor *whiteProgressShadowColor = [UIColor hkdm_colorWithColorLight:COLOR_25BEA2 dark:[UIColor clearColor]];
    UIColor *shadowColor = [UIColor hkdm_colorWithColorLight:COLOR_E1E7EB dark:[UIColor clearColor]];
    [self.whiteProgressV addShadowWithColor:whiteProgressShadowColor alpha:1.0 radius:8 offset:CGSizeMake(0, 2)];
    [self.containerView0 addShadowWithColor:shadowColor alpha:1.0 radius:6 offset:CGSizeMake(0, 3)];
    [self.containerView1 addShadowWithColor:shadowColor alpha:1.0 radius:6 offset:CGSizeMake(0, 3)];
}




- (IBAction)seeCerBtnClick:(id)sender {
    !self.seeCerBtnClickBlock? : self.seeCerBtnClickBlock();
}


- (void)setDetailModel:(HKTrainDetailModel *)detailModel {
    
    _detailModel = detailModel;
    
    // 百分比
    NSString *progressFloat = [NSString stringWithFormat:@"%.0f%%", detailModel.user_task_day * 100.0 / (detailModel.total_days * 1.0)];
    
    // 训练营的状态(0:未开始 1:进行中 2:已结束)
    if (detailModel.state == 2) {
        self.containerView1.hidden = NO;
        //self.endStateDetailLB.text = detailModel.taskProgress.content;
        self.containerView0.hidden = YES;
        self.seeCerBtn.hidden = progressFloat.floatValue / 100.0 < 1.0;
        
    } else {
        self.containerView1.hidden = YES;
        self.containerView0.hidden = NO;
        self.daysLB.text = [NSString stringWithFormat:@"已打卡%ld天/%ld天", (long)detailModel.user_task_day, (long)detailModel.total_days];
        self.detailLabel.text = [NSString stringWithFormat:@"当前排名%ld 打败了%ld%%的用户",(long)detailModel.rankInfo.rank,(long)detailModel.rankInfo.rankPcent];
        self.dayDaysDesLB.text = [NSString stringWithFormat:@"打卡%ld天，报名费全额返",(long)detailModel.total_days];
        
        // 打卡率为0
        if (detailModel.user_task_day == 0 ) {
            self.progressZeroLB.hidden = NO;
        } else {
            self.progressZeroLB.hidden = YES;
        }
        self.progressBtn.hidden = !self.progressZeroLB.hidden;
        
        [self.progressBtn setTitle:progressFloat forState:UIControlStateNormal];
        
        // 相应拉长进度
        CGFloat progressWidth = self.whiteProgressV.width * progressFloat.floatValue / 100.0;
        self.greenWidth.constant = progressWidth;
        if (detailModel.state == 0) {
            self.detailLabel.hidden = YES;
        }
    }
}

- (IBAction)problemBtnClick: (UIButton *)sender{
    UIWindow * window = [[UIApplication sharedApplication]keyWindow];
    
    CGPoint point = [self.containerView0 convertPoint:sender.center toView:window];
    HKTrainProblemView * problemView = [HKTrainProblemView createViewFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [problemView layoutSubviews];
    [problemView setSubVCenter:point];
}

@end
