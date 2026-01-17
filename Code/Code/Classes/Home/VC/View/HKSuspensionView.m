//
//  HKSuspensionView.m
//  Code
//
//  Created by Ivan li on 2020/11/18.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKSuspensionView.h"
#import "UIView+HKLayer.h"

@interface HKSuspensionView ()


@end

@implementation HKSuspensionView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.timeLabel addCornerRadius:7.5];
}



@end
