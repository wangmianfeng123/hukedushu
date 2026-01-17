//
//  HKLiveCourseInfoCell.h
//  Code
//
//  Created by hanchuangkeji on 2018/10/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKLiveDetailModel.h"
#import <YYText/YYText.h>
#import <YYText/YYTextContainerView.h>
#import "HKLiveListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKLiveCourseInfoCell : UIView

@property (nonatomic, strong)HKLiveDetailModel *model;

@property (nonatomic, strong)void(^downBtnBlock)(void);
@end

NS_ASSUME_NONNULL_END
