//
//  HKOtherVipInCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/28.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKOtherVipInCell.h"

@interface HKOtherVipInCell()

@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cornerArrow;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, weak)UIButton *seeButton; // 刚刚观看的button

@end

@implementation HKOtherVipInCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // 圆角2
    self.bgView.clipsToBounds = YES;
    self.bgView.layer.cornerRadius = 2.0;
    
    // 添加刚刚观看的按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"刚刚观看" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [button setBackgroundColor:[UIColor colorWithHexString:@"#EFCDA6"]];
//    button.hidden = YES;
    [self.contentView addSubview:button];
    CGSize size = IS_IPHONEMORE4_7INCH? CGSizeMake(58, 19) : CGSizeMake(55, 17);
    button.clipsToBounds = YES;
    button.layer.cornerRadius = size.height * 0.5;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
        make.top.equalTo(self);
        make.right.mas_equalTo(self.contentView);
    }];
    self.seeButton = button;
    
    // 圆角等设置
    self.bgView.layer.borderWidth = 2;
    //self.bgView.clipsToBounds = YES;
    self.bgView.layer.cornerRadius = 5.0;
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.cornerArrow.hidden = YES;
}


- (void)setModel:(HKBuyVipModel *)model {
    _model = model;

    self.bgView.backgroundColor = [UIColor colorWithHexString:@"#F9F6EF"];
    // 选中状态
    if (model.is_selected) {
        //self.contentView.layer.borderColor = HKColorFromHex(0x3D8BFF, 1.0).CGColor;
        //self.contentView.backgroundColor = HKColorFromHex(0xEEF5FF, 1.0);
        //self.topLabel.textColor = HKColorFromHex(0x3D8BFF, 1.0);
        //self.bottomLabel.textColor = HKColorFromHex(0x3D8BFF, 1.0);
        
        self.bgView.layer.borderColor = [UIColor colorWithHexString:@"#EFCDA6"].CGColor;
        self.topLabel.textColor = [UIColor colorWithHexString:@"#AC7A5B"];
        self.bottomLabel.textColor = [UIColor colorWithHexString:@"#30343E"];
    }else {
        self.bgView.layer.borderColor = [UIColor clearColor].CGColor;
        self.topLabel.textColor = HKColorFromHex(0x27323F, 1.0);
        self.bottomLabel.textColor = [UIColor colorWithHexString:@"#30343E"];
    }
    
    self.cornerArrow.hidden = model.is_selected ? NO : YES;
    self.seeButton.hidden = !model.is_just_watch;
    
    self.topLabel.text = model.class_name;
    // 其他属性
    if ([model.price containsString:@"敬请期待"]) {
        self.bottomLabel.text = model.price;
    } else {
        self.bottomLabel.text = [NSString stringWithFormat:@"%@元/年", model.price];
    }


}



@end
