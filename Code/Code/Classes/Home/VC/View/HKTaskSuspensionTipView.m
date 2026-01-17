//
//  HKTaskSuspensionTipView.m
//  Code
//
//  Created by Ivan li on 2020/11/19.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKTaskSuspensionTipView.h"

@interface HKTaskSuspensionTipView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *finishRegistLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishTaskLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel1;

@end

@implementation HKTaskSuspensionTipView

-(void)setIsFinishRegist:(BOOL)isFinishRegist{
    _isFinishRegist = isFinishRegist;
    if (_isFinishRegist) {
        self.finishRegistLabel.hidden = NO;
        self.bottomLabel1.hidden = NO;
    }else{
        self.iconImgV.hidden = NO;
        self.finishTaskLabel.hidden = NO;
        self.bottomLabel.hidden = NO;
    }
    
}
@end
