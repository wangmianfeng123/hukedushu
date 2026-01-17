//
//  HKWebTool.h
//  Code
//
//  Created by Ivan li on 2018/8/28.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKWebTool : NSObject

/** 清空 Web 缓存 */
+ (void)clearnWebCache;

/** 设置Html 路径 请求头 */
+ (NSMutableURLRequest*)requestHeaderFieldWithUrl:(NSString*)url;

@end
