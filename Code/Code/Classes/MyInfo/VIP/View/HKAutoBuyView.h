//
//  HKAutoBuyView.h
//  Code
//
//  Created by yxma on 2020/10/23.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKRenewalInfoModel;

@interface HKAutoBuyView : UIView
+ (HKAutoBuyView *)createView;

@property (nonatomic, copy) void(^knownBlock)(void);
@property (nonatomic, strong) HKRenewalInfoModel * renewalInfoModel;


@end

NS_ASSUME_NONNULL_END
