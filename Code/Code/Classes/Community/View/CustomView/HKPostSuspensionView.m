//
//  HKPostSuspensionView.m
//  Code
//
//  Created by Ivan li on 2021/1/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKPostSuspensionView.h"
#import "UIImageView+LBBlurredImage.h"

@interface HKPostSuspensionView ()
@property (nonatomic , strong) UIVisualEffectView * effe;
@property (weak, nonatomic) IBOutlet UIButton *questionBtn;
@property (weak, nonatomic) IBOutlet UIButton *monmentBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;

@end

@implementation HKPostSuspensionView

-(void)awakeFromNib{
    [super awakeFromNib];
//    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
//    self.effe = [[UIVisualEffectView alloc] initWithEffect:blur];
//    self.effe.alpha = 1;
//    [self.bgView addSubview:self.effe];
    //设置模糊透明度
    
    [self.questionBtn setTitle:@"我要提问" forState:UIControlStateNormal];
    [self.monmentBtn setTitle:@"发布动态" forState:UIControlStateNormal];
    [self.questionBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleTop imageTitleSpace:3];
    [self.monmentBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleTop imageTitleSpace:3];
    [self.questionBtn setEnlargeEdgeWithTop:20 right:0 bottom:0 left:0];
    [self.monmentBtn setEnlargeEdgeWithTop:20 right:0 bottom:0 left:0];
    [self.questionBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
    [self.monmentBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self insertSubview:self.effe atIndex:0];
    self.effe.frame = self.bgView.bounds;
}

- (IBAction)closeBtnClick {
    if (self.didCloseBlock) {
        self.didCloseBlock();
    }
}

- (IBAction)postMonmentClick {
    if (self.didMonmentBlock) {
        self.didMonmentBlock();
    }
}

- (IBAction)questionBtnClick {
    if (self.didQuestionBlock) {
        self.didQuestionBlock();
    }
}

-(void)setShootImage:(UIImage *)shootImage{
    _shootImage = shootImage;
    [self.bgImgView setImageToBlur:shootImage
                          blurRadius:50
                     completionBlock:^(NSError *error){
                         NSLog(@"The blurred image has been setted");
                     }];
}
@end
