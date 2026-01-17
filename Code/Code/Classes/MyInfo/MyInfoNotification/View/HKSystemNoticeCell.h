//
//  HKSystemNoticeCell.h
//  Code
//
//  Created by Ivan li on 2021/4/2.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKSystemNotiMsgModel;

@interface HKSystemNoticeCell : UITableViewCell
@property (nonatomic , strong) HKSystemNotiMsgModel * model;
@end

NS_ASSUME_NONNULL_END
