//
//  HKGoodsCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/28.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKGoodsCell.h"

@interface HKGoodsCell()

@property (weak, nonatomic) IBOutlet UIImageView *bgIV;
@property (weak, nonatomic) IBOutlet UIImageView *noMoreBg;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UILabel *countLB;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;

@property (weak, nonatomic) IBOutlet UILabel *daysLB;

@property (weak, nonatomic) IBOutlet UILabel *topTitleLB;

@end

@implementation HKGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 圆角处理
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 2.0;
    self.buyBtn.clipsToBounds = YES;
    self.buyBtn.layer.cornerRadius = 25.0 * 0.5;
    
    // iPhone 5s
    if (IS_IPHONE5S) {
        self.priceLB.font = [UIFont systemFontOfSize:12.0];
        self.countLB.font = self.priceLB.font;
    }
}

- (void)setModel:(HKGoodsModel *)model {
    _model = model;
    self.nameLB.text = model.title;
    self.countLB.text = [NSString stringWithFormat:@"存库：%@个", model.stock];
    self.priceLB.text = [NSString stringWithFormat:@"%@虎课币", model.price];
    
    self.daysLB.text = model.days;
    self.topTitleLB.text = model.name;
    
    // 售罄
    self.buyBtn.enabled = model.stock.intValue > 0;
    if (!self.buyBtn.enabled) {
        self.buyBtn.backgroundColor = HKColorFromHex(0xdddddd, 1.0);
    } else {
        self.buyBtn.backgroundColor = HKColorFromHex(0xff6600, 1.0);
    }
    self.noMoreBg.hidden = model.stock.intValue > 0;
}

- (IBAction)btnCliick:(id)sender {
    
    // 执行代理
    [MobClick event:UM_RECORD_SIGMIN_EXCHANGE];
    if ([self.delegate respondsToSelector:@selector(HKGoodsClick:)]) {
        [self.delegate HKGoodsClick:self.model];
    }
}


@end
