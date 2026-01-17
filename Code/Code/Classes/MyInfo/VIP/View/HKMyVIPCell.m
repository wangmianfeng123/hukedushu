//
//  HKMyVIPCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/27.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKMyVIPCell.h"
#import "UIImage+Extension.h"

@interface HKMyVIPCell()

@property (weak, nonatomic) IBOutlet UIImageView *bgIV;

@property (weak, nonatomic) IBOutlet UIImageView *avator;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *detailLB;

@property (weak, nonatomic) IBOutlet UILabel *validTimeLB;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UILabel *willEndLabel;
@property (weak, nonatomic) IBOutlet UIButton *autoBuyBtn;

@end

@implementation HKMyVIPCell



- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.buyBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.willEndLabel.clipsToBounds = YES;
    self.willEndLabel.layer.cornerRadius = PADDING_5;
    self.willEndLabel.backgroundColor = COLOR_FF3221;
    self.willEndLabel.textColor = [UIColor whiteColor];
    
    self.contentView.backgroundColor = COLOR_FFFFFF_3D4752;
}


- (void)layoutSubviews {
    [super layoutSubviews];
}


- (void)buyBtnClick:(id)sender {
    
    self.myVIPCellBlock ? self.myVIPCellBlock(self.model): nil;
}





- (void)setModel:(HKMyVIPModel *)model {
    _model = model;
    UIImage *bgImage = [UIImage resizableImageWithName:[NSString stringWithFormat:@"my_vip_bg_type_%@", model.vip_class]];//[UIImage imageNamed:[NSString stringWithFormat:@"my_vip_bg_type_%@", model.vip_class]];
    self.bgIV.image = bgImage;
    
    // 头像 23
    UIImage *avatorImage = [UIImage imageNamed:[NSString stringWithFormat:@"my_vip_tag_type_%@", model.vip_class]];
    self.avator.image = avatorImage;
    self.nameLB.text = model.name;
    self.detailLB.text = model.describe;
    self.validTimeLB.text = model.date;
    
    [self vipContronlShow:model];
}

- (IBAction)autoBuyBtnClick {
    if (self.autoBuyBlock) {
        self.autoBuyBlock();
    }
}

- (void)vipContronlShow:(HKMyVIPModel *)model {
    
    //1-终身全站通VIP 2-全站通VIP 3-分类SVIP 4-分类限五VIP
    if (model.renewalInfo.is_renewal) {
        self.willEndLabel.hidden = YES;
        self.buyBtn.hidden = YES;
        self.autoBuyBtn.hidden = NO;
    } else if ([model.state isEqualToString:@"1"]) {//1 即将到期  0 正常状态  2升级
        self.willEndLabel.hidden = NO;
        self.buyBtn.hidden = NO;
        self.autoBuyBtn.hidden = YES;
    } else {
        self.willEndLabel.hidden = YES;
        self.buyBtn.hidden = YES;
        self.autoBuyBtn.hidden = YES;
    }
    
    // 设置颜色 升级 续费 按钮
    if (model.vip_class.integerValue == HKVipType_OneYear || model.vip_class.integerValue == HKVipType_WholeLife) {
        // 终身 和 一年的全站同 my_vip_renewals
        [self.buyBtn setImage:imageName(@"my_vip_renewals") forState:UIControlStateNormal];
    } else {
        // 普通分类VIP 和 5天的分类VIP
        [self.buyBtn setImage:imageName(@"my_vip_renewals_blue") forState:UIControlStateNormal];
    }
}

@end
