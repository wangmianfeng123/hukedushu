//
//  HKDayTaskHeaderView.m
//  Code
//
//  Created by yxma on 2020/8/27.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKDayTaskHeaderView.h"
#import "HKTrainDetailModel.h"
#import "UIView+HKLayer.h"
#import "UIImage+XLExtension.h"

@interface HKDayTaskHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (weak, nonatomic) IBOutlet UILabel *txtLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UILabel *dowloadLabel;
@property (weak, nonatomic) IBOutlet UIButton *fetchBtn;
@property (weak, nonatomic) IBOutlet UIView *giftView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *txtBottomMargin;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation HKDayTaskHeaderView


-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = COLOR_F8F9FA_333D48;
    self.contentView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.txtLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 60;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.bgImgView addGradientLayerColors:@[(id)[UIColor colorWithHexString:@"#56E1A7"].CGColor,(id)[UIColor colorWithHexString:@"#33CEB2"].CGColor]];
    [self addShadow:self.contentView];
}


- (void)addShadow:(UIView *)view{
    view.layer.cornerRadius = 5;
    view.layer.shadowOffset = CGSizeMake(2,2);
    view.layer.shadowColor = [UIColor colorWithHexString:@"#D2D6E4"].CGColor;
    view.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    view.layer.shadowRadius = 5;//阴影半径，默认3
    view.clipsToBounds = NO;
}

-(void)setTaskDetailModel:(HKDayTaskModel *)taskDetailModel{
    _taskDetailModel = taskDetailModel;
    self.dateLabel.text = taskDetailModel.date;
    self.daysLabel.text = [NSString stringWithFormat:@"Day-%d",taskDetailModel.days];
    self.txtLabel.text = taskDetailModel.name;
    self.dowloadLabel.text = taskDetailModel.gift.name;
    
    self.giftView.hidden = taskDetailModel.gift.display ? NO : YES;
    if ([taskDetailModel.gift.display isEqualToString:@"1"]) {
        self.giftView.hidden = NO;
        self.txtBottomMargin.constant = 60;
    }else{
        self.giftView.hidden = YES;
        self.txtBottomMargin.constant = 20;
    }
    
    self.txtLabel.numberOfLines = 0;
    if (self.taskDetailModel.gift.is_get) {
        self.fetchBtn.userInteractionEnabled = YES;
        UIColor *color = [UIColor colorWithHexString:@"#ff8c00"];
        UIColor *color1 = [UIColor colorWithHexString:@"#ffa000"];
        UIColor *color2 = [UIColor colorWithHexString:@"#ffb200"];
        UIImage *imageTemp = [[UIImage alloc]createImageWithSize:CGSizeMake(60, 25) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
        [self.fetchBtn setBackgroundImage:imageTemp forState:UIControlStateNormal];
        [self.fetchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        self.fetchBtn.userInteractionEnabled = NO;
        [self.fetchBtn setBackgroundColor:COLOR_EFEFF6_7B8196 forState:UIControlStateNormal];
        [self.fetchBtn setTitleColor:COLOR_A2A2BE forState:UIControlStateNormal];
    }
    self.dateLabel.textColor = COLOR_27323F_EFEFF6;
    self.daysLabel.textColor =COLOR_27323F_EFEFF6;
    self.txtLabel.textColor = COLOR_27323F_EFEFF6;

}

- (IBAction)backBtnClick {
    if (self.backBtnBlock) {
        self.backBtnBlock();
    }
}

- (IBAction)fetchBtnClick {
    [MobClick event:dailytask__takeaward];
    NSURL *url = [NSURL URLWithString:self.taskDetailModel.gift.address];
    if (HKSystemVersion > 10.0) {
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                
            }];
        }
    }else{
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}
@end
