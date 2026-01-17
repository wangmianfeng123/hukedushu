//
//  HKRefreshTools.h
//  Code
//
//  Created by Ivan li on 2018/4/12.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKRefreshTools : NSObject

/** header 刷新 */
+ (void)headerRefreshWithTableView:(id )view completion:(void (^)(void))completion;

/** footer 刷新 */
+ (void)footerAutoRefreshWithTableView:(id )view completion:(void (^)(void))completion;

/** gif header 刷新  未导入 GIF */
+ (void)gifHeaderRefreshWithTableView:(id )view completion:(void (^)(void))completion;

/** footer 刷新 短视频 */
+ (void)shortVideoFooterAutoRefreshWithTableView:(id )view completion:(void (^)(void))completion;


/** header 停止加载 */
+ (void)headerEndRefreshing:(id )view;

/** footer 停止加载 */
+ (void)footerStopRefreshing:(id )view;

/** footer 加载完全 */
+ (void)FooterEndRefreshNoMoreData:(id )view;

@end
