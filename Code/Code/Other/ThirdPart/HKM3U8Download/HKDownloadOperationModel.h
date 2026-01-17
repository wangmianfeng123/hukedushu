//
//  HKDownloadOperationModel.h
//  Code
//
//  Created by eon Z on 2021/12/29.
//  Copyright © 2021 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKM3U8FileDownLoadOperation.h"
NS_ASSUME_NONNULL_BEGIN

@interface HKDownloadOperationModel : NSObject
@property (nonatomic , copy) NSString * url;
@property (nonatomic , strong) HKM3U8FileDownLoadOperation * opration;

@end

NS_ASSUME_NONNULL_END
