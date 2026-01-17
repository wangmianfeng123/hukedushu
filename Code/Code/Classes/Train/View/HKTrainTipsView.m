//
//  HKTrainTipsView.m
//  Code
//
//  Created by yxma on 2020/9/7.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKTrainTipsView.h"



@implementation HKTrainTipsView

+ (HKTrainTipsView *) createView{
    HKTrainTipsView * tips = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HKTrainTipsView class]) owner:nil options:nil].lastObject;
    tips.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    return tips;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasShowedTips"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

@end
