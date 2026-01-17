//
//  HKPaymentView.h
//  Code
//
//  Created by Ivan li on 2019/10/25.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKPaymentView;


typedef NS_ENUM(NSUInteger, HKPaymentViewPayType) {
    HKPaymentViewPayType_None = 0,
    HKPaymentViewPayType_AliPay = 1, // 支付宝
    HKPaymentViewPayType_WeChat, // 微信支付
};


@protocol HKPaymentViewDelegate <NSObject>

- (void)hKPaymentView:(HKPaymentView *)view payType:(HKPaymentViewPayType)payType;

@end


@interface HKPaymentView : UIView

@property(nonatomic,weak)id <HKPaymentViewDelegate> delegate;

@property(nonatomic,assign)HKPaymentViewPayType payType;

@end

NS_ASSUME_NONNULL_END
