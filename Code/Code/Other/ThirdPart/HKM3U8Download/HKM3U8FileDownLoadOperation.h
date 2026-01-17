//
//  HKM3U8FileDownLoadOperation.h
//  Code
//
//  Created by Ivan li on 2020/1/14.
//  Copyright © 2020 pg. All rights reserved.
//


#import <Foundation/Foundation.h>

/* 一个 fileOperation 只负责下载一个文件*/

@class HKSegmentModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^HKM3U8FileDownLoadOperationResultBlock)(NSError * _Nullable error,HKSegmentModel * _Nullable info);
@interface HKM3U8FileDownLoadOperation : NSOperation
- (instancetype)initWithFileInfo:(HKSegmentModel*)fileInfo sessionManager:(AFURLSessionManager*)sessionManager resultBlock:(HKM3U8FileDownLoadOperationResultBlock)resultBlock;
@end

NS_ASSUME_NONNULL_END



