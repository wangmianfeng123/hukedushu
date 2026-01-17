//
//  HKStudyTagModel.h
//  Code
//
//  Created by Ivan li on 2018/5/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKStudyTagModel : NSObject

@property(nonatomic,copy)NSString *title;
/** 标记选择状态  yes - 选中 */
//@property(nonatomic,assign)BOOL isSelect;

@property(nonatomic,copy)NSString *classId;

@property(nonatomic,copy)NSString *name;

/** 1 选中 0 -非 */
@property(nonatomic,assign)BOOL is_select;

/******* 兴趣新增字段 ********/
@property(nonatomic,copy)NSString *class_id;

@property(nonatomic,assign)NSInteger parent_id;

@property(nonatomic,strong)NSMutableArray <HKStudyTagModel*> *children;

@end

