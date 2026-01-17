//
//  HKHomeLiveGuidView.h
//  Code
//
//  Created by yxma on 2020/11/13.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKLiveRemindModel;

@interface HKHomeLiveGuidView : UIView
@property (nonatomic , strong) HKLiveRemindModel * model;
@property (nonatomic , assign) BOOL isAnitaiton ;

@end

NS_ASSUME_NONNULL_END
