//
//  HKAudioHotVC.h
//  Code
//
//  Created by Ivan li on 2018/4/18.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKBaseVC.h"
#import "HKArticleCategoryModel.h"


//支付结果代理
@protocol HKArticleListVCDelegate <NSObject>

- (void)todayView:(NSString *)count hide:(BOOL)hide;

@end

@interface HKArticleListVC : HKBaseVC

@property (nonatomic, strong)HKArticleCategoryModel *model;

@property (nonatomic, copy)NSString *url;

@property (nonatomic, assign)BOOL isTeacherVC;// 来自教师主页 不用设置inset

@property (nonatomic, strong)HKUserModel *teacher;

@property (nonatomic, assign)BOOL isMyCollection;// 来自自己收藏的文章

@property (nonatomic, weak)id<HKArticleListVCDelegate> delegate;

@end
