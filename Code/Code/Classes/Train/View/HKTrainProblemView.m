//
//  HKTrainProblemView.m
//  Code
//
//  Created by yxma on 2020/8/25.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKTrainProblemView.h"

@interface HKTrainProblemView ()
@property (weak, nonatomic) IBOutlet UILabel *txtLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgV;

@end

@implementation HKTrainProblemView

+ (HKTrainProblemView *)createViewFrame:(CGRect)frame{
    HKTrainProblemView * view = [HKTrainProblemView viewFromXib];
    view.frame = frame;
    UIWindow * window = [[UIApplication sharedApplication]keyWindow];
    [window addSubview:view];
    return view;
}

-(void)setSubVCenter:(CGPoint)subVCenter{
    self.txtLabel.center = CGPointMake(subVCenter.x, subVCenter.y+48);
    self.bgView.center = CGPointMake(subVCenter.x, subVCenter.y+48);
    self.bgImgV.center = CGPointMake(subVCenter.x, subVCenter.y+45);;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches.allObjects lastObject];
    
    if (![touch.view isDescendantOfView:self.bgView]) {
        [self removeFromSuperview];
    }
}
@end
