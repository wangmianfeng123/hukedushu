//
//  HKBridgeDirectory1_8Model.h
//  Code
//
//  Created by hanchuangkeji on 2018/1/12.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKDownloadModel.h"

@interface HKBridgeDirectory1_8Model : NSObject

@property (nonatomic, strong)NSMutableArray *route_dir_list;// 软件入门详情目录

@property (nonatomic, strong)NSMutableArray *series_dir_list;// 系列课，PCG,详情目录

@property (nonatomic, strong)HKDownloadModel *dir_data;// 目录

// 查询的video_id
@property (nonatomic, copy)NSString *video_id;

// 查询的video_type
@property (nonatomic, assign)int video_type;

@end
