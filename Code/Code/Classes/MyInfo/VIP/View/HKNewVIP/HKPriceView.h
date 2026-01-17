//
//  HKPriceView.h
//  Code
//
//  Created by eon Z on 2021/11/16.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKBuyVipModel;

@interface HKPriceView : UIView
//@property (nonatomic, strong)HKBuyVipModel * allVipAutoRenewalModel; // 全站通自动续费

@property (nonatomic, strong)HKBuyVipModel * vipModel;
@property (nonatomic, assign)BOOL isClassVip;

@end

NS_ASSUME_NONNULL_END
