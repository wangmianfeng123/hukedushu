//
//  HKListeningBookVC+Category.h
//  Code
//
//  Created by Ivan li on 2019/7/19.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKListeningBookVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKListeningBookVC (Category)

+ (void)playtipByWWAN:(void(^)())sureAction  cancelAction: (void(^)())cancelAction;

#pragma mark  vip 购买Alert
+ (void)buyVipAlert:(void(^)())sureAction  cancelAction: (void(^)())cancelAction;

#pragma mark  试听已结束 Alert
+ (void)tryAudioAlert:(void(^)())sureAction  cancelAction: (void(^)())cancelAction;

@end

NS_ASSUME_NONNULL_END
