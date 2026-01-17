//
//  HKSaleRuleContentView.m
//  Code
//
//  Created by Ivan li on 2020/11/25.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKSaleRuleContentView.h"
#import "HKAdvanceSaleRuleView.h"

@interface HKSaleRuleContentView ()
@property (nonatomic , strong) HKAdvanceSaleRuleView * rulesView;
@end

@implementation HKSaleRuleContentView

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.rulesView = [HKAdvanceSaleRuleView viewFromXib];
        @weakify(self)
        self.rulesView.didKnowBlock = ^{
            @strongify(self)
            if (self.didKnowBlock) {
                self.didKnowBlock();
            }
        };
        [self addSubview:self.rulesView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.rulesView.frame = self.bounds;
}

@end
