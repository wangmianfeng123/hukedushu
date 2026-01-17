//
//  RequestUrl.h
//  FamousWine
//
//  Created by pg on 15/11/6.
//  Copyright © 2015年 pg. All rights reserved.
//

#ifndef RequestUrl_h
#define RequestUrl_h

/**********************首页**********************/

#define Protocol         @"/user/read-protocol-popup"

#define read_Protocol         @"/user/read-protocol"

#define USERR_TOKEN         @"Authorization"

#define HOME_INDEX          @"/home/index"

#define USER_LOGIN          @"/user/login"

#define USER_REGISTER          @"/user/register"

#define USER_COLLECTION_VIDEO   @"/user/collection-video"

#define USER_ALREADY_STUDY      @"/user/already-study"

#define USER_INFO_Comment      @"/user/get-user-comment"

#define USER_INFO_FOLLOWS      @"/user/my-follow"

#define SYSTEM_VERSION         @"/version/version"


#define HOME_RECOMMENG_COURSE    @"/home/recommend-course"  // 首页推荐教程换一批接口

#define HOME_NEW_COURSE        @"/home/new-course" //首页翻页接口



/************* 学习兴趣 **************/
#define HOME_INTEREST       @"/home/interest"   //获取选择兴趣页的数据

#define HOME_ADD_INTEREST   @"/home/add-interest"   //添加用户选择的兴趣

#define HOME_GET_INTERESTIONS_VIDEO_LIST      @"/home/get-intention-video-list" //获取首次设置兴趣页推荐视频列表


/**********************统计**********************/
#define HOME_BANNER_CLICK       @"/stats/banner-click"  //统计banner点击次数

#define LOGIN_STATS             @"/stats/login-stats"  //APP当天登录人数

//#define VIDEO_PLAY_TIME         @"/stats/video-play-time"   //视频播放时长统计

#define STATS_DEVICE_STATS      @"/stats/device-stats"//新增设备数和活跃设备数统计

#define ADVERTISING_STATIC_AD_CLICKS     @"/advertising/static-ad-clicks" //广告位点击数统计



/**********************分类**********************/
#define CATEGORY_INDEX      @"/video/class-index"

#define CLASS_VIDEO_LIST   @"/video/class-video-list"

#define VIDEO_TAG_LIST      @"/video/get-tag-list" //获取列表页标签

#define VIDEO_STUDY_TOUTE   @"/video/study-route"  //软件入门(学习路径)列表页

#define VIDEO_SERIES_LESSON  @"/video/series-lesson"  //系列课列表页

#define VIDEO_SOFTWARE       @"/video/software" //软件入门新首页

#define VIDEO_USER_PLAN      @"/video/user-plan" //用户学习计划

#define VIDEO_SOFTWARE_HEADER_INFO   @"/video/software-header-info"  // 学习计划(增加vip介绍)

#define ONLINE_SCHOOL_KLASS_LIST_AND_FREE      @"/online-school/klass-list-and-free" //分类页 虎课网校tab

#define BOOK_LIST    @"book/list" //分类虎课读书列表


#define CARRER_CLASS_LIST    @"/career/class-list" // 职业路径(只有第一页返回广告位信息)

/**********************收藏视频**********************/
#define COLLECT_VIDEO      @"/video/collect-video"


/**********************关注/取消 教师*********************/
#define FOLLOW_TEACHER      @"/teacher/follow-teacher"



/**********************注册登录**********************/
#define SEND_MESSAGE          @"/user/send-message"

#define PHONE_MESSAGE_LOGIN     @"/user/phone-message-login"

#define USER_LOGOUT   @"/user/logout"//退出登录访问接口

#define USER_deleteAccount   @"/user/cancel-account"//退出登录访问接口

#define USER_CHECK_BINDED_PHONE     @"/user/check-binded-phone" //检查用户账号是否绑定手机






/**********************用户中心**********************/
#define USER_SUGGEST @"/user/suggest"  //意见反馈

#define USER_BIND_PHONE @"/user/bind-phone"   //绑定手机号码

#define GET_VIP_TYPE  @"/user/get-vip-type" //查询VIP 类型

#define USER_GET_PHONE   @"/user/get-phone" //客服电话

#define USER_UPDATE_USERNAME @"/setting/update-username" //修改用户名

#define USER_UPDATE_AVATOR   @"setting/update-avator" //修改头像

#define USER_DIPLOMA_LIST   @"/user/diploma-list" //获取学习成就证书列表

#define USER_GET_DIPLOMA   @"/user/get-diploma"    //获取证书详细信息

#define USER_HOME @"/user/home"//个人主页

#define VIP_MY_VIP  @"vip/my-vip" //我的VIP页

#define USER_GET_MY_INFO     @"/user/get-my-info"   //获取"我的"界面用户的相关信息（登不登陆都要请求）

#define SETTING_ACCOUNT_DATA    @"/setting/account-data"   //获取账号资料页数据

#define SETTING_JOB_DATA    @"/setting/job-data" //职业选择页

#define SETTING_JOB_DETAIL    @"/setting/job-detail"    //职业详情页

#define SETTING_ADD_JOB  @"/setting/add-job"//添加用户选择的职业

#define SETTING_BIND    @"/setting/bind"//绑定第三方账号

#define SETTING_REMOVE_BIND    @"/setting/remove-bind"   //解除第三方账号绑定

#define VIP_GET_PRIVILEGES     @"/vip/get-privileges"  // vip 特权列表


/********** 图片上传 签名 策略 **********/

#define SITE_UPYUN_SIGN     @"/site/upyun-sign"





/**********************视频详情**********************/
#define  GET_VIDEO_COMMENT      @"/video/get-video-comment"  //获取视频评论接口

#define  SUBMIT_COMMENT    @"/video/submit-comment"  //提交评论接口

#define  VIDEO_PRAISE    @"/video/like-comment"  //视频点赞

#define VIDEO_DETAIL      @"/video/video-detail"  //视频详情

#define TEACHER_HOME     @"/teacher/home"  //教师主页

#define VIDEO_PLAY    @"/video/video-play" //播放视频和下载接口

#define VIDEO_GET_DIPLOMA    @"/video/get-diploma"  //学完软件入门最后一节视频后获取毕业证书和推荐视频

#define VIDEO_GET_RECOMMEND_VIDEO   @"/video/get-recommend-video"   //视频播放完后获取推荐视频

#define VIDEO_SET_PLAY_VIDEO_TIME   @"/video/set-play-video-time" //记录视频播放时长 (视频播放进度)

#define VIDEO_DOWNLOAD    @"/video/download" //视频下载接口 V2.18



/**********************搜索**********************/
#define SEARCH_INDEX  @"/search/index"  //获取搜索结果

#define SEARCH_VIDEO @"/search/search-video" //搜索教程页

//#define SEARCH_TEACHER @"/search/search-teacher"//获取讲师页

#define SEARCH_HOT_WORDS @"/search/hot-words" //获取最热搜索词


#define SEARCH_COURSE     @"/search/course"       //搜索教程页

#define SEARCH_RECOMMEND     @"/search/recommend"       //搜索推荐

#define SEARCH_VIDEO_PULL     @"/search/video" /// 推荐下拉接口

#define SEARCH_SERIES     @"/search/series"     //搜索系列课页

#define SEARCH_PGC        @"/search/pgc"        //搜索名师机构页

#define SEARCH_ALBUM      @"/search/album"      //搜索专辑页

#define SEARCH_TEACHER    @"/search/teacher"    //获取讲师页

#define SEARCH_SOFTWARE   @"/search/software"   //软件入门搜索

#define SEARCH_ARTICLE    @"/search/article" // 搜索文章

#define SEARCH_readBook    @"/search/book" // 搜索文章

#define SEARCH_Live    @"/live/search" // 搜索直播


#define SEARCH_RECOMMEND_WORD_TEST      @"https://search1.huke88.com/search/recommend-word" // 搜索联想词 测试服务

#define SEARCH_RECOMMEND_WORD    @"https://search.huke88.com/search/recommend-word" // 搜索联想词


/**********************专辑**********************/

#define ALBUM_INDEX @"/album/index"   // @"合集列表页"

#define ALBUM_DETAIL  @"/album/detail"  //合集详情页

#define ALBUM_CREATE   @"/album/create"//创建专辑

#define ALBUM_COLLECT_ALBUM  @"/album/collect-album" //收藏/取消收藏专辑

#define ALBUM_MY_ALBUM      @"/album/my-album"//获取用户创建的专辑和收藏的专辑

#define ALBUM_COLLECT_VIDEO  @"/album/collect-video"//收藏视频到专辑

#define ALBUM_EDIT   @"/album/edit" //编辑合集页  (编辑合集时获取合集信息接口)

#define ALBUM_UPDATE @"/album/update" //编辑完成后提交接口

#define ALBUM_DELETE_ALBUM  @"/album/delete-album" //删除专辑

#define ALBUM_DELETE_ALBUM_VIDEO    @"/album/delete-album-video" //从专辑中删除视频


/********************** 优惠券 **********************/

#define USER_COUPONS    @"/user/coupons"//优惠券列表






/**********************VIP 支付 **********************/
#define APPLE_IN_PURCHSASE      @"pay/verify-receipt"   //订单验证接口

#define BULID_ORDER_NO      @"/pay/ios-pay"   //订单生成接口

#define PAY_ALI_PAY  @"/pay/ali-pay"    //支付宝生成订单接口

#define PAY_WX_PAY  @"/pay/wx-pay"     //微信支付生成订单接口

#define PAY_ORDER_QUERY   @"/pay/order-query"    //查询订单是否支付完成接口


/**********************评论 **********************/
#define VIDEO_COMMENT_REPLAY   @"/video/comment-reply" //回复评论接口

#define GET_SIGLE_COMENT_REPLY  @"/video/get-comment-reply" ///获取单条评论和当前评论的回复内容接口

#define VIDEO_DELETE_COMMENT   @"/video/del-comment" //删除我的评论


/********************** 升级接口 **********************/
#define SITE_VERSION    @"/site/version"   // 1--普通更新  2--强制更新



/********************** Pgc-名师机构相关接口 **********************/

#define PGC_LIST    @"/pgc/list"    //名师机构课程列表页

#define PGC_DETAIL  @"/pgc/detail"  //名师机构课程详情页

#define JOBPATH_DETAIL  @"/career-video/detail"  // 职业路径课程详情页

#define PGC_PLAY    @"/pgc/play"    //视频播放和下载请求地址

#define PGC_COLLECT @"/pgc/collect" //收藏或取消收藏视频

#define PGC_BUY     @"/pgc/buy"     //购买教程页

#define PGC_MY_ORDER    @"/pgc/my-order"    //获取用户订单


/**********************  分享 **********************/
//(2.1 废弃)
#define VIDEO_SHARE_SUCCESS  @"/video/share-success" //分享视频成功后访问接口

#define VIDEO_SHARE_CALLBACK    @"/stats/share-callback"    //分享成功后访问接口

/**********************  极光推送 **********************/

#define JPUSH_BIND   @"/jpush/bind"  //registration_id和uid绑定接口

#define JPUSH_CLICK_STATS    @"/jpush/click-stats" //推送消息点击统计


/**********************  音频  **********************/
#define AUDIO_INDEX     @"/audio/index" //音频列表页

#define AUDIO_DETAIL    @"/audio/detail" //音频播放页

#define AUDIO_PLAY      @"/audio/play" //播放音频


#define AUDIO_PLAY_TIME_STATS @"/audio/play-time-stats"     //记录音频播放时长



/**********************  我的学习  **********************/

#define USER_MY_STUDY   @"/user/my-study" //我的学习

#define USER_USER_TASK   @"/user/user-task"//个人主页作品列表

#define USRR_DELETE_STUDY_RECORD     @"/user/delete-study-record"   //删除已学教程记录

#define USER_Follow_teacherData     @"/user/my-follow-teacher-data"   //学习模块我的关注



/**********************  作品  **********************/
#define TASK_INDEX   @"/task/index"//作品交流列表页

#define TASK_DETAIl  @"/task/detail"//作品详情页接口

#define TASK_CREATE_COMMENT  @"/task/create-comment"//作品评论接口

#define TASK_LIKE_TASK   @"/task/like-task"//作品点赞和取消点赞接口

#define TASK_DEl_COMMENT   @"/task/del-comment"//作品评论删除接口



/**********************  文章  **********************/
#define ARTICLE_INDEX    @"/article/index" //文章首页（列表）

#define ARTICLE_MY_COLLECT  @"/article/my-collect"// 我收藏的文章（列表）

#define ARTICLE_HL_COLLECT  @"/article/hl-collect"// 收藏或取消收藏操作

#define ARTICLE_HL_LIKE  @"/article/hl-like" //点赞或取消点赞操作

#define ARTICLE_DETAIL_INFO  @"/article/detail-info"// 文章详情页信息

#define ARTICLE_ADD_COMMENT  @"/article/add-comment"// 添加文章评论

#define ARTICLE_TEACHER_ARTICLE_LIST     @"/article/teacher-article-list" //讲师主页（列表）

#define ARTICLE_DELETE_COMMENT    @"/article/delete-comment" //删除评论



/********************** 新手礼包  **********************/

//#define GIft_CAN_SHOW   @"/gift/can-show" //活动弹窗是否显示

//#define GIft_GET_DAY_INFO   @"/gift/get-day-info"// 获取礼包信息

//#define GIft_GET    @"/gift/get" //领取礼包



/********************** 弹框信息  **********************/

#define POP_GET_POP     @"/pop/get-pop" //获取弹出信息




/********************** 广告  **********************/

#define POP_GET_POP_PIC_AD      @"/pop/get-pop-pic-ad"      //获得悬浮广告信息

#define ADVERTISING_INIT_ADS     @"/advertising/init-ads"   //获取开屏广告


/********************** 直播 IM  **********************/

#define LIVE_GET_LIVE_TEACHER_INFO   @"/live/get-live-teacher-info"    // 获得直播讲师信息等

#define LIVE_LIST    @"/live/list"// 直播列表

#define LIVE_DETAIL  @"/live/detail" //直播详情  

#define LIVE_ENROLL_OR_UN_ENROLL @"/live/enroll-or-un-enroll" //免费直播的报名或取消报名

#define LIVE_LIST_OF_TEACHER     @"/live/list-of-teacher"  /// 讲师直播列表

// v 2.21.0
#define LIVE_GET_LIVE_URL   @"live/get-live-url" //获取保利威直播&聊天室参数


#define LIVE_GET_LIVE_DATA   @"/live/get-live-data" //获取直播页数据


/********************** 聊天室  **********************/
#define SITE_ANTISPAM    @"/site/antispam" //反垃圾


/********************** IM 群聊  **********************/

#define IM_RECOMMEND_LIST   @"/im/recommend-list"   // 推荐群组列表

#define IM_GET_USER_GROUPS   @"/im/get-user-groups" //获得用户的所在的所有组

#define IM_JOIN_OR_QUIT     @"/im/join-or-quit" //加入或退出群组

#define IM_GET_USER_TOKEN    @"/im/get-user-token" //获得用户im token

#define IM_SILENCE   @"/im/silence" //消息免打扰

#define IM_KICK_OUT  @"/im/kick-out" //将某人踢出群组

#define IM_SAVE_NOTICE   @"/im/save-notice" //编辑公告

#define IM_GET_GROUP_NOTICE  @"/im/get-group-notice" //获取公告

#define IM_FORBID_TALK   @"/im/forbid-talk" //禁言某人

#define IM_GET_MEMBERS  @"/im/get-members" //获得某个组中的所有用户

#define IM_GET_ADMINS    @"/im/get-admins" //获取管理员和群组uid



/********************** 勋章  **********************/

#define ACHIEVEMENT_GET_COMPLETED_ACHIEVE      @"/achievement/get-completed-achieve"



/********************** 短视频  **********************/

#define SHORT_VIDEO_LIKE     @"/short-video/like" //短视频点赞

#define SHORT_VIDEO_INDEX    @"/short-video/index" //短视频首页

#define SHORT_VIDEO_STATUS   @"/short-video/short-video-status" //APP 底部 tab 是否展示短视频

#define SHORT_VIDEO_PLAY_VIDEO    @"/short-video/play-video" //单个短视频播放

#define SHORT_VIDEO_PLAY_VIDEO_UP    @"/short-video/play-video-up"  //上报短视频播放记录

#define SHORT_VIDEO_TAG_INDEX       @"short-video/tag-index" // 分类 短视频



/********************** 教师主页 短视频  **********************/

#define TEACHER_SHORT_COURSE  @"/teacher/short-course"  ///短视频

#define TEACHER_ARTICLE_COURSE   @"/teacher/article-course"  //文章课程

#define TEACHER_OGC_COURSE   @"/teacher/ogc-course" //OGC会员视频


#define SHORT_VIDEO_LIKES  @"/short-video/likes"  ///短视频




/********************** 职业路径  **********************/

#define  CAREER_LIST     @"/career/list"    //职业路径列表

#define  CAREER_DETAIL      @"/career/detail"   //职业路径详情

#define CAREER_VIDEO_PLAY    @"/career-video/play" //职业路径 下载和观看


/********************** 虎课读书  **********************/

#define  BOOK_PLAY     @"/book/play"    //读书播放权限

#define  BOOK_GET_CATALOG_LIST   @"/book/get-catalog-list" //目录列表

#define  BOOK_DETAIL      @"/book/detail" //读书详情

#define  BOOK_RECOED_PLAY_TIME   @"/book/record-play-time"  //课程播放时长记录

#define  BOOK_COLLECTED_LIST      @"/book/collected-list"   //收藏列表

#define  BOOK_STUDIED_LIST      @"/book/studied-list"       //已学列表

#define  BOOK_COLLECTED_SWITCHER    @"/book/collector-switcher" //收藏读书

#define  BOOK_COMMENT_FETCH     @"/book-comment/fetch" // 图书评论列表

#define  BOOK_COMMENT_CREATE    @"/book-comment/create" //新增评论

#define  BOOK_COMMENT_DELETE    @"/book-comment/delete" //删除评论

#define  BOOK_GET_BANNER    @"/book/get-banner" //每日读书+banner+读书分类

#define  BOOK_BOOK_LIST_BY_TAG  @"/book/book-list-by-tag" //虎课读书


/********************** 极验一键登录  **********************/

#define USER_PHONE_ONE_LOGIN     @"/user/phone-one-login" //极验一键登录

#define USER_GET_REGISTER_GIFT   @"/user/get-register-gift"  /// 获取注册礼包


/********************** 订单 **********************/

#define LIVE_ORDER_LIST  @"/live/order-list" //直播订单列表



/********************** 消息 **********************/

#define NOTICE_BOOK_REPLY_LIST   @"/notice/book-reply-list" //图书回复列表

#define NOTICE_MARK_BOOK_REPLAY_AS_READ     @"/notice/mark-book-reply-as-read"  //图书消息 标记已读




/********************** 初始化配置 **********************/

#define INIT_CONFIGURE  @"/init/configure" //初始化配置


/********************** 推广渠道 **********************/

#define IOS_CHANNEL_GET_CHANNEL  @"/ios-channel/get-channel"     /// 获取渠道



/********************** 协议 **********************/
#define SITE_AGREEMENT   @"/site/agreement"  /// 注册协议

#define SITE_PRIVACY_AGREEMENT   @"/site/privacy-agreement" // 隐私协议

#define SITE_VIP_AGREEMENT   @"/site/vip-agreement" // vip协议

#define SITE_AutoBuy_AGREEMENT   @"/site/auto-renewal-vip-agreement" // 自动续费协议



/********************** 职业路径下载 **********************/

#define CAREER_VIDEO_FETCH_DOWNLOAD_ROUTE     @"/career-video/fetch-download-route"



#define VIDEO_SERIES_BATCH_DOWNLOAD      @"/video/series-batch-download"


/********************** 游客购买生成订单 **********************/

#define PAY_IOS_REVIEW_ORDER_RECORD  @"/pay/ios-review-order-record"



/********************** 浏览器 映射跳转 **********************/

#define CLIENT_REDIRECT_REDIRECT_INFO   @"/client-redirect/redirect-info"


/********************** 动态配置tab **********************/

#define TabBar_Middle_icon  @"/init/home-bottom-middle-icon"



/*********************SERVICE_ERROR*********************/

//#define SERVICE_ERROR_LOGIN               @"登录失败"

#define SERVICE_ERROR_UPLOAD              @"上传失败"

#define SERVICE_ERROR_MODIFY_NICKNAME     @"修改失败"



/*********************SERVICE_SUCESS*********************/
#define SERVICE_SUCESS_LOGIN              @"登录成功"

#define SERVICE_SUCESS_RESET_PWD          @"修改成功"


/*********************训练营*********************/
#define HK_TrainingDatail_URL   @"/training-task/my-training-detail"//训练营日历页
#define HK_TrainingWorkList_URL   @"/training-task/training-works-list" //训练营打卡列表
#define HK_TrainingWorkLike_URL   @"/training-task/update-like" //我的训练营作品点赞
#define HK_TrainingDeleWork_URL   @"/training-task/del-task" //删除用户作业
#define HK_TrainingTaskList_URL   @"/training-task/training-task-list" //我的训练营任务列表接口


#define HK_TrainingTaskSignalKey_URL   @"/training-task/get-signal-key" //获取upaiyun上传图片key
#define HK_LiveCommentSignalKey_URL   @"/live/get-upload-key" //获取upaiyun上传图片key


#define HK_TrainingTaskSubmitTask_URL   @"/training-task/ajax-submit-task" //训练营任务上传作业

//分类模块
#define HK_CategoryLeftMenu_URL   @"/app-class-list/get-left-list" //分类页左边菜单
#define HK_CategoryRightTypeMenu_URL  @"/video/class-list" //分类页右边类型

#endif /* RequestUrl_h */




