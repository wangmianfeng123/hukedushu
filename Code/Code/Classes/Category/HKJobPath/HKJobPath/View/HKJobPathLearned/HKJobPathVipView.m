//
//  HKJobPathVipView.m
//  Code
//
//  Created by eon Z on 2022/1/17.
//  Copyright © 2022 pg. All rights reserved.
//

#import "HKJobPathVipView.h"
#import "UIView+HKLayer.h"

@interface HKJobPathVipView ()

@property (weak, nonatomic) IBOutlet UIButton *openVipBtn;
@end

@implementation HKJobPathVipView


-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.openVipBtn setTitleColor:[UIColor colorWithHexString:@"#FF7820"] forState:UIControlStateNormal];
    [self.openVipBtn setBackgroundColor:[UIColor whiteColor]];
    [self.openVipBtn addCornerRadius:12];
    
    [self addCornerRadius:5];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self addGradientLayerColors:@[(id)[UIColor colorWithHexString:@"#FF894B"].CGColor,(id)[UIColor colorWithHexString:@"#FFEDA2"].CGColor]];
}

- (IBAction)openVipBtnClick:(UIButton *)sender {
    if (self.vipBlcok) {
        self.vipBlcok();
    }
}

@end
