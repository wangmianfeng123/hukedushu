//
//  HKCashPay.h
//  Code
//
//  Created by Ivan li on 2019/11/5.
//  Copyright © 2019 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HKCashPayType) {
    HKCashPayType_AliPay = 0, // 支付宝
    HKCashPayType_WeChatPay, // 微信
};



@protocol HKCashPayDelegate <NSObject>
/// 支付结果回调
- (void)hkCashPayWithResult:(HKBuyVipModel *)model payResult:(BOOL)success;

@end




@interface HKCashPay : NSObject

+ (instancetype)sharedInstance;

@property(nonatomic,assign)HKCashPayType payType;

@property (nonatomic,strong)HKBuyVipModel *payModel;

@property (nonatomic, weak) id<HKCashPayDelegate> delegate;

/// 支付
/// @param vipType
/// @param isupgrade 1-升级VIP，0或不传表示正常充值VIP
/// @param buttonType 相关接口会给，没有可不传
/// @param couponId 优惠券ID
/// @param payType 支付类型 （支付宝 微信）
- (void)cashPay:(NSString*)vipType
      isupgrade:(BOOL)isupgrade
     buttonType:(NSString*)buttonType
       couponId:(NSString*)couponId
        payType:(HKCashPayType)payType;


/// 支付宝
/// @param vipType vip类型
/// @param isupgrade 1-升级VIP，0或不传表示正常充值VIP
/// @param buttonType 相关接口会给，没有可不传
/// @param couponId 优惠券ID
- (void)aliPayWithVipType:(NSString*)vipType
                isupgrade:(BOOL)isupgrade
               buttonType:(NSString*)buttonType
                 couponId:(NSString*)couponId;


/// 微信支付
/// @param vipType vip类型
/// @param isupgrade 1-升级VIP，0或不传表示正常充值VIP
/// @param buttonType 相关接口会给，没有可不传
/// @param couponId 优惠券ID
- (void)weChatPayWithVipType:(NSString*)vipType
                   isupgrade:(BOOL)isupgrade
                  buttonType:(NSString*)buttonType
                    couponId:(NSString*)couponId;



- (void)cashWithPayType:(HKCashPayType)payType payModel:(HKBuyVipModel*)payModel;



/// 查询 订单支付结果
/// @param orderId 订单号
- (void)queryOrderResultWithId:(NSString*)orderId;

/// 支付结果回调
@property(nonatomic,copy) void(^payResultCallBack)(HKBuyVipModel *payModel);

@end


NS_ASSUME_NONNULL_END
