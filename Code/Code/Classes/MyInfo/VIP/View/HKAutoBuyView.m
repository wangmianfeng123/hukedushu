//
//  HKAutoBuyView.m
//  Code
//
//  Created by yxma on 2020/10/23.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKAutoBuyView.h"
#import "UIView+HKLayer.h"
#import "HKMyVIPModel.h"

@interface HKAutoBuyView ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *originPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *knownBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation HKAutoBuyView

+ (HKAutoBuyView *)createView{
    HKAutoBuyView * authView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HKAutoBuyView class]) owner:nil options:nil].lastObject;
    authView.frame = CGRectMake(0, 0, 280, 225);
    return authView;
}

- (IBAction)knownBtnClick {
    if (self.knownBlock) {
        self.knownBlock();
    }
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.knownBtn addGradientLayerColors:@[(id)[UIColor colorWithHexString:@"#FF8A00"].CGColor,(id)[UIColor colorWithHexString:@"#FFB600"].CGColor]];

}

-(void)setRenewalInfoModel:(HKRenewalInfoModel *)renewalInfoModel{
    _renewalInfoModel = renewalInfoModel;
    
    self.timeLabel.text = renewalInfoModel.next_renewal_time;
    self.priceLabel.text = renewalInfoModel.next_renewal_price;
    self.originPriceLabel.text = renewalInfoModel.original_price;
    
    if (renewalInfoModel.original_price.length) {
        self.originPriceLabel.hidden = NO;
        self.lineView.hidden = NO;
    }else{
        self.originPriceLabel.hidden = YES;
        self.lineView.hidden = YES;
    }
}


@end
