//
//  HKPicSwitchView.h
//  Code
//
//  Created by Ivan li on 2018/7/20.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HKPicSwitchViewDelegate <NSObject>

- (void)hkPicSwitchClick:(UISwitch*)sender;

@end

@interface HKPicSwitchView : UIView

@property (nonatomic,copy) void (^hKPicSwitchBlock) ();

@property (nonatomic,weak) id<HKPicSwitchViewDelegate> delegate;

@property (nonatomic,strong) UIView *coverView;

@end
