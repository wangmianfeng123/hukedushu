//
//  HKLiveRemindModel.h
//  Code
//
//  Created by Ivan li on 2020/11/20.
//  Copyright © 2020 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKLiveRemindModel : NSObject

@property (nonatomic, copy)NSString * ID;
@property (nonatomic, copy)NSString * live_course_id;
@property (nonatomic, copy)NSString * class_id;
@property (nonatomic, copy)NSString * is_charge;
@property (nonatomic, copy)NSString * title;
@property (nonatomic, copy)NSString * nowTid;
@property (nonatomic, copy)NSString * filter_class;
@property (nonatomic, copy)NSString * tid;
@property (nonatomic, copy)NSString * tidTwo;
@property (nonatomic, copy)NSString * small_cover;
@property (nonatomic, copy)NSString * detail_cover;
@property (nonatomic, copy)NSString * teacherName;
@property (nonatomic, copy)NSString * teacherNameTwo;
@property (nonatomic, copy)NSString * avator;
@property (nonatomic, copy)NSString * avatorTwo;

@end

NS_ASSUME_NONNULL_END
