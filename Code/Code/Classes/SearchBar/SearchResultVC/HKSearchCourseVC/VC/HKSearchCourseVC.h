//
//  HKSearchCourseVC.h
//  Code
//
//  Created by Ivan li on 2017/11/29.
//  Copyright © 2017年 pg. All rights reserved.
//／

#import "HKBaseVC.h"


//支付结果代理
@protocol HKSearchCourseVCDelegate <NSObject>

@optional
- (void)switchTabIndex:(NSInteger)index model:(VideoModel*)model;

@end


@interface HKSearchCourseVC : HKBaseVC

- (instancetype)initWithKeyWord:(NSString *)keyWord  category:(SearchResult)category;

@property(nonatomic,weak)id<HKSearchCourseVCDelegate> delegate;

/** 更新标题 */
@property(nonatomic,copy)void (^updateTitleCallBack) (NSInteger count);

@end

