//
//  HKTrainCommentVC.h
//  Code
//
//  Created by Ivan li on 2021/3/31.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKBaseVC.h"
#import "HKTrainDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKTrainCommentVC : HKBaseVC
@property (nonatomic, strong) HKTrainDetailTaskCalendarModel *taskCalendarModel;
@property (nonatomic, copy)NSString *trainingId;

@property (nonatomic, copy)NSString *date;
@property (nonatomic, copy)void (^showWeChatCodeBlock)();
@property (nonatomic, copy) NSString * typeString;  //all: 全部 my:我的 black：小黑屋

@end

NS_ASSUME_NONNULL_END
