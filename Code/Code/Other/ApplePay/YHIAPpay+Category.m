//
//  YHIAPpay+Category.m
//  Code
//
//  Created by Ivan li on 2020/1/14.
//  Copyright © 2020 pg. All rights reserved.
//

#import "YHIAPpay+Category.h"


@implementation YHIAPpay (Category)

/// 游客购买
- (void)tourisBuyProductionModel:(HKBuyVipModel *)vipModel
                         successBlock:(void (^)(NSString *orderNo))successBlock
                         failBlock:(void (^)())failBlock {
    [[HKALIYunLogManage sharedInstance] applePayWithStep:@"tourisBuyProductionModel" stepDesc:@"游客购买" payInfo:@"" vipType:vipModel.vip_type];
        self.isPostTimeOut = YES;
        NSInteger time = HKIsDebug ?5 :2;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.isPostTimeOut) {
                failBlock ?failBlock(): nil;
            }
        });
    
    [HKHttpTool POST:PAY_IOS_REVIEW_ORDER_RECORD parameters:nil success:^(id responseObject) {
        self.isPostTimeOut = NO;
        if (HKReponseOK) {
            HKBuyVipModel *vipModel = [HKBuyVipModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.touristOrderNo = vipModel.out_trade_no;
            successBlock ?successBlock(self.touristOrderNo): nil;
        }else{
            failBlock ?failBlock(): nil;
        }
    } failure:^(NSError *error) {
        self.isPostTimeOut = NO;
        failBlock ?failBlock(): nil;
    }];
}

@end
