//
//  HKCategroyVipView.h
//  Code
//
//  Created by Ivan li on 2021/7/12.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKBuyVipModel;

@interface HKCategroyVipView : UIView
@property (nonatomic , strong) HKBuyVipModel * vipModel;
//@property (nonatomic , strong) void(^didVipViewBlock)(HKCategroyVipView * vipView);
@property (nonatomic, assign)BOOL is_selected;
@end

NS_ASSUME_NONNULL_END
