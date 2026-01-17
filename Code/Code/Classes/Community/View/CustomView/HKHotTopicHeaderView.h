//
//  HKHotTopicHeaderView.h
//  Code
//
//  Created by Ivan li on 2021/1/20.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKSubjectInfoModel;

@interface HKHotTopicHeaderView : UIView
@property (nonatomic , strong) void(^didTapBlock)(void);
@property (nonatomic , strong) HKSubjectInfoModel * info;
@property (nonatomic , strong) void(^didShareBlock)(void);

@end

NS_ASSUME_NONNULL_END
