//
//  HKJobModel.h
//  Code
//
//  Created by Ivan li on 2018/6/20.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKJobModel : NSObject

@property (nonatomic,copy)NSString *ID;

@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *selectd;

@property (nonatomic,copy)NSString *job_id;
/** 0-未选中 1- */
@property (nonatomic,assign)BOOL is_selectd;

@end
