//
//  HKPostCommentView.m
//  Code
//
//  Created by Ivan li on 2021/1/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKPostCommentView.h"

@interface HKPostCommentView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@end

@implementation HKPostCommentView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    self.bgView.backgroundColor = [UIColor hkdm_colorWithColorLight:COLOR_F8F9FA dark:COLOR_333D48];//COLOR_F8F9FA_3C4651;
    self.txtLabel.textColor = COLOR_878CA2;
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self addGestureRecognizer:tap];
}

- (void)tapClick{
    if (self.didTapClickBlock) {
        self.didTapClickBlock();
    }
}

@end
