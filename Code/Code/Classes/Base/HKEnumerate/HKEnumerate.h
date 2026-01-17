//
//  HKEnumerate.h
//  Code
//
//  Created by Ivan li on 2017/12/12.
//  Copyright © 2017年 pg. All rights reserved.
//

#ifndef HKEnumerate_h
#define HKEnumerate_h

// vip_type 类型
typedef NS_ENUM(NSInteger, HKVipType) {
    //5-分类限五vip 4-套餐vip  3-终身全站通  2-全站通VIP  1-分类无限VIP  0-非VIP
    HKVipType_Expire = -1, // VIP 过期
    HKVipType_No = 0,
    HKVipType_Separator = 1,
    HKVipType_OneYear = 2,
    HKVipType_WholeLife = 3,
    HKVipType_Group = 4,
    HKVipType_Separator5Days = 5,
};


// ​/**
// * 转换视频类型
// * @param int $videoId
// * @return array [视频类型, 视频相关信息]
// *  0-普通视频
// *  1-软件入门视频
// *  2-系列课视频 @NOTE: deprecated 所有系列课和上下集课已经合并到 VideoSplit表
// *  3-有上下集的视频
// *  4-PGC视频 @NOTE: deprecated PGC入口已关闭, 不在显示PGC
// *  5-练习题视频
// *  6-职业路径
// *  7-职业路径练习题
// */
// 视频 类型
typedef NS_ENUM(NSInteger, HKVideoType) {
    //video_type：0-普通视频 1-软件入门 2-系列课视频 3-有上下集的视频 4-PGC 5-软件入门的练习题 6-职业路径练习题 7-本地下载的直播课回看视频标记为999
    HKVideoType_Ordinary = 0,
    HKVideoType_LearnPath,
    HKVideoType_Series,
    HKVideoType_UpDownCourse,
    HKVideoType_PGC,
    HKVideoType_Practice,// 软件入门的练习题
    HKVideoType_JobPath,// 职业路径
    HKVideoType_JobPath_Practice,// 职业路径练习题
};



// VIP 类型
typedef NS_ENUM(NSUInteger, UserVipType) {
    //is_vip：0-非VIP（不可下载） 1-限5VIP（不可下载） 2-全站VIP或分类无限VIP（可下载），is_paly：0-不可观看 1-可观看
    UserVipType_Ordinary = 0,
    UserVipType_Limit_Five,
    UserVipType_All_Station,
};




/** 上次登录 平台类型 */
typedef NS_ENUM(NSInteger, HKLoginType) {
    //登录方式 [1:QQ,2:微信,3:微博 4:手机 ]
    HKLoginType_QQ = 1,
    HKLoginType_Wechat,
    HKLoginType_Weibo,
    HKLoginType_Phone,
};



typedef NS_ENUM(NSUInteger, GKWYPlayerPlayStyle) {
    GKWYPlayerPlayStyleLoop,        // 循环播放
    GKWYPlayerPlayStyleOne,         // 单曲播放
    GKWYPlayerPlayStyleRandom       // 随机播放
};



/** 搜索类型 */
typedef NS_ENUM(NSInteger, SearchResult) {
    //搜索类型
    SearchResultTeacher =0,//教师
    SearchResultCourese,//课程 ， 推荐
    SearchResultSerise,//系列课
    
    SearchResultTeacherOrganiza,//名师机构
    SearchResultAlbum,//专辑
    SearchResultSoftware,//软件
    SearchResultArticle,//文章
    SearchResultReadBook,//读书
    SearchResultLiveCourse,//直播课
};


/** 手势方向 */
typedef enum : NSUInteger {
    HKTranslation_none = 0,
    HKTranslation_up,
    HKTranslation_down,
    HKTranslation_left,
    HKTranslation_right
} HKTranslation;


/** 分类 类别 */
typedef NS_ENUM(NSUInteger, HKCategoryType) {
    HKCategoryType_software = 0, // 软件入门
    HKCategoryType_designCourse,  // 设计课程
    HKCategoryType_develop, // 职业发展
    HKCategoryType_readBooks,    // 虎课读书
    HKCategoryType_student,    // 学生专区
    HKCategoryType_school,    // 虎课网校
    HKCategoryType_jobPath    // 职业路径
};


/** 绑定手机号 类型 */
typedef NS_ENUM(NSInteger, HKBindPhoneType) {
    // 0 - 普通绑定。 1- 登录受限绑定  2-强制绑定 3-引导vip用户绑定 4-购买vip成功用户绑定
    HKBindPhoneType_Ordinary=0,
    HKBindPhoneType_Limit = 1,
    HKBindPhoneType_ForceBind = 2,
    HKBindPhoneType_VipUserBind =3,
    HKBindPhoneType_VipBuySucess_UserBind =4,
};


/** 水波动画*/
typedef NS_ENUM(NSInteger, waveType) {
    waveTypeCosf = 0,
    waveTypeSinf = 1,
};


typedef NS_ENUM(NSInteger, HKLoginViewType) {
    HKLoginViewType_ordinary = 0,
    HKLoginViewType_Firstload = 1, //首次下载 登录
    HKLoginViewType_OneLoginSDK = 2, // 极限登录
};



// 当前直播状态0:未开始，1:开始直播,2:直播结束
typedef enum {
    HKLiveStatusNotStart = 0,
    HKLiveStatusLiving = 1,
    HKLiveStatusEnd = 2,
}HKLiveStatus;




typedef NS_ENUM(NSUInteger, HKLiveType) {
    
    HKLiveTypeNone = 0,
    HKLiveTypeEnrolment = 1,// 火热报名
    HKLiveTypeWaiting, // 即将开始
    HKLiveTypePlaying, // 直播中
    HKLiveTypePlayEnd // 结束
};
// 直播列表 状态



/** 菜单类型 */
typedef NS_ENUM (NSUInteger,HKDropMenuFilterCellType ) {
    /** 标签 */
    HKDropMenuFilterCellTypeTag = 1,
    /** 输入 */
    //HKDropMenuFilterCellTypeInput,
    /** 输入 */
    //HKDropMenuFilterCellTypeSingleInput,
};


/** 菜单类型 */
typedef NS_ENUM (NSUInteger,HKDropMenuType ) {
    /** 标题 */
    HKDropMenuTypeTitle = 1,
    /** 筛选菜单 */
    HKDropMenuTypeFilter,
    /** 禁止点击标题 */
    HKDropMenuTypeEnableTitle,
    /** 筛选按钮 */
    HKDropMenuTypeFilterBtn,
};


/** 筛选菜单类型 */
typedef NS_ENUM (NSUInteger,HKDropMenuFilterCellClickType ) {
    /** tag 不能取消  */
    HKDropMenuFilterCellClickTypeEnableQuit = 1,
    /** tag 可以取消选中  */
    HKDropMenuFilterCellClickTypeQuit,
};



/** 虎课读书定时类型 */
typedef NS_ENUM (NSUInteger,HKBookTimerType) {
    /** 不开启定时  */
    HKBookTimerType_none = 0,
//    /** 播放完关闭  */
//    HKBookTimerType_endClose = 1,
    /** 10 分钟关闭  */
    HKBookTimerType_10MIN = 2,
    /** 15 分钟关闭  */
    HKBookTimerType_15MIN = 3,
    /** 20 分钟关闭  */
    HKBookTimerType_20MIN = 4,
    /** 30 分钟关闭  */
    HKBookTimerType_30MIN = 5,
    /** 45 分钟关闭  */
    HKBookTimerType_45MIN = 6,
    /** 60 分钟关闭  */
    HKBookTimerType_60MIN = 7,
};




/** 短视频 入口类型 */
typedef NS_ENUM (NSUInteger,HKShortVideoType) {
    
    /** tab 短视频 */
    HKShortVideoType_main_tab = 0,
    /** 分类 短视频 */
    HKShortVideoType_category = 1,
    /** 单个短视频 */
    HKShortVideoType_sigle_video = 2,
    /** 通知消息 短视频 */
    HKShortVideoType_notification = 3,
    /** 讲师主页 短视频 */
    HKShortVideoType_teacher = 4,
    /** 我点赞 短视频 */
    HKShortVideoType_my_praise = 5,
};




// 评论 类型
typedef NS_ENUM(NSInteger, HKCommentType) {
    // 视频评论
    HKCommentType_VideoComment = 0,
    // 读书评论
    HKCommentType_BookComment = 1,
};

typedef NS_ENUM(NSUInteger, LBVideoCastState) { //视频投屏状态
    /** 未点击投屏，未连接 */
    LBVideoCastStateUnCastUnConnect,
    /** 已点击投屏，已连接*/
    LBVideoCastStateCastedConnected,
    /** 无网络 已连接*/
    LBVideoCastStateUnNetworkUnCastConnected,
};



typedef NS_ENUM(NSInteger, HKLoginViewThemeType) {
    HKLoginViewThemeType_phone = 0, //手机页面
    HKLoginViewThemeType_study = 1,// 学习页面
};


#endif /* HKEnumerate_h */




