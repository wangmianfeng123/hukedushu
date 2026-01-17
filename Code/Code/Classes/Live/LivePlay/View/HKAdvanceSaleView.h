//
//  HKAdvanceSaleView.h
//  Code
//
//  Created by Ivan li on 2020/11/23.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKLiveDetailModel;

@interface HKAdvanceSaleView : UIView
@property (nonatomic , strong) void(^didLookBlock)(void);
@property (nonatomic, strong)HKLiveDetailModel *model;

@end

NS_ASSUME_NONNULL_END
