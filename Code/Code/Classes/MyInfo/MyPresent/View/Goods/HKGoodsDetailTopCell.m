//
//  HKGoodsDetailTopCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/29.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKGoodsDetailTopCell.h"

@interface HKGoodsDetailTopCell()

// 顶部
@property (weak, nonatomic) IBOutlet UIImageView *goodsIV;
@property (weak, nonatomic) IBOutlet UILabel *topLB;
@property (weak, nonatomic) IBOutlet UILabel *bottomLB;
@property (weak, nonatomic) IBOutlet UILabel *dayLB;

// 中部底部
@property (weak, nonatomic) IBOutlet UILabel *middleTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *countLB;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;

@end

@implementation HKGoodsDetailTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(HKGoodsModel *)model {
    _model = model;
    
    self.topLB.text = model.days;
    self.bottomLB.text = model.title;
    self.middleTitleLB.text = model.title;
    self.countLB.text = model.stock;
    self.priceLB.text = model.price;
}

@end
