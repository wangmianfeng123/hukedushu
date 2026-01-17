//
//  HKStatusBarView.m
//  Code
//
//  Created by eon Z on 2022/2/25.
//  Copyright © 2022 pg. All rights reserved.
//

#import "HKStatusBarView.h"

@interface HKStatusBarView ()
@property (nonatomic ,strong) UILabel * dateLabel;
@property (nonatomic ,strong) UILabel * batteryLabel;


@property (nonatomic ,strong) CAShapeLayer *lineLayer;
@property (nonatomic ,strong) CAShapeLayer *lineLayer2;
@property (nonatomic ,strong) CAShapeLayer *batteryLayer;


@property (nonatomic ,strong) UIImageView *batteryImg;

@end

@implementation HKStatusBarView

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.backgroundColor = [UIColor clearColor];
    /// 时间
    self.dateLabel = [[UILabel alloc]init];
    self.dateLabel.bounds = CGRectMake(0, 0, 100, 20);
    self.dateLabel.textColor = [UIColor whiteColor];
    self.dateLabel.font = [UIFont boldSystemFontOfSize:12];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.dateLabel];
    
    self.batteryLabel = [[UILabel alloc]init];
    self.batteryLabel.textColor = [UIColor whiteColor];
    self.batteryLabel.font = [UIFont systemFontOfSize:12];
    self.batteryLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.batteryLabel];
    
    [self addSubview:self.batteryImg];
}

-(UIImageView *)batteryImg{
    if (_batteryImg == nil) {
        // 是否在充电
        _batteryImg = [[UIImageView alloc]init];
        _batteryImg.image = [UIImage imageNamed:@"lightning"];
    }
    return _batteryImg;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.dateLabel.center = self.center;
    self.batteryLabel.frame = CGRectMake(self.bounds.size.width-35-50-2-TAR_BAR_XH, 4, 50, 16);

    self.batteryImg.bounds = CGRectMake(0, 0, 8, 12);
    self.batteryImg.center = CGPointMake(self.bounds.size.width-35-TAR_BAR_XH +10, 7+5);
}


- (void)showStatusBar:(BOOL)show{
    if (show) {
        self.hidden = NO;
        [self.lineLayer removeFromSuperlayer];
        [self.lineLayer2 removeFromSuperlayer];
        [self.batteryLayer removeFromSuperlayer];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateStyle:NSDateFormatterNoStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        self.dateLabel.text = dateString;

        /// 电池
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.bounds.size.width-35-TAR_BAR_XH, 7, 20, 10) cornerRadius:2.5];
        self.lineLayer = [CAShapeLayer layer];
        self.lineLayer.lineWidth = 1;
        self.lineLayer.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4].CGColor;
        self.lineLayer.path = bezierPath.CGPath;
        self.lineLayer.fillColor = nil; // 默认为blackColor
        [self.layer addSublayer:self.lineLayer];
        // 正极小玩意
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.bounds.size.width-35-TAR_BAR_XH+20+2, 7.5+3, 1, 3) byRoundingCorners:(UIRectCornerTopRight|UIRectCornerBottomRight) cornerRadii:CGSizeMake(2, 2)];
        self.lineLayer2 = [CAShapeLayer layer];
        self.lineLayer2.lineWidth = 0.5;
        self.lineLayer2.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4].CGColor;
        self.lineLayer2.path = path.CGPath;
        self.lineLayer2.fillColor = self.lineLayer.strokeColor; // 默认为blackColor
        [self.layer addSublayer:self.lineLayer2];
        
        
        // 当前的电池电量
        [UIDevice currentDevice].batteryMonitoringEnabled = YES;
        CGFloat batteryLevel = [UIDevice currentDevice].batteryLevel;
        UIColor *batteryColor;
        UIDeviceBatteryState batteryState = [UIDevice currentDevice].batteryState;
        if(batteryState == UIDeviceBatteryStateCharging || batteryState == UIDeviceBatteryStateFull){ // 在充电 绿色
            batteryColor = [UIColor colorWithHexString:@"#37CB46"];
            self.batteryImg.hidden = NO;
        }else{
            if(batteryLevel <= 0.2){ // 电量低
                if([NSProcessInfo processInfo].lowPowerModeEnabled){ // 开启低电量模式 黄色
                    batteryColor = [UIColor colorWithHexString:@"#F9CF0E"];
                }else{ // 红色
                    batteryColor = [UIColor colorWithHexString:@"#F02C2D"];
                }
            }else{ // 电量正常 白色
                batteryColor = [UIColor whiteColor];
            }
            self.batteryImg.hidden = YES;
        }

        UIBezierPath *batteryPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.bounds.size.width-35-TAR_BAR_XH +1.5, 7+1.5, (20-3)*batteryLevel, 10-3) cornerRadius:2];
        self.batteryLayer = [CAShapeLayer layer];
        self.batteryLayer.lineWidth = 1;
        self.batteryLayer.strokeColor = [UIColor clearColor].CGColor;
        self.batteryLayer.path = batteryPath.CGPath;
        self.batteryLayer.fillColor = batteryColor.CGColor; // 默认为blackColor
        [self.layer addSublayer:self.batteryLayer];
        
        
        [self bringSubviewToFront:self.batteryImg];
        self.batteryLabel.text = [NSString stringWithFormat:@"%.0f%%",batteryLevel*100];
    }else{
        self.hidden = YES;
    }
    
}

@end
