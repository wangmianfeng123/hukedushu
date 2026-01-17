//
//  HomeVideoVC.h
//   Code
//
//  Created by Ivan li on 2017/7/20.
//  Copyright © 2017年 pg. All rights reserved.

#import "HKBaseVC.h"

@class HKHomeIMGuideView,HomeReadBookGuideView,HKLearnGuidView,HKHtmlDialogVC;

@interface HomeVideoVC : HKBaseVC

@property(nonatomic,weak)HKHomeIMGuideView *iMGuideView;

@property(nonatomic,weak)HomeReadBookGuideView *readBookGuideView;

@property(nonatomic,assign)BOOL isBottomViewLogin;
@property (nonatomic , copy)NSString * showTimeOutLogin;//需要展示登录过期toast；
@property (nonatomic , assign)BOOL showoActivityed;//是否展示过活动弹窗

@property (nonatomic , assign)HKHtmlDialogVC * dialogVC;//是否展示过活动弹窗
@property (nonatomic , assign)BOOL showingTips; //正在loading数据

- (void)loadRemindLiveData;
@end



