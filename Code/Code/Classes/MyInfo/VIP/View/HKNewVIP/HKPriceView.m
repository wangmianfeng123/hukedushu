//
//  HKPriceView.m
//  Code
//
//  Created by eon Z on 2021/11/16.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKPriceView.h"

@interface HKPriceView ()
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *txtLabel;

@end

@implementation HKPriceView


-(void)awakeFromNib{
    [super awakeFromNib];
    _txtLabel.textColor = [UIColor colorWithHexString:@"#694C2F"];
    self.userInteractionEnabled = NO;
}

-(void)setVipModel:(HKBuyVipModel *)vipModel{
    NSString * priceStr = vipModel.price;
    NSString *str = [NSString stringWithFormat:@"¥%@",priceStr];
    if (vipModel.per_day.length) {
        str = [NSString stringWithFormat:@"%@%@",str,vipModel.per_day];
    }
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#694C2F"] range:NSMakeRange(0, attrString.length)];
    [attrString addAttribute:NSFontAttributeName value:HK_FONT_SYSTEM_BOLD(14) range:NSMakeRange(0,1)];
    [attrString addAttribute:NSFontAttributeName value:HK_FONT_SYSTEM_BOLD(24) range:NSMakeRange(1,priceStr.length)];
    [attrString addAttribute:NSFontAttributeName value:HK_FONT_SYSTEM(14) range:NSMakeRange(priceStr.length + 1,attrString.length-priceStr.length-1)];
    self.priceLabel.attributedText = attrString;
    self.backgroundColor = [UIColor colorWithHexString:@"#EFCDA6"];//
}
@end
