//
//  HKMyLiveListVC.h
//  Code
//
//  Created by Ivan li on 2020/12/25.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKMyLiveListVC : HKBaseVC

@property (nonatomic , strong) NSString * type;  // 0:全部 （默认值）1:直播中  2:待学习（未开始） 3:有回放 4:免费 5:付费
@property (nonatomic , strong) void(^fetchTagArrayBlock)(NSArray *tagArray);
@end

NS_ASSUME_NONNULL_END
