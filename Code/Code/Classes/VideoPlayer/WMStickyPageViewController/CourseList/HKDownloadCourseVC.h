//
//  HKCourseListVC.h
//  YUFoldingTableViewDemo
//
//  Created by administrator on 16/8/25.
//  Copyright © 2016年 xuanYuLin. All rights reserved.
//

#import "HKBaseVC.h"


@interface HKDownloadCourseVC : HKBaseVC

@property (nonatomic, copy)void(^selectedBlock)(NSArray *array);

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  videoId:(NSString*)videoId  detailModel:(DetailModel*)model;

@property (nonatomic, strong)DetailModel *videlDetailModel;

@end
