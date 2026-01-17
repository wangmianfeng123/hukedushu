//
//  HKAdvanceSaleRuleView.m
//  Code
//
//  Created by Ivan li on 2020/11/25.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKAdvanceSaleRuleView.h"
#import "UIView+HKLayer.h"

@interface HKAdvanceSaleRuleView ()
@property (weak, nonatomic) IBOutlet UIButton *knowBtn;

@end

@implementation HKAdvanceSaleRuleView


-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.knowBtn addCornerRadius:19];
    [self.knowBtn addGradientLayerColors:@[(id)[UIColor colorWithHexString:@"#FFB600"].CGColor,(id)[UIColor colorWithHexString:@"#FF8A00"].CGColor]];
}

- (IBAction)knowBtnClick {
    if (self.didKnowBlock) {
        self.didKnowBlock();
    }
}

@end
