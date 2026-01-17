//
//  HKCycleContentView.h
//  Code
//
//  Created by yxma on 2020/9/24.
//  Copyright © 2020 pg. All rights reserved.
//

#import "LPContentView.h"

NS_ASSUME_NONNULL_BEGIN
@class HKFollowVideoModel;

@interface HKCycleContentView : LPContentView
@property (nonatomic, strong) HKFollowVideoModel * followVideoModel;
@property (nonatomic, copy) void(^lookBlock)(void);

@end

NS_ASSUME_NONNULL_END
