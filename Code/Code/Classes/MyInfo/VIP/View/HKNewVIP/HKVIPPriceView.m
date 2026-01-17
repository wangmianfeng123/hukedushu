//
//  HKVIPPriceView.m
//  Code
//
//  Created by eon Z on 2021/11/10.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKVIPPriceView.h"


@interface HKVIPPriceView ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *txtLabel;

@end

@implementation HKVIPPriceView

-(void)awakeFromNib{
    [super awakeFromNib];
}

-(void)setModel:(HKBuyVipModel *)model{
    _model = model;
    self.nameLabel.textColor = model.isFlag ? [UIColor colorWithHexString:@"#694C2F"] : [UIColor colorWithHexString:@"#8F94A5"];
    self.txtLabel.textColor = model.isFlag ? [UIColor colorWithHexString:@"#694C2F"]: [UIColor colorWithHexString:@"#8F94A5"];

    if (self.currentIndex == 0 &&
        model.price.length &&
        model.categoryVipName.length) {
            self.nameLabel.text = model.categoryVipName;
            self.txtLabel.text = model.motto;
            NSString *str = [NSString stringWithFormat:@"¥ %@",model.price];
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
            [attrString addAttribute:NSForegroundColorAttributeName value:model.isFlag ? [UIColor colorWithHexString:@"#694C2F"] : [UIColor colorWithHexString:@"#8F94A5"] range:NSMakeRange(0, attrString.length)];
            [attrString addAttribute:NSFontAttributeName value:HK_FONT_SYSTEM_BOLD(20) range:NSMakeRange(0,1)];
            [attrString addAttribute:NSFontAttributeName value:HK_FONT_SYSTEM_BOLD(40) range:NSMakeRange(1,attrString.length-1)];
            self.priceLabel.attributedText = attrString;
            return;
    }
    
    self.nameLabel.text = model.name;
    self.txtLabel.text = model.motto;
    
    if (!isEmpty(model.price)) {
        NSString *str = [NSString stringWithFormat:@"¥ %@",model.price];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
        [attrString addAttribute:NSForegroundColorAttributeName value:model.isFlag ? [UIColor colorWithHexString:@"#694C2F"] : [UIColor colorWithHexString:@"#8F94A5"] range:NSMakeRange(0, attrString.length)];
        [attrString addAttribute:NSFontAttributeName value:HK_FONT_SYSTEM_BOLD(20) range:NSMakeRange(0,1)];
        [attrString addAttribute:NSFontAttributeName value:HK_FONT_SYSTEM_BOLD(40) range:NSMakeRange(1,attrString.length-1)];
        self.priceLabel.attributedText = attrString;
    }
}

@end
