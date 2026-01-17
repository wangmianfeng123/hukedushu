//
//  HKSettingCell.h
//  Code
//
//  Created by hanchuangkeji on 2017/12/12.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKSettingModel.h"

@class HKSwitchBtn,HKPushNoticeModel;

@interface HKSettingCell : UITableViewCell

@property (nonatomic, strong) HKSettingModel *model;
@property (nonatomic , strong) HKPushNoticeModel * noticeModel;
@property (weak, nonatomic) IBOutlet UIImageView *ArrowIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;

/** 截屏开关 */
@property (strong, nonatomic) HKSwitchBtn *switchBtn;

@property (nonatomic,assign) BOOL hiddenSwitch;

@property (nonatomic,copy) void(^switchBlock)(UISwitch *sender);

- (void)setSiwtchBtnState:(BOOL)on;

@end
