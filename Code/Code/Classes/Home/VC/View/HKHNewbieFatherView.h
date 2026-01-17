//
//  HKHNewbieFatherView.h
//  Code
//
//  Created by yxma on 2020/11/10.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HNewbieTaskView,HKNewTaskModel;

@interface HKHNewbieFatherView : UIView
@property (nonatomic, assign) int alertType; //1.新手任务第一步 2.新手任务结束后台的领取训练营任务 3.领取成功立即体验 4.老用户查看福利 5.新手任务第二步 6.新手任务第三步
@property (nonatomic, copy) void(^finishBtnBlock)(void);
@property (nonatomic, strong) HNewbieTaskView * taskView;
@property (nonatomic , strong) HKNewTaskModel * model;
@end

NS_ASSUME_NONNULL_END
