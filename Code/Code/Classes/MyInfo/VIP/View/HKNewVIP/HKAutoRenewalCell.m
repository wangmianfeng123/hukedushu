//
//  HKAutoRenewalCell.m
//  Code
//
//  Created by yxma on 2020/10/23.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKAutoRenewalCell.h"
#import "UIView+HKLayer.h"

@interface HKAutoRenewalCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *flagImgV;

@end

@implementation HKAutoRenewalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.bgView addCornerRadius:5];
    UIButton * btn = [UIButton new];
    btn.selected = NO;
    [self selectBtnClick:btn];
    self.selectButton.selected = YES;
    self.bgView.backgroundColor = [UIColor colorWithHexString:@"#F9F6EF"];
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#694C2F"];
    self.contentView.backgroundColor = COLOR_FFFFFF_3D4752;
}

-(void)setAutoBuyModel:(HKBuyVipModel *)autoBuyModel{
    _autoBuyModel = autoBuyModel;
    self.detailLabel.text = autoBuyModel.check_box_title;
    self.tipLabel.text = autoBuyModel.check_box_desc;
}

- (IBAction)selectBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        //self.bgView.backgroundColor = [UIColor colorWithHexString:@"#FFF0E6"];
        //self.bgView.layer.borderColor = [UIColor colorWithHexString:@"#FF7820"].CGColor;
        self.bgView.layer.borderColor = [UIColor colorWithHexString:@"#EFCDA6"].CGColor;
        self.bgView.layer.borderWidth = 2;
        //self.detailLabel.textColor = [UIColor colorWithHexString:@"#FF7820"];
    }else{
        //self.bgView.backgroundColor = [UIColor colorWithHexString:@"#EFEFF6"];
        self.bgView.layer.borderWidth = 0.0;
        //self.detailLabel.textColor = [UIColor colorWithHexString:@"#A8ABBE"];
    }
    self.flagImgV.hidden = sender.selected ? NO : YES;
    if (self.selectBtnBlock) {
        self.selectBtnBlock(sender.selected);
    }
}

@end
