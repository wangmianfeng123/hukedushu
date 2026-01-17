//
//  MyInfoViewController+Category.h
//  Code
//
//  Created by Ivan li on 2018/5/15.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "MyInfoViewController.h"

@interface MyInfoViewController (Category)

/**
 联系客服 弹出框

 @param phone 电话号码
 @param qq
 */
- (void)contactService:(NSString*)phone qq:(NSString*)qq;

/** 打开QQ 联系客服 */
- (void)contactServiceWithQQ:(NSString*)QQNumber;

/** 缓存路径 */
- (NSString *)cachePath;

/** 保存缓存 */
- (void)saveCacheData:(NSDictionary *)dict;

@end
