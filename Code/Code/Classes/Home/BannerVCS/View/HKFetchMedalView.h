//
//  HKFetchMedalView.h
//  Code
//
//  Created by Ivan li on 2021/8/5.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKMedalModel;

@interface HKFetchMedalView : UIView
@property (nonatomic , strong) HKMedalModel *model;
@property (nonatomic , strong) void(^fetchUrlBlock)(NSString *url);

@end

NS_ASSUME_NONNULL_END
