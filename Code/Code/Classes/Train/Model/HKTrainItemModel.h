//
//  HKTrainItemModel.h
//  Code
//
//  Created by hanchuangkeji on 2019/1/21.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@class HKTrainItemMyWorkModel;
@class HKTrainItemTodayCourseModel;
@class HKTrainItemtTaskRecordsModel;
@class HKTrainItemtTaskRecordsItemModel;


@interface HKTrainItemModel : NSObject

@property (nonatomic, copy)NSString *todayDate;

@property (nonatomic, assign)int status;

@property (nonatomic, assign)BOOL todayCompleted;

@property (nonatomic, strong)HKTrainItemMyWorkModel *myWork;

@property (nonatomic, strong)HKTrainItemTodayCourseModel *todayCourse;

@property (nonatomic, strong)HKTrainItemtTaskRecordsModel *taskRecords;

@end



@interface HKTrainItemMyWorkModel : NSObject

@property (nonatomic, copy)NSString *myWorkH5Url;

@property(nonatomic,strong)ShareModel *shareData; // 分享

@end

@interface HKTrainItemTodayCourseModel : NSObject

@property (nonatomic, copy)NSString *video_id;

@property (nonatomic, copy)NSString *teacher_id;

@property (nonatomic, copy)NSString *video_titel;

@property (nonatomic, copy)NSString *img_cover_url;

@property (nonatomic, copy)NSString *video_duration;

@property (nonatomic, copy)NSString *viedeo_difficulty;

@property (nonatomic, copy)NSString *video_url;

@property (nonatomic, copy)NSString *video_application;

@property (nonatomic, copy)NSString *opened_at;

@property (nonatomic, copy)NSString *video_play;

@property (nonatomic, copy)NSString *img_cover_url_big;

@property (nonatomic, assign)BOOL canPlay;

@end



@interface HKTrainItemtTaskRecordsModel : NSObject

@property (nonatomic, copy)NSString *userTotal;

@property (nonatomic, copy)NSString *lastId;

@property (nonatomic, assign)BOOL is_end;

@property (nonatomic, strong)NSMutableArray<HKTrainItemtTaskRecordsItemModel *> *list;

@end

@interface HKTrainItemtTaskRecordsItemModel : NSObject

@property (nonatomic, copy)NSString *ID;

@property (nonatomic, copy)NSString *training_id;

@property (nonatomic, copy)NSString *uid;

@property (nonatomic, copy)NSString *username;

@property (nonatomic, copy)NSString *avator;

@property (nonatomic, copy)NSString *task_desc;

@property (nonatomic, copy)NSString *image_url;

@property (nonatomic, copy)NSString *created_at;

@property (nonatomic, copy)NSString *time_desc;

@property (nonatomic, copy)NSString *vip_class;

@property (nonatomic, strong)UIImageView *imageViewTemp; // 获取网络图的宽高

@property (nonatomic, strong)UIImage *imageTemp;

@property (nonatomic, assign)CGFloat imageWidth;

@property (nonatomic, assign)CGFloat imageHeight;

@property (nonatomic, assign)CGFloat taskDescHeight;

@end



NS_ASSUME_NONNULL_END
