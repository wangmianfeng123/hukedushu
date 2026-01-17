//
//  HKSearchAllInfoModel.h
//  Code
//
//  Created by Ivan li on 2017/11/29.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import"TagModel.h"

@class HKUserModel,VideoModel,TagModel;


@interface HKSearchAllInfoModel : NSObject

@property(nonatomic,copy)NSString *keyword;
/** 结果数量  */
@property(nonatomic,copy)NSString *count;
/** 视频 */
@property (nonatomic, strong)NSMutableArray<VideoModel *> *list;
/** 教师 */
@property (nonatomic, strong)NSMutableArray<HKUserModel *> *teacher_list;
/** 筛选标签 */
@property (nonatomic, strong)NSMutableArray<TagModel *> *class_list;

@end
