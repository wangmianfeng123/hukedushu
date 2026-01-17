//
//  HKCashPay.m
//  Code
//
//  Created by Ivan li on 2019/11/5.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKCashPay.h"
#import <AlipaySDK/AlipaySDK.h>
#import "HKBuyVipModel.h"

@implementation HKCashPay


+ (instancetype)sharedInstance {
    
    static HKCashPay *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)setPayType:(HKCashPayType)payType {
    _payType = payType;
}


- (void)aliPayWithVipType:(NSString*)vipType  isupgrade:(BOOL)isupgrade buttonType:(NSString*)buttonType couponId:(NSString*)couponId {
    [self cashPay:vipType isupgrade:isupgrade buttonType:buttonType couponId:couponId payType:self.payType];
}


- (void)weChatPayWithVipType:(NSString*)vipType  isupgrade:(BOOL)isupgrade buttonType:(NSString*)buttonType couponId:(NSString*)couponId {
    [self cashPay:vipType isupgrade:isupgrade buttonType:buttonType couponId:couponId payType:self.payType];
}



///  支付
/// @param vip_type vip类型
/// @param is_upgrade 1-升级VIP，0或不传表示正常充值VIP
/// @param button_type 相关接口会给，没有可不传
/// @param coupon_id 优惠券ID，没有可不传
- (void)cashPay:(NSString*)vipType  isupgrade:(BOOL)isupgrade buttonType:(NSString*)buttonType couponId:(NSString*)couponId payType:(HKCashPayType)payType {
        
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    if (!isEmpty(vipType)) {
        [dict setValue:vipType forKey:@"vip_type"];
    }
    NSString *str = isupgrade ?@"1" :@"0";
    [dict setValue:str forKey:@"is_upgrade"];
    
    if (!isEmpty(buttonType)) {
        [dict setValue:buttonType forKey:@"button_type"];
    }
    if (!isEmpty(couponId)) {
        [dict setValue:couponId forKey:@"coupon_id"];
    }
    
    NSString *url = nil;
    switch (payType) {
        case HKCashPayType_AliPay:
            url = PAY_ALI_PAY;
            break;
            
        case HKCashPayType_WeChatPay:
            url = PAY_WX_PAY;
        break;
            
        default:
            break;
    }
    
    [HKHttpTool POST:url parameters:dict success:^(id responseObject) {
        if (HKReponseOK) {
            HKBuyVipModel *payModel = [HKBuyVipModel mj_objectWithKeyValues:responseObject[@"data"]];
            [self cashWithPayType:payType payModel:payModel];
        }
    } failure:^(NSError *error) {
        
    }];
}




- (void)cashWithPayType:(HKCashPayType)payType payModel:(HKBuyVipModel*)payModel {
    
    self.payModel = payModel;
    switch (payType) {
        case HKCashPayType_AliPay:
        {
            //开始支付
            if (!isEmpty(payModel.order_string)) {
                @weakify(self);
                [[AlipaySDK defaultService] payOrder:payModel.order_string fromScheme:HKAliPayAppScheme callback:^(NSDictionary *resultDic) {
                    @strongify(self);
                    [self alipayH5_ResultCallBack:resultDic];
                }];
            }
        }
            break;
            
        case HKCashPayType_WeChatPay:
        {
            PayReq *resp = [PayReq new];
            resp.partnerId = payModel.partnerid;
            resp.prepayId = payModel.prepayid;
            resp.nonceStr = payModel.noncestr;
            
            resp.timeStamp = payModel.timestamp;
            resp.package = payModel.packageValue;
            resp.sign = payModel.sign;
            
            [WXApi sendReq:resp completion:^(BOOL success) {
                if (success) {
                    NSLog(@"WXApi");
                }
            }];
        }
        break;
            
        default:
            break;
    }
}






/// 查询 订单支付结果
/// @param orderId 订单号
- (void)queryOrderResultWithId:(NSString*)orderId {
 
    if (isEmpty(orderId)) {
        return;
    }
    // 更换查询URL
    NSString *url = isEmpty(self.payModel.order_query_url) ?PAY_ORDER_QUERY : self.payModel.order_query_url;
    NSDictionary *dict = @{@"out_trade_no" :orderId};
    
    NSString *allUrl = nil;
    if ([url hasPrefix:@"http"]) {
        allUrl = url;
    }
    [HKHttpTool hk_taskPost:url allUrl:allUrl isGet:NO parameters:dict success:^(id responseObject) {
        if (HKReponseOK) {
            // 支付完成
            HKBuyVipModel *vipModel = [HKBuyVipModel mj_objectWithKeyValues:responseObject[@"data"]];
            //if (NO == isEmpty(vipModel.orderNo)) {
                if (self.payResultCallBack) {
                    self.payResultCallBack(vipModel);
                }
                
                if ([self.delegate respondsToSelector:@selector(hkCashPayWithResult:payResult:)]) {
                    [self.delegate hkCashPayWithResult:vipModel payResult:YES];
                }
            //}
        }
    } failure:^(NSError *error) {
        
    }];
}



/// 支付宝 H5 支付 回调
- (void)alipayH5_ResultCallBack:(NSDictionary *)resultDic {
    
    if([[resultDic allKeys] containsObject:@"result"]){
        
        NSString *resultStr = resultDic[@"result"];
        NSDictionary *dict = resultStr.mj_JSONObject;
        
        HKBuyVipModel *vipModel = [HKBuyVipModel mj_objectWithKeyValues:dict[@"alipay_trade_app_pay_response"]];
        NSString *resultStatus = [NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
        if (9000 == [resultStatus intValue]) {
            // 支付成功
            [[[self class] sharedInstance]queryOrderResultWithId:vipModel.out_trade_no];
        }
    }
}



@end












