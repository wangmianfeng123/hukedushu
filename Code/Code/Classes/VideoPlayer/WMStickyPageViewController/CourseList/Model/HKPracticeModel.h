//
//  HKPracticeModel.h
//  Code
//
//  Created by hanchuangkeji on 2017/10/30.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoModel.h"

@interface HKPracticeModel : NSObject

@property (nonatomic, copy)NSString *title;
@property (nonatomic, assign)BOOL watched;// 是否已经看过
@property (nonatomic, strong)VideoModel *model;
@property (nonatomic, copy)NSString *video_id;
@property (nonatomic, assign)BOOL is_study;
@property (nonatomic, assign)BOOL isLocalCache; // 本地缓存
@property (nonatomic, assign)int videoType; // 视频类型
@end
