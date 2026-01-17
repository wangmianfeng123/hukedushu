//
//  HKEmptyRootVC.h
//  Code
//
//  Created by Ivan li on 2019/4/25.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKEmptyRootVC : HKBaseVC
@property (nonatomic, copy) void(^agreeBtnBlock)(BOOL isFinishAuthView);

@end

NS_ASSUME_NONNULL_END
