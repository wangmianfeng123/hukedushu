//
//  HKSwitchBtn.h
//  Code
//
//  Created by Ivan li on 2018/7/11.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HKSwitchBtnDelegate <NSObject>

- (void)switchClick:(UISwitch*)sender;

@end



@interface HKSwitchBtn : UISwitch

@property (nonatomic,weak) id<HKSwitchBtnDelegate> delegate;

@end
