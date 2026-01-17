//  Copyright © 2022 Tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import "TXLiteAVSymbolExport.h"

NS_ASSUME_NONNULL_BEGIN

LITEAV_EXPORT @interface TXPlayerGlobalSetting : NSObject

/**
 @brief  设置播放器Cache缓存目录路径
 @discussion  设置播放器Cache缓存目录路径
 @param  cacheFolder  缓存目录路径，nil 表示不开启缓存
*/
+ (void)setCacheFolderPath:(NSString *)cacheFolder;

/**
 @brief  返回播放器Cache缓存目录的Path
 @discussion  返回播放器Cache缓存目录的Path
 @return  返回 Cache缓存目录的Path
*/
+ (NSString *)cacheFolderPath;

/**
 @brief  设置播放器最大缓存的Cache Size大小
 @discussion  设置播放器最大缓存的Cache Size大小（单位MB）
 @param  maxCacheSizeMB  Cache Size的大小
*/
+ (void)setMaxCacheSize:(NSInteger)maxCacheSizeMB;

/**
 @brief  返回播放器最大缓存的Cache Size大小
 @discussion  返回播放器最大缓存的Cache Size大小（单位M）
 @return  返回 Cache Size的大小
*/
+ (NSInteger)maxCacheSize;

@end

NS_ASSUME_NONNULL_END
