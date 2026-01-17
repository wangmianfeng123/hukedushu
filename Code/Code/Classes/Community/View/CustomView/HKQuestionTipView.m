//
//  HKQuestionTipView.m
//  Code
//
//  Created by Ivan li on 2021/6/16.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKQuestionTipView.h"
#import "UIView+HKLayer.h"


@interface HKQuestionTipView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@end

@implementation HKQuestionTipView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.bgView addCornerRadius:3];
    self.bgView.backgroundColor = COLOR_EFEFF6;
    self.titleLabel.textColor = COLOR_A8ABBE_7B8196;
    self.topLabel.textColor = COLOR_A8ABBE_7B8196;
    self.bottomLabel.textColor = COLOR_A8ABBE_7B8196;
    
    [self.closeBtn setImage:[UIImage hkdm_imageWithNameLight:@"ic_close_question_2_35" darkImageName:@"ic_close_question_dark_2_35"] forState:UIControlStateNormal];
}

- (IBAction)closeBtnClick {
    [self removeFromSuperview];
}

@end
