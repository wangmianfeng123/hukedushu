//
//  HKBookModel.h2
//  Code
//
//  Created by hanchuangkeji on 2019/7/16.
//  Copyright © 2019 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HKCerRedirectModel,HKCerRedirectListModel;
//can_play为1  完整播放  为0  如果free_time>0 监听播放时长  大于free_time停止播放

@interface HKBookModel : NSObject

@property (nonatomic, copy)NSString *book_id;
/** 课程ID */
@property (nonatomic, copy)NSString *course_id;

@property (nonatomic, copy)NSString *title;

@property (nonatomic, copy)NSString *cover;

@property (nonatomic, copy)NSString *cover_pic;

@property (nonatomic, copy)NSString *author;

@property (nonatomic, assign)NSInteger course_num;

@property (nonatomic, assign)BOOL is_recommend;

@property (nonatomic, copy)NSString *listen_number;

@property (nonatomic, assign)BOOL is_free;

@property (nonatomic, copy)NSString *time;

@property (nonatomic, copy) NSString * sort;

#pragma mark - 用于全选 删除 视频
@property (nonatomic, assign) BOOL isCellSelected;

/** 读书目录页  课程ID */
@property(nonatomic,copy)NSString *book_course_id;
/** YES - 已学 */
@property(nonatomic,assign)BOOL is_study;
/** YES - 正在播放 */
@property(nonatomic,assign)BOOL is_playing;

@property(nonatomic,copy)NSString *course_title;

@property(nonatomic,copy)NSString *last_updated_at;

@property(nonatomic,copy)NSString *book_title;

@property(nonatomic,copy)NSString *introduce;

@property (nonatomic, assign)BOOL is_selected;
/** 定时开关类型 */
@property(nonatomic,assign)HKBookTimerType timerType;
/// 下一节
//@property(nonatomic,copy)NSString *next_course_id;
///上次播放进度
@property(nonatomic,assign)NSInteger last_play_second;

@property(nonatomic,copy)NSString *vip_type;

@property(nonatomic,copy)NSString *short_introduce;
/// YES - 已收藏
@property (nonatomic, assign)BOOL is_collected;
/// 评论数量
@property(nonatomic,assign)NSInteger comment_number;
/// 收藏数量
@property(nonatomic,assign)NSInteger collect_number;

@property (nonatomic,strong) HKMapModel *redirect_package;
/// 播放的进度
@property(nonatomic,copy)NSString *rate;

@property (nonatomic,strong) HKMapModel *book_goods;

@end




@interface HKBookPlayInfoModel : NSObject

@property(nonatomic,copy)NSString *introduce;
///是否可以完整播放  YES- 可以
@property(nonatomic,assign)BOOL can_play;
///是否免费课程
@property(nonatomic,assign)BOOL is_free;
///试听时长
@property(nonatomic,assign)NSInteger free_time;

@property(nonatomic,copy)NSString *vip_type;

@property(nonatomic,copy)NSString *play_url_qn;
///上次播放进度
@property(nonatomic,assign)NSInteger last_degree;

@property(nonatomic, copy)NSString *cover_url;
@property(nonatomic, copy)NSString *course_id;
@end



@interface HKTagModel : NSObject

@property(nonatomic,copy)NSString *tagId;

@property(nonatomic, copy)NSString *tag;

@property(nonatomic, copy)NSString *name;

@property(nonatomic, assign)BOOL isSelect;

@end



@interface HKLastBookModel : NSObject

@property(nonatomic, copy)NSString *book_id;

@property(nonatomic, copy)NSString *course_id;

@end




@interface HKRelateBookModel : NSObject

@property (nonatomic,strong) HKLastBookModel *last_book;

@property (nonatomic,strong) HKLastBookModel *next_book;
/// 是否播放“免费学习即将结束”语音 1：播放 0：不播放
@property (nonatomic,assign) BOOL is_play_voice;

@end

@interface HKUserFetchCerModel : NSObject

@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *username;
@property(nonatomic, copy)NSString *route_id;
@property(nonatomic, strong) HKCerRedirectModel *redirect;
@end

@interface HKCerRedirectModel : NSObject

@property(nonatomic, copy)NSString *class_name;
@property(nonatomic, strong)NSMutableArray<HKCerRedirectListModel *>* list;
@end

@interface HKCerRedirectListModel : NSObject
@property(nonatomic, copy)NSString *parameter_name;
@property(nonatomic, copy)NSString *value;
@end



NS_ASSUME_NONNULL_END


