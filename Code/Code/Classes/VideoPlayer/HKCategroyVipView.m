//
//  HKCategroyVipView.m
//  Code
//
//  Created by Ivan li on 2021/7/12.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKCategroyVipView.h"
#import "UIView+HKLayer.h"

@interface HKCategroyVipView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *vipNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) UILabel * signLabel;

@end

@implementation HKCategroyVipView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.bgView addCornerRadius:4 addBoderWithColor:[UIColor colorWithHexString:@"#FF8A00"]];
    //self.bgView.backgroundColor = [UIColor colorWithHexString:@"#FFF0E6"];
    self.vipNameLabel.textColor = COLOR_27323F_A8ABBE;
    self.detailLabel.textColor = COLOR_7B8196_A8ABBE;
    self.priceLabel.textColor = [UIColor colorWithHexString:@"#FF8A00"];
    
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addSubview:self.signLabel];
        //[_signLabel addGradientLayerColors:@[(id)[UIColor colorWithHexString:@"#FF4265"].CGColor,(id)[UIColor colorWithHexString:@"#FF755A"].CGColor]];
    });
}


-(UILabel *)signLabel{
    if (_signLabel == nil) {
        _signLabel = [UILabel labelWithTitle:CGRectMake(self.width - 32, -8, 32, 16) title:@"推荐" titleColor:[UIColor whiteColor] titleFont:@"10" titleAligment:NSTextAlignmentCenter];
        _signLabel.backgroundColor = [UIColor colorWithHexString:@"#FF755A"];
        [_signLabel addCornerRadius:8 addBoderWithColor:[UIColor whiteColor]];
    }
    return _signLabel;
}

-(void)setVipModel:(HKBuyVipModel *)vipModel{
    _vipModel =vipModel;
    self.vipNameLabel.text = vipModel.name;
    self.priceLabel.text = vipModel.price;
    self.detailLabel.text = vipModel.desc;
    if (_vipModel.is_selected) {
        self.vipNameLabel.textColor = COLOR_27323F;
        self.detailLabel.textColor = COLOR_7B8196;
        [self.bgView addCornerRadius:4 addBoderWithColor:[UIColor colorWithHexString:@"#FF8A00"]];
        self.bgView.backgroundColor = [UIColor colorWithHexString:@"#FFF0E6"];
    }else{
        self.vipNameLabel.textColor = COLOR_27323F_A8ABBE;
        self.detailLabel.textColor = COLOR_7B8196_A8ABBE;
        [self.bgView addCornerRadius:4 addBoderWithColor:COLOR_EFEFF6_7B8196];
        self.bgView.backgroundColor = COLOR_FFFFFF_333D48;
    }
    
    self.signLabel.hidden = _vipModel.tag.length ? NO : YES;
    
    self.signLabel.text = _vipModel.tag;
}

-(void)setIs_selected:(BOOL)is_selected{
    _is_selected = is_selected;
    self.vipModel.is_selected = is_selected;
    
    [self setVipModel:self.vipModel];
}
@end
