//
//  HKPresentHeader.h
//  Code
//
//  Created by hanchuangkeji on 2017/11/8.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKPresentHeaderModel.h"
#import "HKVerticalDayButton.h"

@protocol HKPresentHeaderDelegate<NSObject>

@optional
- (void)finishPresenBtnClcik:(HKPresentHeaderModel *)model;

@end


@interface HKPresentHeader : UIView

@property (nonatomic, strong)HKPresentHeaderModel *model;

//- (void)setModel:(HKPresentHeaderModel *)model lastGold:(int)lastGold;

- (void)changeBtnCenterX;

@property (nonatomic, weak)id<HKPresentHeaderDelegate> delegate;

@end






