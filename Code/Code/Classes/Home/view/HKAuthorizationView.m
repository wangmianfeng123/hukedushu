//
//  HKAuthorizationView.m
//  Code
//
//  Created by yxma on 2020/9/22.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKAuthorizationView.h"
#import "UIView+HKLayer.h"

@interface HKAuthorizationView ()
@property (weak, nonatomic) IBOutlet UIView *gradentView;

@end

@implementation HKAuthorizationView

+ (HKAuthorizationView *)createView{
    HKAuthorizationView * authView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HKAuthorizationView class]) owner:nil options:nil].lastObject;
//    authView.frame = CGRectMake(0, 0, 260, 308);    
    return authView;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.gradentView addVerticalGradientLayerColors:@[(id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor,(id)[UIColor colorWithWhite:1.0 alpha:1].CGColor]];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.agreementBtn addGradientLayerColors:@[(id)[UIColor colorWithHexString:@"#FF8A00"].CGColor,(id)[UIColor colorWithHexString:@"#FFB600"].CGColor]];
}

- (IBAction)cancelBtnClick {
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (IBAction)agreementBtnClick {
    if (self.sureBlock) {
        self.sureBlock();
    }
}

- (IBAction)userDelegateBtnClik:(UIButton *)sender {
    if (self.delegateClickBlock) {
        self.delegateClickBlock(sender.tag);
    }
}

@end
