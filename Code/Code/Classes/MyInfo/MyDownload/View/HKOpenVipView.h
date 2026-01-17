//
//  HKOpenVipView.h
//  Code
//
//  Created by eon Z on 2022/2/10.
//  Copyright © 2022 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKOpenVipView : UIView
@property (nonatomic,strong) void(^didOpenVipBtnBlock)(void);

@end

NS_ASSUME_NONNULL_END
