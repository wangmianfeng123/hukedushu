//
//  HKOtherVipTopCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/27.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKOtherVipTopCell.h"
#import "UIView+HKLayer.h"

@interface HKOtherVipTopCell()


@property (weak, nonatomic) IBOutlet UILabel *yearLB;
@property (weak, nonatomic) IBOutlet UIImageView *avatorIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *detailLB;
@property (weak, nonatomic) IBOutlet UILabel *lowPriceLB;
@property (weak, nonatomic) IBOutlet UILabel *moneyLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatorcCenterConstrain;
// 超级优惠
@property (weak, nonatomic) IBOutlet UIButton *superPriceOffBtn;

@property (weak, nonatomic) IBOutlet UIImageView *bgIV;
@property (weak, nonatomic) IBOutlet UILabel *highPriceLB;
@property (weak, nonatomic) IBOutlet UIButton *appOffCountBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView; // 删除线
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgTopCons;

@property (weak, nonatomic) IBOutlet UILabel *autoBuyDiscountLabel;
@property (weak, nonatomic) IBOutlet UIView *autoBuyDiscountView;
@property (weak, nonatomic) IBOutlet UILabel *autoBuyPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *autoBuyDesLabel;

@end

@implementation HKOtherVipTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    if (IS_IPHONEMORE4_7INCH) {
//        self.yearLB.font = [UIFont systemFontOfSize:22.0 weight:UIFontWeightBold];
//    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView sendSubviewToBack:self.bgIV];
    self.superPriceOffBtn.hidden = YES;
    self.appOffCountBtn.clipsToBounds = YES;
    self.appOffCountBtn.layer.cornerRadius = 5.0;
    self.moneyLB.hidden = YES;
    self.adImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adImageViewTap)];
    [self.adImageView addGestureRecognizer:tap];
    
    self.contentView.backgroundColor = COLOR_F8F9FA_333D48;
}

- (void)adImageViewTap {
    !self.adImageViewTapBlock? : self.adImageViewTapBlock(self.model.ad);
}


- (void)setModel:(HKBuyVipModel *)model {
    
    if (model == nil) return;
    
    _model = model;
    self.yearLB.text = model.price_title;
    
    // 计算低至多少钱
    self.lowPriceLB.text = model.per_day;
    self.lowPriceLB.hidden = model.per_day.length == 0;
    self.nameLB.text = model.name.length? model.name : model.class_name;
    self.detailLB.text = [NSString stringWithFormat:@"%@分类教程，无限学习，无限下载", model.name.length? model.name : model.class_name];
    
    // 一年全站通
    if ([model.vip_type isEqualToString:@"999"]) {
        self.detailLB.text = @"全站教程无限学习，无限下载";
        self.bgIV.image = imageName(@"vip_bg");
        self.avatorIV.image = imageName(@"all_platform_avator");
    } else if ([model.vip_type isEqualToString:@"9999"]) { // 终身VIP
        self.detailLB.text = @"终身全站教程无限学习，无限下载";
        self.bgIV.image = imageName(@"my_vip_bg_type_3");
        self.avatorIV.image = imageName(@"my_vip_tag_type_3");
        self.avatorcCenterConstrain.constant = -2; // 优化偏下的问题

        self.lowPriceLB.hidden = YES;
        self.yearLB.text = [NSString stringWithFormat:@"￥%@", model.price];
    }
    
    self.superPriceOffBtn.hidden = model.tips.length == 0;
    [self.superPriceOffBtn setTitle:model.tips forState:UIControlStateNormal];
    
    //优惠价格，中划线
    self.highPriceLB.text = model.pc_price;
    self.appOffCountBtn.hidden = model.price_tips.length == 0;
    [self.appOffCountBtn setTitle:model.price_tips forState:UIControlStateNormal];
    self.highPriceLB.hidden = model.pc_price.length == 0;
    self.lineView.hidden = self.highPriceLB.hidden;
    
    // 有无广告
    if (model.ad.is_show) {
        self.adImageView.hidden = NO;
        [self.adImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.ad.img_url]] placeholderImage:imageName(HK_Placeholder)];
        self.bgTopCons.constant = 62.0;
    } else {
        self.adImageView.hidden = YES;
        self.bgTopCons.constant = 12.0;
    }
    
}

-(void)setIsAutoBuy:(BOOL)isAutoBuy{
    _isAutoBuy = isAutoBuy;
    self.autoBuyDesLabel.hidden = !isAutoBuy;
    self.autoBuyPriceLabel.hidden = !isAutoBuy;
    self.autoBuyDiscountView.hidden = !isAutoBuy;
    self.autoBuyDiscountLabel.hidden = !isAutoBuy;
    
    self.yearLB.hidden = !self.autoBuyPriceLabel.hidden;

    
    self.autoBuyDesLabel.text = _model.price_title;
    self.autoBuyPriceLabel.text = _model.price_title_suffix;
    
    self.autoBuyDiscountLabel.text = _model.try_out_price_title;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.autoBuyDiscountView addGradientLayerColors:@[(id)[UIColor colorWithHexString:@"#FF961F"].CGColor,(id)[UIColor colorWithHexString:@"#FF5555"].CGColor]];
    });
}


@end
