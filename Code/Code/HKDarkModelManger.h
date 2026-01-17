//
//  HKDarkModelManger.h
//  Code
//
//  Created by ivan on 2020/6/5.
//  Copyright © 2020 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKDarkModelManger : NSObject

+ (instancetype)shareInstance;

///  设置APP主题模式
- (void)setAPPUserTheme;

///  更新APP主题模式
- (void)updateAPPUserTheme;

/// 上次保存的主题
+ (NSInteger)hk_lastTheme;

/// 保存的主题
+ (void)hk_saveLastTheme:(NSInteger)themeIndex;



@end

NS_ASSUME_NONNULL_END
