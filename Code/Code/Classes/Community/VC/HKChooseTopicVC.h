//
//  HKChooseTopicVC.h
//  Code
//
//  Created by Ivan li on 2021/1/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKBaseVC.h"

NS_ASSUME_NONNULL_BEGIN
@class HKMonmentTagModel;

@interface HKChooseTopicVC : HKBaseVC
@property (nonatomic , strong) void(^topicModelBlock)(HKMonmentTagModel * model);

@end

NS_ASSUME_NONNULL_END
