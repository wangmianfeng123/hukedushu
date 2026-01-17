//
//  HKPresentHeader21.m
//  Code
//
//  Created by hanchuangkeji on 2018/6/14.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKPresentHeader21.h"
#import "UIView+SNFoundation.h"
#import "HKvipImage.h"
#import "HKSwitchBtn.h"
#import "UIView+Banner.h"
#import "UIView+HKLayer.h"

@interface HKPresentHeader21()<HKSwitchBtnDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UIImageView *vipLogo;

@property (weak, nonatomic) IBOutlet UILabel *hkcoinCountLB;

@property (weak, nonatomic) IBOutlet UILabel *presentDaysLB;
@property (weak, nonatomic) IBOutlet UIView *presentDaysDetailView;
@property (weak, nonatomic) IBOutlet UIView *detailSeparatorView;
@property (weak, nonatomic) IBOutlet UILabel *coinTodayLB;

@property (nonatomic, strong)NSMutableArray<UIButton *> *daysTopArray;
@property (nonatomic, strong)NSMutableArray<UIButton *> *daysMiddleArray;
@property (nonatomic, strong)NSMutableArray<UIButton *> *daysBottomArray;
@property (weak, nonatomic) IBOutlet UIView *continueDaysView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backTop;
@property (weak, nonatomic) IBOutlet HKSwitchBtn *switchBtn;
@property (weak, nonatomic) IBOutlet UIView *continueDayView;
@property (weak, nonatomic) IBOutlet UIButton *medalBtn;
@property (weak, nonatomic) IBOutlet UIView *earnMoreBgView;
@property (weak, nonatomic) IBOutlet UILabel *earnMoreLB;
@property (weak, nonatomic) IBOutlet UILabel *signRemindLB;

@property (weak, nonatomic) IBOutlet UILabel *signDetailLB;
@property (weak, nonatomic) IBOutlet UIButton *setBtn;

@property (weak, nonatomic) IBOutlet UILabel *SignRewardLB;
@property (weak, nonatomic) IBOutlet UILabel *navTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *hkCoinLB;

@property (weak, nonatomic) IBOutlet UIView *headBgView;

@end

@implementation HKPresentHeader21

- (NSMutableArray<UIButton *> *)daysTopArray {
    if (_daysTopArray == nil) {
        _daysTopArray = [NSMutableArray array];
        for (int i = 0; i < 7; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.presentDaysDetailView addSubview:button];
            button.userInteractionEnabled = NO;
            [_daysTopArray addObject:button];
            button.titleLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightBold];
            [button setTitleColor:HKColorFromHex(0xFF8A00, 1.0) forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            button.clipsToBounds = YES;
            button.layer.cornerRadius = 34 * 0.5;
            // 第3或者第7天为大奖
            if (i == 2 || i == 6) {
                
                [button setBackgroundImage:imageName(@"ic_gift_pre_v2_1") forState:UIControlStateNormal];
                [button setBackgroundImage:imageName(@"ic_signin_gift_v2_7") forState:UIControlStateSelected];
            } else {
                [button setBackgroundImage:[UIImage imageWithColor:HKColorFromHex(0xFFF0E6, 1.0) size:CGSizeMake(34, 34)] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageWithColor:HKColorFromHex(0xFF7820, 1.0) size:CGSizeMake(34, 34)] forState:UIControlStateSelected];
            }
        }
    }
    return _daysTopArray;
}

- (NSMutableArray<UIButton *> *)daysMiddleArray {
    if (_daysMiddleArray == nil) {
        _daysMiddleArray = [NSMutableArray array];
        for (int i = 0; i < 7; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor orangeColor];
            button.userInteractionEnabled = NO;
            [self.presentDaysDetailView addSubview:button];
            [_daysMiddleArray addObject:button];
            button.clipsToBounds = YES;
            button.layer.cornerRadius = 10 * 0.5;
            [button setBackgroundImage:[UIImage imageWithColor:HKColorFromHex(0xFF7820, 1.0) size:CGSizeMake(10.0, 10.0)] forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage imageWithColor:HKColorFromHex(0xEFEFF6, 1.0) size:CGSizeMake(10.0, 10.0)] forState:UIControlStateNormal];
            
            UIImage *whiteImage = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(3, 3)];
            UIImage *whiteImage2 = [whiteImage roundCornerImageWithRadius:1.5];
            [button setImage:whiteImage2 forState:UIControlStateSelected];
            UIImage *whiteGrag = [UIImage imageWithColor:HKColorFromHex(0xCCCFDF, 1.0) size:CGSizeMake(3, 3)];
            UIImage *whiteGrag2 = [whiteGrag roundCornerImageWithRadius:1.5];
            [button setImage:whiteGrag2 forState:UIControlStateNormal];
        }
    }
    return _daysMiddleArray;
}

- (NSMutableArray<UIButton *> *)daysBottomArray {
    if (_daysBottomArray == nil) {
        _daysBottomArray = [NSMutableArray array];
        for (int i = 0; i < 7; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.userInteractionEnabled = NO;
            [self.presentDaysDetailView addSubview:button];
            [_daysBottomArray addObject:button];
            [button setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateSelected];
            [button setTitleColor:COLOR_A8ABBE_7B8196 forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:13.0];
        }
    }
    return _daysBottomArray;
}


- (void)dmTraitCollectionDidChange:(DMTraitCollection *)previousTraitCollection {
    if (@available(iOS 13.0, *)) {
        // 主题模式 发生改变
        UIColor *dyColor = [UIColor hkdm_colorWithColorLight:COLOR_E1E7EB dark:COLOR_333D48];
        [self.presentDaysDetailView addShadowWithColor:dyColor alpha:0.8 radius:5 offset:CGSizeMake(0, 2)];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 虎课商城按钮
    self.hkStoreBtn.clipsToBounds = YES;
    self.hkStoreBtn.layer.cornerRadius = 10.0;
    self.hkStoreBtn.layer.borderColor = HKColorFromHex(0xFF7820, 1.0).CGColor;
    self.hkStoreBtn.layer.borderWidth = 1.0;
    
    [self setPresentDaysDetail];
    
    // 设置阴影
    self.presentDaysDetailView.clipsToBounds = YES;
    self.presentDaysDetailView.layer.cornerRadius = 5.0;
    
//    UIColor *shadowColor = [UIColor hkdm_colorWithColorLight:COLOR_E1E7EB dark:COLOR_333D48];
//    [self.presentDaysDetailView addShadowWithColor:shadowColor alpha:0.8 radius:5 offset:CGSizeMake(0, 2)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(continueDaysViewTap)];
    [self.continueDaysView addGestureRecognizer:tap];
    
    
    if (IS_IPHONE_X) {
        self.contentTop.constant =  self.contentTop.constant + 20;
        self.backTop.constant =  self.backTop.constant + 20;
    }
    
    self.switchBtn.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.switchBtn.delegate = self;
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(continueDayViewTap)];
    [self.continueDayView addGestureRecognizer:tap2];
    
    //通知
    HK_NOTIFICATION_ADD(HKOpenNotification, updateSwitchBtnEnabled);
    HK_NOTIFICATION_ADD(HKCloseNotification, updateSwitchBtnEnabled);
    
    // 勋章按钮
    [self.medalBtn addRoundedCornersWithRadius:self.medalBtn.height * 0.5 byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft]; // 切除了左下 左上
    // 渐变颜色
    UIColor *color = [UIColor colorWithHexString:@"#ff8c00"];
    UIColor *color1 = [UIColor colorWithHexString:@"#ffa300"];
    UIColor *color2 = [UIColor colorWithHexString:@"#ffb200"];
    UIImage *imageTemp = [[UIImage alloc]createImageWithSize:CGSizeMake(76, 22) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
    [self.medalBtn setBackgroundImage:imageTemp forState:UIControlStateNormal];
        
    [self.setBtn addCornerRadius:8 addBoderWithColor:COLOR_A8ABBE_7B8196];
    [self hkDarkModel];
}

- (IBAction)setBtnClick {
    if (![CommonFunction isOpenNotificationSetting]) {
        
        // 检查推送开启
        [LEEAlert alert].config
        .LeeAddContent(^(UILabel *label) {
            label.text = @"小虎发现你还没有开启推送哦，请先打开推送才能开启签到提醒哦~";
            label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
        })
        .LeeAddAction(^(LEEAction *action) {
            
            action.type = LEEActionTypeCancel;
            action.title = @"放弃";
            action.titleColor = COLOR_333333;
            action.backgroundColor = [UIColor whiteColor];
        })
        .LeeAddAction(^(LEEAction *action) {
            
            action.type = LEEActionTypeDefault;
            action.title = @"立即开启";
            action.titleColor = COLOR_ff7c00;
            action.backgroundColor = [UIColor whiteColor];
            action.clickBlock = ^{
                [CommonFunction openNotificationSetting];
            };
        })
        .LeeHeaderColor([UIColor whiteColor])
        .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
        .LeeShow();
    }else{
        if (self.setBtnBlock) {
            self.setBtnBlock();
        }
    }
}

- (void)hkDarkModel {
    
    self.backgroundColor = COLOR_F8F9FA_333D48;
    self.continueDayView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.presentDaysDetailView.backgroundColor = COLOR_FFFFFF_3D4752;
    
    //self.detailSeparatorView.backgroundColor = COLOR_EFEFF6;
    self.earnMoreBgView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.earnMoreLB.textColor = COLOR_27323F_EFEFF6;
    
    self.signRemindLB.textColor = COLOR_27323F_EFEFF6;
    self.signDetailLB.textColor = COLOR_A8ABBE_7B8196;
    self.SignRewardLB.textColor = COLOR_7B8196_A8ABBE;
    [self.setBtn setTitleColor:COLOR_A8ABBE_7B8196 forState:UIControlStateNormal];
}

- (void)updateSwitchBtnEnabled {
    self.switchBtn.userInteractionEnabled = [CommonFunction isOpenNotificationSetting] || self.model.is_sign_notify;
}

- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}


- (void)continueDayViewTap {
    
    if (![CommonFunction isOpenNotificationSetting] && !self.model.is_sign_notify) {
        
        // 检查推送开启
        [LEEAlert alert].config
        .LeeAddContent(^(UILabel *label) {
            label.text = @"小虎发现你还没有开启推送哦，请先打开推送才能开启签到提醒哦~";
            label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
        })
        .LeeAddAction(^(LEEAction *action) {
            
            action.type = LEEActionTypeCancel;
            action.title = @"放弃";
            action.titleColor = COLOR_333333;
            action.backgroundColor = [UIColor whiteColor];
        })
        .LeeAddAction(^(LEEAction *action) {
            
            action.type = LEEActionTypeDefault;
            action.title = @"立即开启";
            action.titleColor = COLOR_ff7c00;
            action.backgroundColor = [UIColor whiteColor];
            action.clickBlock = ^{
                [CommonFunction openNotificationSetting];
            };
        })
        .LeeHeaderColor([UIColor whiteColor])
        .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
        .LeeShow();
    }
}
- (IBAction)medalBtnClick:(id)sender {
    !self.medalBtnClickBlock? : self.medalBtnClickBlock();
    
    
}


- (void)continueDaysViewTap {
    
    !self.continueDaysViewTapBlock? : self.continueDaysViewTapBlock();
}


/**
 设置签到详情
 */
- (void)setPresentDaysDetail {
    WeakSelf;
    [self.daysTopArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:34 leadSpacing:18 tailSpacing:18];
    [self.daysTopArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(34);
        make.top.mas_equalTo(weakSelf.presentDaysDetailView).offset(20 + 31);
    }];
    
    
    for (int i = 0; i < self.daysMiddleArray.count; i++) {
        UIView *view = self.daysMiddleArray[i];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10, 10));
            make.centerX.mas_equalTo(self.daysTopArray[i]);
            make.top.mas_equalTo(self.daysTopArray[i].mas_bottom).offset(9);
        }];
    }
    
    for (int i = 0; i < self.daysBottomArray.count; i++) {
        UIView *view = self.daysBottomArray[i];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 20.0));
            make.centerX.mas_equalTo(self.daysTopArray[i]);
            make.top.mas_equalTo(self.daysMiddleArray[i].mas_bottom).offset(6);
        }];
    }
    
    // 分割线
    [self.detailSeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.mas_equalTo(self.daysMiddleArray.firstObject);
        make.right.mas_equalTo(self.daysMiddleArray.lastObject);
        make.height.mas_equalTo(0.5);
    }];
}


/**
 返回

 @param sender 按钮
 */
- (IBAction)backAction:(id)sender {
    [self.tb_viewController.navigationController popViewControllerAnimated:YES];
    [MobClick event:TSKCENTER_XUNZHANG];
}


/**
 虎课商城点击

 @param sender 按钮
 */
- (IBAction)hkStoreBtnClick:(id)sender {
    [MobClick event:UM_RECORD_TSKCENTER_MALL];
    !self.btnStoreClickBlock? : self.btnStoreClickBlock();
}

- (void)setModel:(HKPresentHeaderModel *)model {
    _model = model;
    
    // 设置相关信息
    self.hkcoinCountLB.text = model.gold_total;
    self.nameLB.text = [HKAccountTool shareAccount].username.length? [HKAccountTool shareAccount].username : [HKAccountTool shareAccount].name;
    self.vipLogo.image = [HKvipImage comment_vipImageWithType:[HKAccountTool shareAccount].vip_class];
    
    // 联系签到几天
    if (model.is_show == 2) { // 抽奖
        NSString *dayString = @"点击签到";
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:dayString];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20 weight:UIFontWeightBold] range:NSMakeRange(0, dayString.length)];
        self.presentDaysLB.attributedText = attrString;
    } else {// 普通签到
        NSString *dayString = [NSString stringWithFormat:@"%@天", model.continue_num];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:dayString];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:81.5 * 0.5 weight:UIFontWeightBold] range:NSMakeRange(0, dayString.length)];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:28.5 * 0.5 weight:UIFontWeightBold] range:NSMakeRange(dayString.length - 1, 1)];
        self.presentDaysLB.attributedText = attrString;
    }
    
    self.coinTodayLB.text = [NSString stringWithFormat:@"今日已得%@币", model.today_gold];
    
    // 设置签到天数
    [self setDaysDetail:model];
    
    self.switchBtn.on = model.is_sign_notify;
    
    self.signDetailLB.text = [NSString stringWithFormat:@"提醒时间：%@:%@，%@",model.sign_notify_hour,model.j_push_hour_typeString,model.pushFrequency];

    
    self.switchBtn.userInteractionEnabled = [CommonFunction isOpenNotificationSetting] || model.is_sign_notify;
}

- (void)setDaysDetail:(HKPresentHeaderModel *)model {
    
    // 设置天数
    for (int i = 0; i < 7; i++) {
        UIButton *button = self.daysTopArray[i];
        button.selected = model.sign_list[i].is_sign;
        if (i == 2 || i == 6) continue;
        NSString *goldString = [NSString stringWithFormat:@"+%@", model.sign_list[i].gold];
        [button setTitle:goldString forState:UIControlStateNormal];
        button.selected = model.sign_list[i].is_sign;
    }
    
    // 设置中间点
    for (int i = 0; i < 7; i++) {
        UIButton *button = self.daysMiddleArray[i];
        button.selected = model.sign_list[i].is_sign;
    }
    
    // 设置底部天数
    for (int i = 0; i < 7; i++) {
        UIButton *button = self.daysBottomArray[i];
        [button setTitle:model.sign_list[i].date forState:UIControlStateNormal];
        button.selected = model.sign_list[i].is_sign;
    }
    
}


#pragma mark <HKSwitchBtnDelegate>
- (void)switchClick:(UISwitch*)sender {
    
    if (![CommonFunction isOpenNotificationSetting]) {
        self.switchBtn.userInteractionEnabled = NO;
    }
    
    !self.switchClickBlock? : self.switchClickBlock(sender.isOn);
}



@end
