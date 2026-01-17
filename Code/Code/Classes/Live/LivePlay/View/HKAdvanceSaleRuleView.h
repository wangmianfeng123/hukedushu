//
//  HKAdvanceSaleRuleView.h
//  Code
//
//  Created by Ivan li on 2020/11/25.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKAdvanceSaleRuleView : UIView
@property (nonatomic , strong) void(^didKnowBlock)(void);
@end

NS_ASSUME_NONNULL_END
