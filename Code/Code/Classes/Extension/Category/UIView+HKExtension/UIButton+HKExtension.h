//
//  UIButton+HKExtension.h
//  Code
//
//  Created by yxma on 2020/8/25.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (HKExtension)
- (void)buttonCommitAnimationWithAnimateDuration:(CFTimeInterval)duration Completion:(void(^)())completion;

@end

NS_ASSUME_NONNULL_END
