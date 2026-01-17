//
//  HKBookTimerVC.h
//  Code
//
//  Created by Ivan li on 2019/7/17.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKBookTimerVC : HKBaseVC

@property(nonatomic,copy) void(^bookTimerVCCellClick)(HKBookTimerType timerType,NSTimeInterval seconds,NSInteger currentSelectTimeListIndex);

- (void)setBgViewBackGroundColor;

@end

NS_ASSUME_NONNULL_END
