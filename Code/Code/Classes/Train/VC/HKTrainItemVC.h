//
//  HKUserLearnedVC.h
//  Code
//
//  Created by Ivan li on 2018/5/21.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKBaseVC.h"
#import "HKTrainDetailModel.h"

@interface HKTrainItemVC : HKBaseVC

@property (nonatomic, copy)NSString *trainingId;

@property (nonatomic, copy)NSString *date;
/// 显示微信二维码 弹窗block
@property (nonatomic, copy)void (^showWeChatCodeBlock)();
@property (nonatomic, strong) HKTrainDetailTaskCalendarModel *taskCalendarModel;

@end
