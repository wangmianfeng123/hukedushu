//
//  HKTrainDetailModel.h
//  Code
//
//  Created by hanchuangkeji on 2019/1/15.
//  Copyright © 2019年 pg. All rights reserved.
//


//{
//    "business_code" = 200;
//    "business_message" = "\U83b7\U53d6\U6210\U529f";
//    end = 1601222399;  //结束时间
//    "entry_num" = 4;  //报名人数
//    "entry_state" = 2; //报名状态 1：开始 2： 结束
//    id = 266; //训练营id
//    name = "\U30103\U6708\U3011UI\U96f6\U57fa\U7840\U5165\U95e8 \U8f6f\U4ef6\U5fc5\U4fee\U8bfe";//训练营名称
//    start = 1585238400; //开始时间
//    state = 1; //训练营状态 1：进行中 2： 结束
//    status = 1; //状态1 ：开启 0 没有
//    "teacher_qrcode" = "https://pic.huke88.com/image/000/000/000/13CE7237-21F2-5AAA-BCE2-D05AD0C16796.jpg";//老师二维码
//    "teacher_weixin" = 111; //老师微信
//    "total_days" = 185;  //训练营周期多少天
//    "total_user_num" = 0; //训练营打卡总数
//    "user_task_day" = 0;  //用户打开第几天
//    "date_list" =         (
//                    {
//            colorControl = 1;
//            date = "09/04";
//            "full_date" = "2020-09-04";
//            "is_open" = 0;
//            "is_start" = 0;
//            week = "\U5468\U4e94";
//        }
//    );
//
//    rankInfo =         {
//        like = 0;
//        rank = 1;   //当前排名
//        rankPcent = 0; //击败多少人%
//        taskNum = 0;  //用户上传作品数
//    };
//
//    "task_list" =         {
//        "clock_open" = 1;
//        "is_all_task_finish" = 0;
//        "is_clock" = 0;
//        "is_look" = 0;
//        "is_share" = 0;
//        list =             (
//        );
//        "share_url" = "https://m-test.huke88.com/training-task/share?id=266&uid=716733552&task_id=";
//        "user_task_id" = "";
//        "video_id" = "";
//        "video_title" = "<null>";
//        "work_num" = 0;
//        "work_stars_num" = 0;
//    };
//
//};


#import <Foundation/Foundation.h>
#import "DetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@class HKTrainDetailInfoModel;
@class HKTrainDetailTaskProgressModel;
@class HKTrainDetailTaskCalendarModel;
@class HKTrainTaskModel;
@class HKTrainRankInfoModel;
@class HKAllTrainTaskModel;
@class HKDayTaskGifModel;
@class HKTrainTaskLiveParamModel,HKTrainTaskVideoModel;

@interface HKTrainDetailModel : NSObject
//老的字段
@property (nonatomic, copy)NSString *todayDate;
@property (nonatomic, assign)BOOL todayCompleted; // 今日是否已完成打卡(0:未完成  1:已完成)
//@property (nonatomic, strong)HKTrainDetailInfoModel *info;
@property (nonatomic, strong)HKTrainDetailTaskProgressModel *taskProgress;
//@property (nonatomic, strong)NSMutableArray<HKTrainDetailTaskCalendarModel *>   *taskCalendar;
@property (nonatomic, strong)NSMutableArray<HKTrainTaskModel *>   *TaskModelArray;

//新字段
@property (nonatomic, strong)NSMutableArray<HKTrainDetailTaskCalendarModel *>   *date_list;
@property (nonatomic, strong)HKAllTrainTaskModel * task_list;
@property (nonatomic, strong) HKTrainRankInfoModel * rankInfo;

@property (nonatomic , strong) HKTrainTaskVideoModel * video;

@property (nonatomic, copy) NSString * end;
@property (nonatomic, copy) NSString * entry_num;
@property (nonatomic, assign) NSInteger entry_state;
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * start;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString * teacher_qrcode;
@property (nonatomic, copy) NSString * teacher_weixin;
@property (nonatomic, assign)NSInteger total_days;
@property (nonatomic, assign) NSInteger total_user_num;
@property (nonatomic, assign) NSInteger user_task_day;

@property (nonatomic, assign) CGFloat cellHeight;

@end


@interface HKTrainTaskVideoModel : NSObject
@property (nonatomic, copy)NSString * ID;
@property (nonatomic, copy)NSString * level_id;
@property (nonatomic, copy)NSString * opened_at;
@property (nonatomic, copy)NSString * gif_url;
@property (nonatomic, copy)NSString * image_url;
@property (nonatomic, copy)NSString * title;
@property (nonatomic, copy)NSString * time;
@property (nonatomic, copy)NSString * case_url;
@property (nonatomic, copy)NSString * desc;
@end


//    end = 1601222399;  //结束时间
//    "entry_num" = 4;  //报名人数
//    "entry_state" = 2; //报名状态 1：开始 2： 结束
//    id = 266; //训练营id
//    name = "\U30103\U6708\U3011UI\U96f6\U57fa\U7840\U5165\U95e8 \U8f6f\U4ef6\U5fc5\U4fee\U8bfe";
//    start = 1585238400; //开始时间
//    state = 1; //训练营状态 1：进行中 2： 结束
//    status = 1; //状态1 ：开启 0 没有
//    "teacher_qrcode" = "https://pic.huke88.com/image/000/000/000/13CE7237-21F2-5AAA-BCE2-D05AD0C16796.jpg";//老师二维码
//    "teacher_weixin" = 111; //老师微信
//    "total_days" = 185;  //训练营周期多少天
//    "total_user_num" = 0; //训练营打卡总数
//    "user_task_day" = 0;  //用户打开第几天



//"clock_open" = 1;
//"is_all_task_finish" = 0;
//"is_clock" = 0;
//"is_look" = 0;
//"is_share" = 0;
//"share_url" = "https://m-test.huke88.com/training-task/share?id=266&uid=716733552&task_id=";
//"user_task_id" = "";
//"video_id" = "";
//"video_title" = "<null>";
//"work_num" = 0;
//"work_stars_num" = 0;
//list =             (
//);

@interface HKAllTrainTaskModel : NSObject
@property (nonatomic, copy) NSString * video_title;
@property (nonatomic, copy) NSString * user_task_id;
@property (nonatomic, copy) NSString * share_url;
@property (nonatomic, copy) NSString * video_id;
@property (nonatomic, copy) NSString * time;
@property (nonatomic, copy) NSString * task_image_url;
@property (nonatomic, copy) NSString * video_image_url;


@property (nonatomic, assign) int clock_open;
@property (nonatomic, assign) int is_all_task_finish;
@property (nonatomic, assign) int is_clock;
@property (nonatomic, assign) int is_look;
@property (nonatomic, assign) int is_share;
@property (nonatomic, assign) int work_num;
@property (nonatomic, assign) int work_stars_num;
@property (nonatomic, strong)NSMutableArray<HKTrainTaskModel *> * list;

@end

//任务model
@interface HKTrainTaskModel : NSObject
@property (nonatomic, copy) NSString * sp_task_id;
@property (nonatomic, copy) NSString * sp_task_name;
@property (nonatomic, copy) NSString * sp_task_type;
@property (nonatomic, copy) NSString * sp_task_value;
@property (nonatomic, copy) NSString * live_course_id;

@property (nonatomic, copy) NSString * sp_task_finishi_time;
@property (nonatomic, copy) NSString * live_name;
@property (nonatomic, assign) int is_finish;
@property (nonatomic, copy) NSString * live_end_at;
@property (nonatomic, strong) HKTrainTaskLiveParamModel * live_params;
@property (nonatomic, copy) NSString * live_start_at;
@property (nonatomic, assign) int live_status;

@end

@interface HKTrainTaskLiveParamModel : NSObject
@property (nonatomic, copy) NSString * app_id;
@property (nonatomic, copy) NSString * app_secret;
@property (nonatomic, copy) NSString * channel_id;
@property (nonatomic, copy) NSString * user_id;
@end

//天model
@interface HKTrainDetailTaskCalendarModel : NSObject
@property (nonatomic, assign)int colorControl; // 控制日历选项卡的颜色，0:置灰  1:黑色
@property (nonatomic, copy)NSString * date;
@property (nonatomic, copy)NSString * full_date;
@property (nonatomic, assign)BOOL is_open; // 日期是否时选中效果
@property (nonatomic, assign)BOOL is_start; // 课程是否开始 1 开始 0未开
@property (nonatomic, copy)NSString * week;
@end


@interface HKTrainRankInfoModel : NSObject
@property (nonatomic, assign)int like; //
@property (nonatomic, assign)int rank; // 当前排名
@property (nonatomic, assign)int rankPcent; // 击败多少人%
@property (nonatomic, assign)int taskNum; // 用户上传作品数

@end

@interface HKDayTaskModel : NSObject
@property (nonatomic, copy) NSString * date;
@property (nonatomic, assign) int days;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * teacher_qrcode;
@property (nonatomic, copy) NSString * teacher_weixin;
@property (nonatomic, copy) NSString * start;
@property (nonatomic, copy) NSString * end;
@property (nonatomic, strong) HKDayTaskGifModel * gift;
@property (nonatomic, strong)HKAllTrainTaskModel * sp_task_list;
@end

@interface HKDayTaskGifModel : NSObject
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * display;
@property (nonatomic, assign) int is_get;
@property (nonatomic, copy) NSString * name;
@end


@interface HKTrainDetailInfoModel : NSObject

@property (nonatomic, copy)NSString* ID;

@property (nonatomic, copy)NSString* name;

@property (nonatomic, copy)NSString* img;

@property (nonatomic, copy)NSString* banner;

@property (nonatomic, copy)NSString* start;

@property (nonatomic, copy)NSString* end;

@property (nonatomic, copy)NSString* entry_start;

@property (nonatomic, copy)NSString* entry_end;

@property (nonatomic, copy)NSString* teacher_qrcode;

@property (nonatomic, copy)NSString* entry_num;

@property (nonatomic, copy)NSString* difficulty;

@property (nonatomic, copy)NSString* clazz;

@property (nonatomic, assign)int state; // 训练营的状态(0:未开始 1:进行中 2:已结束)

@property (nonatomic, copy)NSString* state_desc;

@property (nonatomic, copy)NSString* difficultyDesc;
/// 老师微信
@property (nonatomic, copy)NSString* teacher_weixin;


@end



@interface HKTrainDetailTaskProgressModel : NSObject

@property (nonatomic, copy)NSString *taskDays;

@property (nonatomic, copy)NSString* content;

@property (nonatomic, copy)NSString* certificate;

@property (nonatomic, copy)NSString* completedDays;

@property(nonatomic,strong)ShareModel *shareData; // 分享


@end


@interface HKTrainDetailTodayCourseModel : NSObject

@property (nonatomic, copy)NSString *video_id;

@property (nonatomic, copy)NSString* teacher_id;

@property (nonatomic, copy)NSString* video_titel;

@property (nonatomic, copy)NSString* img_cover_url;

@property (nonatomic, copy)NSString* video_duration;

@property (nonatomic, copy)NSString* viedeo_difficulty;

@property (nonatomic, copy)NSString* video_url;

@property (nonatomic, copy)NSString* video_application;

@property (nonatomic, copy)NSString* clazz;

@property (nonatomic, copy)NSString* opened_at;

@property (nonatomic, copy)NSString* video_play;

@property (nonatomic, copy)NSString* img_cover_url_big;

@property (nonatomic, assign)BOOL canPlay;

@end








NS_ASSUME_NONNULL_END
