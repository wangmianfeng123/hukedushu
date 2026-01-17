//
//  HKPushNotiCell.h
//  Code
//
//  Created by eon Z on 2022/2/10.
//  Copyright © 2022 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKSwitchBtn,HKPushNoticeModel;

@interface HKPushNotiCell : UITableViewCell

@property (nonatomic,copy) void(^switchBlock)(UISwitch *sender);

@property (nonatomic,copy) void(^setBtnBlock)(void);

@property (nonatomic , strong) HKPushNoticeModel * noticeModel;

@end

NS_ASSUME_NONNULL_END
