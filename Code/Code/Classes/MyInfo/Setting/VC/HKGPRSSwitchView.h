//
//  HKGPRSSwitchView.h
//  Code
//
//  Created by Ivan li on 2019/6/3.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKGPRSSwitchView : UIView

@property (nonatomic,assign) BOOL hiddenSwitch;

@property (nonatomic,copy) void(^switchBlock)(UISwitch *sender);
@property (nonatomic,copy) void(^markBtnBlock)(BOOL isRemindMe);

@property (strong, nonatomic) UILabel *titleLB;

@property (nonatomic , assign) BOOL showMarkBtn;

@end


NS_ASSUME_NONNULL_END



