//
//  YHIAPpay.h
//  GWSDK
//
//  Created by blazefire on 2017/8/17.
//  Copyright © 2017年 野火网络. All rights reserved.

#import <Foundation/Foundation.h>
#import "HKBuyVipModel.h"


/*
 
 status = 0;
 receipt = {
 receipt_type = ProductionSandbox;
 app_item_id = 0;
 receipt_creation_date = 2017-09-18 04:53:22 Etc/GMT;
 bundle_id = com.cainiu.HuKeWang;
 original_purchase_date = 2013-08-01 07:00:00 Etc/GMT;
 in_app = (
 {
 product_id = com.cainiu.HuKeWangVIP6;
 quantity = 1;
 transaction_id = 1000000334930197;
 purchase_date_ms = 1505652281000;
 original_purchase_date_pst = 2017-09-17 05:44:41 America/Los_Angeles;
 purchase_date_pst = 2017-09-17 05:44:41 America/Los_Angeles;
 original_purchase_date_ms = 1505652281000;
 is_trial_period = false;
 original_purchase_date = 2017-09-17 12:44:41 Etc/GMT;
 original_transaction_id = 1000000334930197;
 purchase_date = 2017-09-17 12:44:41 Etc/GMT;
 
 */


/*
 21000 App Store无法读取你提供的JSON数据
 21002 订单数据不符合格式
 21003 订单无法被验证
 21004 你提供的共享密钥和账户的共享密钥不一致
 21005 订单服务器当前不可用
 21006 订单是有效的，但订阅服务已经过期。当收到这个信息时，解码后的收据信息也包含在返回内容中
 21007 订单信息是测试用（sandbox），但却被发送到产品环境中验证
 21008 订单信息是产品环境中使用，但却被发送到测试环境中验证
 */

//支付结果代理
@protocol PayResultDelegate <NSObject>

- (void)payWithResult:(HKBuyVipModel *)model payResult:(BOOL)success;

@end

@interface YHIAPpay : NSObject

typedef void (^IAPSuccessBlock)(void);

@property (nonatomic, copy) IAPSuccessBlock iapSuccessBlock;

@property (nonatomic, weak) id<PayResultDelegate> delegate;
/// 游客购买订单号
@property (nonatomic, copy) NSString *touristOrderNo;

@property(nonatomic,assign) BOOL isPostTimeOut;


+ (instancetype)instance;


// 购买订单
- (void)buyProductionModel:(HKBuyVipModel *)vipModel;

//补单处理
- (void)repairReceipt;

//支付
//-(void)buyProduction:(YHPayInfoModel *)payInfoModel;

//-(void)buyProduction:(NSString *)goodsIdentifier;


//检验是否有未验证的receipt
//-(void)checkReceiptWithUID:(NSString *)uid;

//保存票据
//-(void)saveReceipt:(NSString *)receipt orderNo:(NSString *)orderNo;
////删除票据
//- (void)deleteReceipt:(NSString *)orderNo;


//恢复购买
//- (void)restorePurchasesReal;


#pragma mark - 刷新应用程序收据
- (void)restoreRefreshRequest;

- (void)buttonRestoreClick:(id)sender;

- (void)deleteAllRecord ;

@end
