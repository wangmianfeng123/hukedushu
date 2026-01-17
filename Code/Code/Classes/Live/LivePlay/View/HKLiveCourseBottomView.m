//
//  HKLiveCourseBottomView.m
//  Code
//
//  Created by hanchuangkeji on 2018/10/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKLiveCourseBottomView.h"
#import "HKLiveCoursePlayer.h"
#import "UIView+HKLayer.h"

@interface HKLiveCourseBottomView()
@property (weak, nonatomic) IBOutlet UIButton *buyNowBtn;
@property (weak, nonatomic) IBOutlet UILabel *ourPriceLB;
@property (weak, nonatomic) IBOutlet UIButton *contactTeacherBtn;


//预售模式增加的控件
@property (weak, nonatomic) IBOutlet UIView *advanceSaleView;
@property (weak, nonatomic) IBOutlet UIView *advanceSaleTimeView;
@property (weak, nonatomic) IBOutlet UILabel *advanceSaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *weikuanLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightPayTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *advanceSaleTimeViewHeight;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceBottomMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descLabelBottomMargin;

@end



@implementation HKLiveCourseBottomView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIColor *color = [UIColor colorWithHexString:@"#ff675e"];
    UIColor *color1 = [UIColor colorWithHexString:@"#ff7b42"];
    UIColor *color2 = [UIColor colorWithHexString:@"#ff9423"];
    UIImage *imageTemp = [[UIImage alloc]createImageWithSize:CGSizeMake(160, 49) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
    [self.buyNowBtn setBackgroundImage:imageTemp forState:UIControlStateNormal];
    [self.contactTeacherBtn setBackgroundImage:imageTemp forState:UIControlStateNormal];
    // 已报名
    [self.buyNowBtn setTitle:@"已报名" forState:UIControlStateSelected];
    [self.buyNowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    UIImage *seletedImg = [UIImage createImageWithColor:HKColorFromHex(0xa8abbe, 1.0)];
    [self.buyNowBtn setBackgroundImage:seletedImg forState:UIControlStateSelected];
    
    // 已经结束
    [self.buyNowBtn setTitle:@"已结束" forState:UIControlStateDisabled];
    [self.buyNowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    UIImage *endImg = [UIImage createImageWithColor:HKColorFromHex(0xa8abbe, 1.0)];
    [self.buyNowBtn setBackgroundImage:endImg forState:UIControlStateDisabled];
    self.hidden = YES;
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    [self.advanceSaleLabel addCornerRadius:7 addBoderWithColor:[UIColor colorWithHexString:@"#FF3221"]];
}

- (IBAction)buyBtnClick:(id)sender {
    NSLog(@"buyNowBtnBlock");
    !self.buyNowBtnBlock? : self.buyNowBtnBlock();
}

- (IBAction)contactTeacherBtnClick {
    !self.contectTeacherBlock? :self.contectTeacherBlock();
}

- (void)setModel:(HKLiveDetailModel *)model {
    _model = model;
    self.hidden = NO;
    CGFloat bottomHeight = 0;
    if (model.priceStrategy == 4) {
        self.advanceSaleView.hidden = NO;
        self.advanceSaleTimeView.hidden = NO;
        if (model.deposit.depositStage == 1) {//1未报名成功-预售模式-定金未支付；
            self.payTimeLabel.text = @"定金支付时间";
            self.rightPayTimeLabel.text = [NSString stringWithFormat:@"%@-%@",model.deposit.advance_start_at,model.deposit.advance_end_at];
            self.weikuanLabel.text = @"";
            self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.deposit.price];
            self.advanceSaleLabel.hidden = NO;
            self.descLabel.text = [NSString stringWithFormat:@"支付定金¥%@，限时抵¥%@",model.deposit.advance_deposit_price,model.deposit.depositDeduction];
            [self.payBtn setTitle:[NSString stringWithFormat:@"支付定金¥%@",model.deposit.advance_deposit_price] forState:UIControlStateNormal];
            [self.payBtn addGradientLayerColors:@[(id)[UIColor colorWithHexString:@"#FF6363"].CGColor,(id)[UIColor colorWithHexString:@"#FF961F"].CGColor]];
            self.payBtn.userInteractionEnabled = YES;
            bottomHeight = 84;
            self.descLabelBottomMargin.constant = IS_IPHONE_X ? 15 : 8;
        }else if (model.deposit.depositStage == 2){//未报名成功-预售模式-定金已支付-不在尾款支付时间；
            self.payTimeLabel.text = @"尾款支付时间";
            self.rightPayTimeLabel.text = [NSString stringWithFormat:@"%@-%@",model.deposit.pay_final_price_start_at,model.deposit.pay_final_price_end_at];
            self.weikuanLabel.text = @"尾款：";
            self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.deposit.advance_final_price];
            self.advanceSaleLabel.hidden = YES;
            self.descLabel.text = @"";
            [self.payBtn setTitle:@"定金已支付" forState:UIControlStateNormal];
            [self.payBtn setBackgroundColor:[UIColor colorWithHexString:@"#A8ABBE"]];
            self.payBtn.userInteractionEnabled = NO;
            bottomHeight = 84;
            self.descLabelBottomMargin.constant = 15;
        }else if (model.deposit.depositStage == 3){//未报名成功-预售模式-定金已支付-在尾款支付时间-非会员（或者有会员，但没有会员尾款优惠）；
            self.payTimeLabel.text = @"尾款支付时间";
            self.rightPayTimeLabel.text = [NSString stringWithFormat:@"%@-%@",model.deposit.pay_final_price_start_at,model.deposit.pay_final_price_end_at];
            self.weikuanLabel.text = @"尾款：";
            self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.deposit.advance_final_price];
            self.advanceSaleLabel.hidden = YES;
            self.descLabel.text = @"";
            [self.payBtn setTitle:@"支付尾款" forState:UIControlStateNormal];
            [self.payBtn addGradientLayerColors:@[(id)[UIColor colorWithHexString:@"#FF6363"].CGColor,(id)[UIColor colorWithHexString:@"#FF961F"].CGColor]];
            self.payBtn.userInteractionEnabled = YES;
            bottomHeight = 84;
            self.descLabelBottomMargin.constant = 15;
        }else if (model.deposit.depositStage == 4){//未报名成功-预售模式-定金已支付-在尾款支付时间-会员；
            self.payTimeLabel.text = @"尾款支付时间";
            self.rightPayTimeLabel.text = [NSString stringWithFormat:@"%@-%@",model.deposit.pay_final_price_start_at,model.deposit.pay_final_price_end_at];
            self.weikuanLabel.text = @"尾款：";
            self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.deposit.advance_final_price];
            self.advanceSaleLabel.hidden = YES;
            self.descLabel.text = model.deposit.finalDeductionCh;
            [self.payBtn setTitle:@"支付尾款" forState:UIControlStateNormal];
            [self.payBtn addGradientLayerColors:@[(id)[UIColor colorWithHexString:@"#FF6363"].CGColor,(id)[UIColor colorWithHexString:@"#FF961F"].CGColor]];
            self.payBtn.userInteractionEnabled = YES;
            bottomHeight = 84 ;
            self.descLabelBottomMargin.constant = IS_IPHONE_X ? 15 : 8;
        }else if (model.deposit.depositStage == 5){//已报名成功
            self.advanceSaleView.hidden = YES;
            self.advanceSaleTimeView.hidden = YES;
            self.contactTeacherBtn.hidden = NO;
            self.advanceSaleTimeViewHeight.constant = 0.0;
            bottomHeight = 59 ;
            self.descLabelBottomMargin.constant = 18;
        }
    }else{
        self.advanceSaleView.hidden = YES;
        self.advanceSaleTimeView.hidden = YES;
        self.contactTeacherBtn.hidden = model.isEnroll ? NO :YES;
        
        self.ourPriceLB.text = model.course.original_price.doubleValue > 0? [NSString stringWithFormat:@"￥%@", model.course.original_price] : model.course.price.doubleValue > 0? [NSString stringWithFormat:@"￥%@", model.course.price] : @"免费";
        
        // 是否已报名 已经结束
        self.buyNowBtn.selected = model.isEnroll;
        self.advanceSaleTimeViewHeight.constant = 0.0;
        bottomHeight = 59;
    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(bottomHeight);
    }];
    
}


- (IBAction)payBtnClick {
    !self.buyNowBtnBlock? : self.buyNowBtnBlock();
}
@end
