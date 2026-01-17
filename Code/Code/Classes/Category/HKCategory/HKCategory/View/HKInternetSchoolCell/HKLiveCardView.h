//
//  HKLiveCardView.h
//  Code
//
//  Created by eon Z on 2021/12/17.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKLiveListModel;

@interface HKLiveCardView : UIView
@property (nonatomic , strong) HKLiveListModel * liveModel;

@end

NS_ASSUME_NONNULL_END
