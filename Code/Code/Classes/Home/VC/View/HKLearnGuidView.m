//
//  HKLearnGuidView.m
//  Code
//
//  Created by yxma on 2020/11/12.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKLearnGuidView.h"

@implementation HKLearnGuidView

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"showLearnGuidView"];
    [self removeFromSuperview];
}
@end
