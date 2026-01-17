//我的下载-子目录页面
//  HKCourseListVC.h
//  YUFoldingTableViewDemo
//
//  Created by administrator on 16/8/25.
//  Copyright © 2016年 xuanYuLin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YUFoldingTableView.h"
#import "HKBaseVC.h"

@class HKDownloadModel;

@interface HKShowDownloadCourseVC : HKBaseVC

@property (nonatomic, assign) YUFoldingSectionHeaderArrowPosition arrowPosition;

@property (nonatomic, strong)HKDownloadModel *directoryModel;

@end
