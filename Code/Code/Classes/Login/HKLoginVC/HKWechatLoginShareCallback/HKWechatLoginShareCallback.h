//
//  HKLoginVCCallback.h
//  Code
//
//  Created by Ivan li on 2019/11/21.
//  Copyright © 2019 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKWechatLoginShareCallback : NSObject

+ (instancetype)sharedInstance;
/// 微信登录回调
@property(nonatomic,copy,nullable) void (^wechatLoginCallback)(NSDictionary *userInfoDict);
/// 微信分享回调
@property(nonatomic,copy,nullable) void (^wechatShareCallback)();

@end

NS_ASSUME_NONNULL_END
