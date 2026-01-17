//
//  HKCommentTipView.m
//  Code
//
//  Created by eon Z on 2021/9/2.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKCommentTipView.h"
#import "UIView+HKLayer.h"

@interface HKCommentTipView ()

@property (weak, nonatomic) IBOutlet UILabel *txtLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@end

@implementation HKCommentTipView

-(void)awakeFromNib{
    [super awakeFromNib];
    //self.alpha = 0.5;
    self.txtLabel.textColor = [UIColor whiteColor];
    self.txtLabel.font = [UIFont systemFontOfSize:12];
    [self addCornerRadius:5];
    [self.closeBtn setImage:[UIImage hkdm_imageWithNameLight:@"ic_close_ask_2_37" darkImageName:@"ic_close_ask_2_37"] forState:UIControlStateNormal];
    [UILabel changeLineSpaceForLabel:self.txtLabel WithSpace:5];
}

- (IBAction)closeBtnClick {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
