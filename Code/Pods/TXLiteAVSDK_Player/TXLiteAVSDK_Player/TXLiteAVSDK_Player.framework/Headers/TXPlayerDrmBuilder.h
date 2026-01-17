//  Copyright © 2021 Tencent. All rights reserved.

#import <Foundation/Foundation.h>

/// @addtogroup TXVodPlayConfig_ios
/// @{

/// 点播Drm构造器
@interface TXPlayerDrmBuilder : NSObject
/// 证书提供商url
@property(strong, nonatomic) NSString *deviceCertificateUrl;
/// 解密key url
@property(strong, nonatomic) NSString *keyLicenseUrl;
/// 播放链接
@property(strong, nonatomic) NSString *playUrl;

@end
/// @}
