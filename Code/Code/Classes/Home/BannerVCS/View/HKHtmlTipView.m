//
//  HKHtmlTipView.m
//  Code
//
//  Created by Ivan li on 2020/11/18.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKHtmlTipView.h"
#import "UIView+HKLayer.h"

@interface HKHtmlTipView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation HKHtmlTipView

+ (HKHtmlTipView *)createViewFrame:(CGRect)frame{
    HKHtmlTipView * view = [HKHtmlTipView viewFromXib];
    view.frame = frame;
    return view;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.bgView addCornerRadius:5 addBoderWithColor:[UIColor colorWithHexString:@"#FFE70A"] BoderWithWidth:1];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.bgView addGestureRecognizer:tap];
}

- (void)tapClick{
    if (self.clickBlock) {
        self.clickBlock();
    }
}

@end
