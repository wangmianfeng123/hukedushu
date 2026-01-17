//
//  HKShortVideoControlView+Category.h
//  Code
//
//  Created by Ivan li on 2019/3/25.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKShortVideoControlView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKShortVideoControlView (Category)

/**
 播放时 移动流量 提醒
 
 @param sure (确定按钮 回调)
 */
- (void)playtipByWWAN:(void(^)())sureAction cancelAction: (void(^)())cancelAction;

@end

NS_ASSUME_NONNULL_END


