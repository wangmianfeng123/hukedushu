//
//  HKAdvanceSaleView.m
//  Code
//
//  Created by Ivan li on 2020/11/23.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKAdvanceSaleView.h"
#import "HKLiveDetailModel.h"

@interface HKAdvanceSaleView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV1;
@property (weak, nonatomic) IBOutlet UILabel *depositLabel;
@property (weak, nonatomic) IBOutlet UILabel *depositTimeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImgV2;
@property (weak, nonatomic) IBOutlet UILabel *retainageLabel;
@property (weak, nonatomic) IBOutlet UILabel *retainageTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *weiKuanLabel;

@end

@implementation HKAdvanceSaleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)lookRulesBtnClick {
    if (self.didLookBlock) {
        self.didLookBlock();
    }
}

/**
1未报名成功-预售模式-定金未支付；
2未报名成功-预售模式-定金已支付-不在尾款支付时间；
3未报名成功-预售模式-定金已支付-在尾款支付时间-非会员（或者有会员，但没有会员尾款优惠）；
4未报名成功-预售模式-定金已支付-在尾款支付时间-会员；
5若已报名成功
 */
-(void)setModel:(HKLiveDetailModel *)model{
    _model = model;
    if (model.deposit.depositStage == 1) {//未报名成功-预售模式-定金未支付
        _iconImgV1.image = [UIImage imageNamed:@"ic_incomplete"];
        _iconImgV2.image = [UIImage imageNamed:@"ic_incomplete"];
        
        _depositTimeLabel.hidden = NO;
        _retainageTimeLabel.hidden = NO;
        _weiKuanLabel.hidden = NO;
    }else if (model.deposit.depositStage == 2 ||
              model.deposit.depositStage == 3 ||
              model.deposit.depositStage == 4){
        _iconImgV1.image = [UIImage imageNamed:@"ic_complete"];
        _iconImgV2.image = [UIImage imageNamed:@"ic_incomplete"];
        
        _depositTimeLabel.hidden = YES;
        _retainageTimeLabel.hidden = NO;
        _weiKuanLabel.hidden = NO;
    }else {
        _iconImgV1.image = [UIImage imageNamed:@"ic_complete"];
        _iconImgV2.image = [UIImage imageNamed:@"ic_complete"];
        _depositTimeLabel.hidden = YES;
        _retainageTimeLabel.hidden = YES;
        _weiKuanLabel.hidden = YES;
    }
    self.depositLabel.text = [NSString stringWithFormat:@"支付定金¥%@，限时抵¥%@",model.deposit.advance_deposit_price,model.deposit.depositDeduction];
    self.depositTimeLabel.text = [NSString stringWithFormat:@"%@-%@",model.deposit.advance_start_at,model.deposit.advance_end_at];
    
    self.retainageLabel.text = [NSString stringWithFormat:@"支付课程尾款¥%@，成功购课",model.deposit.advance_final_price];
    self.retainageTimeLabel.text = [NSString stringWithFormat:@"%@-%@",model.deposit.pay_final_price_start_at,model.deposit.pay_final_price_end_at];
}
@end
