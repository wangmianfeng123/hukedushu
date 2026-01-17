//
//  HKUpdateAppView.h
//  Code
//
//  Created by Ivan li on 2019/8/7.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKVersionModel;

@interface HKUpdateAppView : UIView

/** 关闭Block*/
@property (nonatomic , copy ) void (^closeBlock)(void);
/** 更新Block*/
@property (nonatomic , copy ) void (^updateBlock)(void);

@property (nonatomic,strong) HKVersionModel *model;

@end

NS_ASSUME_NONNULL_END
