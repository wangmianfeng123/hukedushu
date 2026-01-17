//
//  HkNetworkManageCenter.h
//  Code
//
//  Created by Ivan li on 2019/1/28.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^NetWorkStatusBlock)(NSInteger status);

@interface HkNetworkManageCenter : NSObject

+ (instancetype)shareInstance;
/** 网络状态值 */
@property(nonatomic,assign,readonly) AFNetworkReachabilityStatus networkStatus;

@property(nonatomic,assign,readonly) BOOL isNoActiveNetStatus;
/// 网络切换前 的状态
@property(nonatomic,assign,readonly) AFNetworkReachabilityStatus frontNetworkStatus;

@end




NS_ASSUME_NONNULL_END


