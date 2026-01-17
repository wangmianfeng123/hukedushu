//
//  HKOpenVipView.m
//  Code
//
//  Created by eon Z on 2022/2/10.
//  Copyright © 2022 pg. All rights reserved.
//

#import "HKOpenVipView.h"
#import "UIView+HKLayer.h"

@interface HKOpenVipView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *openVipBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgV;

@end

@implementation HKOpenVipView


-(void)awakeFromNib{
    [super awakeFromNib];
    [self.bgView addCornerRadius:5];
    
    
    UIColor *color2 = [UIColor colorWithHexString:@"#FFEDA2"];
    UIColor *color1 = [UIColor colorWithHexString:@"#FFC17B"];
    UIColor *color = [UIColor colorWithHexString:@"#FF894B"];
            
    UIImage *bgImage = [[UIImage alloc]createImageWithSize:CGSizeMake(SCREEN_WIDTH-30, 40) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
    self.bgImgV.image = bgImage;    
    [self.bgImgV bringSubviewToFront:self.bgView];
    self.backgroundColor = COLOR_FFFFFF_3D4752;
}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//    [self.bgView addGradientLayerColors:@[(id)[UIColor colorWithHexString:@"#FF8A00"].CGColor,(id)[UIColor colorWithHexString:@"#FFB600"].CGColor]];
//}

- (IBAction)openVipBtnClick {
    if (self.didOpenVipBtnBlock) {
        self.didOpenVipBtnBlock();
    }
}

@end
