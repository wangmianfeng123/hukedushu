//
//  HKOpenPushView.h
//  Code
//
//  Created by Ivan li on 2019/8/6.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKOpenPushView : UIView

/** 关闭Block*/
@property (nonatomic , copy ) void (^closeBlock)(void);

@end

NS_ASSUME_NONNULL_END
