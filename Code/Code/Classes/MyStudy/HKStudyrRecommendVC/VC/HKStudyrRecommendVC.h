//
//  HKStudyrRecommendVC.h
//  Code
//
//  Created by Ivan li on 2019/3/24.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKStudyrRecommendVC : HKBaseVC
/** 返回前控制器回调 */
@property(nonatomic,copy)void (^backFrontVCCallBack)();

@end

NS_ASSUME_NONNULL_END
