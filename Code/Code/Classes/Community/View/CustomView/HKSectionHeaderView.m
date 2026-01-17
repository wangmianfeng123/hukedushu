//
//  HKSectionHeaderView.m
//  Code
//
//  Created by Ivan li on 2021/1/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKSectionHeaderView.h"

@interface HKSectionHeaderView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation HKSectionHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    self.bgView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;

}

@end
