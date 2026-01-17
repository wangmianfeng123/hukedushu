//
//  HKTrainProblemView.h
//  Code
//
//  Created by yxma on 2020/8/25.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKTrainProblemView : UIView
+ (HKTrainProblemView *)createViewFrame:(CGRect)frame;
@property (nonatomic, assign) CGPoint subVCenter;

@end

NS_ASSUME_NONNULL_END
