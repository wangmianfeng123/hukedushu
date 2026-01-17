//
//  HKWholeLifeTopCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/27.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKWholeLifeTopCell.h"

@interface HKWholeLifeTopCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatorIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *detailLB;
@property (weak, nonatomic) IBOutlet UILabel *lowPriceLB;
@property (weak, nonatomic) IBOutlet UILabel *moneyLB;

@property (weak, nonatomic) IBOutlet UIImageView *bgIV;
@property (weak, nonatomic) IBOutlet UILabel *priceEachDay;

@end

@implementation HKWholeLifeTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView sendSubviewToBack:self.bgIV];
}

- (void)setModel:(HKBuyVipModel *)model {
    _model = model;
    self.moneyLB.text = model.price;
    
    // 计算低至多少钱
    self.priceEachDay.text = [NSString stringWithFormat:@"低至%.1f元/天", model.price.doubleValue / 365.0];
}

@end
