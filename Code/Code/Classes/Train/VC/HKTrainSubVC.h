//
//  HKTrainSubVC.h
//  Code
//
//  Created by Ivan li on 2021/3/31.
//  Copyright © 2021 pg. All rights reserved.
//

#import "WMStickyPageControllerTool.h"
#import "HKTrainDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKTrainSubVC : WMStickyPageControllerTool

@property (nonatomic, copy)NSString *trainingId;

@property (nonatomic, copy)NSString *date;
/// 显示微信二维码 弹窗block
@property (nonatomic, copy)void (^showWeChatCodeBlock)();
@property (nonatomic, strong) HKTrainDetailTaskCalendarModel *taskCalendarModel;
@property (nonatomic , strong) void(^updateDataBlock)(HKTrainDetailModel * detailModel);
@property (nonatomic , assign) CGFloat kWMHeaderViewHeight ;

- (void)scrollToHeaderViewHeight;
@end

NS_ASSUME_NONNULL_END
