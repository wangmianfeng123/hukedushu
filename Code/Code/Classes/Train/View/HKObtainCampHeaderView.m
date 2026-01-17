//
//  HKObtainCampHeaderView.m
//  Code
//
//  Created by yxma on 2020/11/10.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKObtainCampHeaderView.h"
#import "UIView+HKLayer.h"

@interface HKObtainCampHeaderView ()
@property (weak, nonatomic) IBOutlet UIView *labelsView;

@end

@implementation HKObtainCampHeaderView

+ (HKObtainCampHeaderView *)createView{
    HKObtainCampHeaderView * authView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HKObtainCampHeaderView class]) owner:nil options:nil].lastObject;
    return authView;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self addShadow:self.labelsView];
}

- (void)addShadow:(UIView *)view{
    view.layer.cornerRadius = 10;
    view.layer.shadowOffset = CGSizeMake(0,2);
    view.layer.shadowColor = [UIColor colorWithHexString:@"#D2D6E4"].CGColor;
    view.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    view.layer.shadowRadius = 5;//阴影半径，默认3
    view.clipsToBounds = NO;
}




@end
