//
//  HKTrainSectionHeaderView.m
//  Code
//
//  Created by yxma on 2020/8/24.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKTrainSectionHeaderView.h"
//
@interface HKTrainSectionHeaderView ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnArray;
@property (weak, nonatomic) IBOutlet UIView *yellowView;
@property (nonatomic, strong) UIButton * currentBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@end

@implementation HKTrainSectionHeaderView


+ (HKTrainSectionHeaderView *)createViewByFrame:(CGRect)frame byDelegate:(id)delegate{
    HKTrainSectionHeaderView * view = [HKTrainSectionHeaderView viewFromXib];
    view.frame = frame;
    view.delegate = delegate;
    return view;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.currentBtn = [self viewWithTag:1];
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    self.lineView.backgroundColor = COLOR_F8F9FA_333D48;
}

-(void)drawRect:(CGRect)rect{
    self.yellowView.center = CGPointMake(self.currentBtn.centerX, self.yellowView.centerY);
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.yellowView.center = CGPointMake(self.currentBtn.centerX, self.yellowView.centerY);
}

- (void)clickBtnIndex:(NSInteger)tag{
    for (UIButton * btn in _btnArray) {
        if (btn.tag == tag) {
            [btn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
            self.currentBtn = btn;
            [self setNeedsDisplay];
        }else{
            [btn setTitleColor:COLOR_7B8196_A8ABBE forState:UIControlStateNormal];
        }
    }
}

- (IBAction)btnClick:(UIButton *)sender {
    for (UIButton * btn in _btnArray) {
        if (btn.tag == sender.tag) {
            [btn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
            self.currentBtn = btn;
            [self setNeedsDisplay];
            if (self.btnClickBlock) {
                self.btnClickBlock(sender.tag);
            }
        }else{
            [btn setTitleColor:COLOR_7B8196_A8ABBE forState:UIControlStateNormal];
        }
    }
}

@end
