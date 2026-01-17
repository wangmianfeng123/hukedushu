//
//  HKStudyHeaderCell.m
//  Code
//
//  Created by hanchuangkeji on 2019/6/13.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKStudyHeaderCell.h"
#import "UIView+HKExtension.h"
#import "UIView+SNFoundation.h"

@interface HKStudyHeaderCell()

@property (weak, nonatomic) IBOutlet UIButton *medalBtn;

@property (weak, nonatomic) IBOutlet UILabel *learnCountLB;
@property (weak, nonatomic) IBOutlet UILabel *todayCountLB;
@property (weak, nonatomic) IBOutlet UIButton *medalCountBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *myLearnLB;
@property (weak, nonatomic) IBOutlet UILabel *todayBottomLB;
@property (weak, nonatomic) IBOutlet UIImageView *todayImageView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation HKStudyHeaderCell


- (void)dmTraitCollectionDidChange:(DMTraitCollection *)previousTraitCollection {
    
    if (@available(iOS 13.0, *)) {
        // 主题模式 发生改变
        [self setBgViewShadowColor];
    }
}


#pragma mark -  阴影
- (void)setBgViewShadowColor {
    UIColor *shadowColor = [UIColor hkdm_colorWithColorLight:HKColorFromHex(0xDAE3E9, 1.0) dark:COLOR_333D48];
    CGFloat alpha = 0.3;
    if (@available(iOS 13.0, *)) {
        alpha = (DMUserInterfaceStyleDark == DMTraitCollection.currentTraitCollection.userInterfaceStyle) ? 0.7 :0.3;
    }
    [self.bgView addShadowWithColor:shadowColor alpha:alpha radius:4 offset:CGSizeMake(0, 4)];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.medalCountBtn.clipsToBounds = YES;
    self.medalCountBtn.layer.cornerRadius = self.medalCountBtn.height * 0.5;
    
    [self setBgViewShadowColor];
    
    // 勋章渐变的背景
    UIColor *color = [UIColor colorWithHexString:@"#ffba31"];
    UIColor *color1 = [UIColor colorWithHexString:@"#ffc61b"];
    UIColor *color2 = [UIColor colorWithHexString:@"#ffd206"];
    UIImage *imageTemp = [[UIImage alloc]createImageWithSize:CGSizeMake(307 * 0.5, 98 * 0.5) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
    [self.medalBtn setBackgroundImage:imageTemp forState:UIControlStateNormal];
    self.medalBtn.clipsToBounds = YES;
    self.medalBtn.layer.cornerRadius = self.medalBtn.height * 0.5;
    
    // 今日点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(todayLBClick)];
    self.todayCountLB.userInteractionEnabled = YES;
    [self.todayCountLB addGestureRecognizer:tap];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(todayLBClick)];
    self.todayBottomLB.userInteractionEnabled = YES;
    [self.todayBottomLB addGestureRecognizer:tap1];    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(todayLBClick)];
    self.todayImageView.userInteractionEnabled = YES;
    [self.todayImageView addGestureRecognizer:tap2];
    
    
    self.myLearnLB.textColor = [UIColor hkdm_colorWithColorLight:COLOR_27323F dark:COLOR_EFEFF6];
    //HKColorFromHex(0x27323f, 1.0);
    self.myLearnLB.font = [UIFont systemFontOfSize:21.0 weight:UIFontWeightBold];
    
    [self.learnCountLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.todayCountLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    self.contentView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.bgView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.lineView.backgroundColor = [UIColor hkdm_colorWithColorLight:COLOR_EFEFF6 dark:COLOR_27323F];
}

- (void)todayLBClick {
    !self.todayLBClickBlock? : self.todayLBClickBlock();
}


- (IBAction)medalBtnClick:(id)sender {
    [MobClick event:STUDY_XUNZHANGCHENGJIU];
    !self.medalBtnClickBlock? : self.medalBtnClickBlock();
}

- (void)setModel:(HKMyLearningCenterModel *)model {
    
    if (!model) return;
    _model = model;
    
    // 获取勋章
    if (model.achievement_info.unclaimedAchieveCount > 0) {
        self.medalCountBtn.hidden = NO;
        NSString *str = [NSString stringWithFormat:@"%ld", model.achievement_info.unclaimedAchieveCount];
        [self.medalCountBtn setTitle:str forState:UIControlStateNormal];
    } else {
        self.medalCountBtn.hidden = YES;
    }
    
    model.studyStats.full_count = isEmpty(model.studyStats.full_count) ?@"0" : model.studyStats.full_count;
    model.studyStats.today_count = isEmpty(model.studyStats.today_count) ?@"0" : model.studyStats.today_count;
    
    UIColor *countColor = [UIColor hkdm_colorWithColorLight:COLOR_0A1A39 dark:COLOR_ffffff];
    // 累计学习
    NSString *countStr = [NSString stringWithFormat:@"%@ 节", model.studyStats.full_count];
    NSMutableAttributedString *learnCountLBStr = [[NSMutableAttributedString alloc] initWithString:countStr];
//    [learnCountLBStr addAttribute:NSForegroundColorAttributeName value:HKColorFromHex(0x7B8196, 1.0) range:NSMakeRange(0, countStr.length)];
//    [learnCountLBStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, countStr.length)];
    // 节
    NSRange jieRange = [countStr rangeOfString:@"节"];
    if (jieRange.location != NSNotFound) {
        [learnCountLBStr addAttribute:NSForegroundColorAttributeName value:HKColorFromHex(0xA8ABBE, 1.0) range:jieRange];
        [learnCountLBStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0] range:jieRange];
    }
    
    // 多少课
    NSRange keRange = [countStr rangeOfString:model.studyStats.full_count];
    if (keRange.location != NSNotFound) {
        [learnCountLBStr addAttribute:NSForegroundColorAttributeName value:countColor range:keRange];
        [learnCountLBStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:38 weight:UIFontWeightSemibold] range:keRange];
        self.learnCountLB.attributedText = learnCountLBStr;
    }
    
    // 今日学习2
    NSString *todayCountStr = [NSString stringWithFormat:@"%@ 节", model.studyStats.today_count];
    NSMutableAttributedString *todayLearnCountLBStr = [[NSMutableAttributedString alloc] initWithString:todayCountStr];
//    [todayLearnCountLBStr addAttribute:NSForegroundColorAttributeName value:HKColorFromHex(0x7B8196, 1.0) range:NSMakeRange(0, todayCountStr.length)];
//    [todayLearnCountLBStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, todayCountStr.length)];
    
    // 节
    NSRange todayJieRange = [todayCountStr rangeOfString:@"节"];
    if (todayJieRange.location != NSNotFound) {
        [todayLearnCountLBStr addAttribute:NSForegroundColorAttributeName value:HKColorFromHex(0xA8ABBE, 1.0) range:todayJieRange];
        [todayLearnCountLBStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0] range:todayJieRange];

    }
    
    // 多少课
    NSRange todayKeRange = [todayCountStr rangeOfString:model.studyStats.today_count];

    if (todayKeRange.location != NSNotFound) {
        [todayLearnCountLBStr addAttribute:NSForegroundColorAttributeName value:countColor range:todayKeRange];
        [todayLearnCountLBStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:38 weight:UIFontWeightSemibold] range:todayKeRange];
        self.todayCountLB.attributedText = todayLearnCountLBStr;

    }
}



- (void)layoutSubviews {
    [super layoutSubviews];
    [self.learnCountLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.todayCountLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.learnCountLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lineView);
        make.centerX.equalTo(self.lineView.mas_centerX).offset(-self.width/4);
    }];
    
    [self.todayCountLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lineView);
        make.centerX.equalTo(self.lineView.mas_centerX).offset(self.width/4);
    }];
}


@end

