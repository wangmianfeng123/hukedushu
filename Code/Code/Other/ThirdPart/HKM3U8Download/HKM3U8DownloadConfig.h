//
//  HKM3U8DownloadConfig1.h
//  Code
//
//  Created by Ivan li on 2020/1/14.
//  Copyright © 2020 pg. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface HKM3U8DownloadConfig : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSInteger maxConcurrenceCount;
@property (nonatomic, copy) NSString *localhost;
@end

NS_ASSUME_NONNULL_END

