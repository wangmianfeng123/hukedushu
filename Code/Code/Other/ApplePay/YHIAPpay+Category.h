//
//  YHIAPpay+Category.h
//  Code
//
//  Created by Ivan li on 2020/1/14.
//  Copyright © 2020 pg. All rights reserved.
//

#import "YHIAPpay.h"

NS_ASSUME_NONNULL_BEGIN

@interface YHIAPpay (Category)

/// 游客购买
- (void)tourisBuyProductionModel:(HKBuyVipModel *)vipModel
                    successBlock:(void (^)(NSString *orderNo))successBlock
                       failBlock:(void (^)())failBlock;

@end

NS_ASSUME_NONNULL_END
