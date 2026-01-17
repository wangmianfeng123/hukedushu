//
//  HukeDefine.h
//  Code
//
//  Created by Ivan li on 2017/7/22.
//  Copyright © 2017年 pg. All rights reserved.
//






#ifndef HukeDefine_h
#define HukeDefine_h


//------------- COLOR ------------------//

//#define NAVBAR_Color [UIColor whiteColor]

#define NAVBAR_Color  [UIColor hkdm_colorWithColorLight:COLOR_ffffff dark:COLOR_3D4752]

#define HK_NAVBAR_Color_2_6 HKColorFromHex(0xffdc21, 1.0)

#define APP_STATUS  @"APP_STATUS" //1审核 2正式


#define APPSTATUS [[CommonFunction getAPPStatus]isEqualToString:@"1"]  //审核状态

#define TOURIST_VIP_STATUS  [[CommonFunction getTouristVIPStatus] isEqualToString:@"2"]

#define  HK_Placeholder @"empty_img"// @"HK_PlaceImage"

#define  HK_PlaceholderImage  [UIImage imageNamed:HK_Placeholder]




#define  Use_Mobile_Traffic  @"当前网络无Wifi,继续下载将使用移动流量"

#define  Use_Mobile_Traffic_Look  @"当前网络无Wifi,继续观看将使用移动流量"

#define  Memory_Insufficient @"系统空间不足,请卸载应用,清除缓存或不必要的文件"

#define  DownLoading_Tip     @"已加入在下载队列"

#define  In_DownLoad_Queue   @"已存在于下载队列中"





//--------------  友盟 ---------------//
#define  UM_HUKE_APPKEY     @"59793d851c5dd02876000bcb"
//QQ
#define  HUKE_QQAPPID       @"101417168"
#define  HUKE_QQAPPKEY      @"9d1a468d77398361777ef828130ff88c"

//微信
#define  HUKE_WXAPPID       @"wxd38fe319a886f3f4"
#define  HUKE_WXAPPSecret   @"0485f4a7b0f345988245c4b36ee9e69f"

#define  HUKE_JS_URL        @"huke://www.huke88.com"//huke://www.huke88.com

//新浪微博
#define  HUKE_SINAAPPID     @"4002607241"
#define  HUKE_SINAAPPSecret @"3bcfa73f54b914dc0e79688fdaec0ee3"

//极光
#define JG_PUSH_APPKEY       @"6e95706e14c63a088e0b0a60"//6e95706e14c63a088e0b0a60
#define JG_PUSH_SECRET       @"3d386b130498bba3a8069902"

//apple 推送 相关设置
#define APPLE_KEYS           @"6B2KELHRG4"
#define APPLE_TEAM_ID        @"JJMF498F33"


/****************  Universal Links ********************/
#define hk_universalLink    @"https://js.huke88.com/"


//-----------  马化腾 bugly 统计 -----------//
#define BUGLY_APP_ID   @"49083977d3"

#define BUGLY_APP_KEY  @"fdf6033c-2717-4f61-a180-bbaf08d0db3c"


//-----------  丁三石  网易IM -----------//
#define IM_APPKEY_163   @"8812ddeeeb5368a66ef8c454a6c3b612"

#define TEST_IM_APPKEY_163   @"8e3bf06427276e26582df48249967d35"  //@"dfeb4cab648fa42a24bc13967e0553e4"

//'im_appkey'  @> '8e3bf06427276e26582df48249967d35',
//'im_appsecret'  @> 'd32da01e532d',

//AppSecret b0e7453b913a


//-----------  极验登陆 -----------//
#define ONE_LOGIN_APPID   @"8c01b4f5aaf233f37e63891bfa0c43b1"

#define ONE_LOGIN_KEY     @"fb1044ff88db7ddb9b000e025bd5c34b"

#define ONE_LOGIN_MSG     @"请同意服务条款"


//-----------  保利威播放器 -----------//
#define HUKE_PLV_APPID   @"fl8qwk4cfd"

#define HUKE_PLV_APP_SECRET   @"0fb7db3cff30493ba8f9a14d18791a37"




//--------------  MJ 刷新 ---------------//
#define  FOOTER_NO_MORE_DATA    @"已无更多数据"

#define  NETWORK_NOT_POWER      @"网络不给力"

#define  NETWORK_NOT_POWER_TRY  @"网络不给力,稍后再试"


//--------------  空试图 ---------------//
#define  EMPETY_NO_STUDY         @"您暂无已学视频"

#define  EMPETY_NO_DOWNLOAD      @"您暂无下载视频"

#define  EMPETY_NO_COLLECTION    @"您还没有收藏任何内容哦~"

#define  EMPETY_DATA_IMAGE       @"empty_img1"

#define  EMPETY_NOTHING    @"空空如也!"

#define   NETWORK_ALREADY_LOST_IMAGE @"network_lose"

#define  EMPETY_LOAD_DATA       @"重新加载"

#define  HOME_PAGE_NO_DATA    @"暂无内容"

#define  LOAD_FAIL      @"加载失败,请重新刷新"


//--------------  提示文案 ---------------//
#define GO_TO_PC_BUY_PGC @"请至网站购买课程哦～"


//--------------  数据库 ---------------//
#define DownloadCacherTable @"downloadCacherTable"


//--------------  网络状态 ---------------//
#define NETWORK_LOST @"网络不给力"

#define Mobile_Network @"正在使用移动流量"

#define NETWORK_ALREADY_LOST    @"网络连接断开"


//-------------- 登录 ---------------//
#define TIME_OUT_LOGIN    @"当前账号需要重新验证,请重新登录"

#define LOGIN_FAILED    @"登录失败"

//-------------- 搜索 ---------------//
#define SEARCH_TIP  @"搜索课程和关键词"   //@"学设计上虎课网，每天进步一点点"


#define SEARCH_TIP_CATEGORY @"搜索课程和关键词" //@"每天免费学习1个教程"   

//-------------- 上一次登录 平台 ---------------//
#define HK_LOGIN_TYPE    @"HK_LOGIN_TYPE"


//-------------- 沙盒缓存目录 ---------------//

/** app store 路径 */
#define APP_STORE_URL @"http://itunes.apple.com/app/id1273126065"

#define kLibraryCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]


#define HKDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]


#ifdef DEBUG        // 调试状态, 打开LOG功能
#define SXPNSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else               // 发布状态, 关闭LOG功能
#define SXPNSLog(...)
#endif

#ifdef DEBUG        // 调试状态, 打开LOG功能
#define HKIsDebug YES
#else               // 发布状态, 关闭LOG功能
#define HKIsDebug NO
#endif






//#define  BunldId            @"com.cainiu.Huke"

//--------------  友盟统计 ---------------//

/*
tab_home  @ "C0201001"  //底部首页tab
tab_playlist  @ "C0301001"  //底部已学教程tab
tab_collect  @ "C0401001"  //底部收藏教程tab
down_back @ "C0501001"  //下载页-返回(IOS)
list_down @ "C0601001"  //下载按钮
list_play @ "C0601002"  //播放点击跳转
*/



#define  UM_RECORD_LOGIN_WECHAT    @"C0101002"

#define  UM_RECORD_LOGIN_QQ    @"C0101001"

#define  UM_RECORD_HOME_DOWNLOAD_BUTTON   @"C0202001"

#define  UM_RECORD_DOWNLOAD_BUTTON    @"C0601001"

#define  UM_RECORD_PLAYER    @"C0601002"

#define  UM_RECORD_TAB_HOME    @"C0201001" //底部首页tab

//#define  UM_RECORD_STUDY    @"C0301001"

//#define  UM_RECORD_COLLECTION  @"C0401001"

#define  UM_RECORD_DOWNLOAD_PAGE_BACK  @"C0501001"


//1.1
#define  UM_RECORD_DETAIL_PAGE_PLAY  @"C0701001"

#define  UM_RECORD_DETAIL_PAGE_DOWN  @"C0702001"//视频详情页-下载按钮

#define  UM_RECORD_DETAIL_PAGE_COLLECT  @"C0702002" //视频详情页-收藏按钮


#define  UM_RECORD_TAB_CATEGORY_PAGE  @"C0801001" //底部分类tab

#define  UM_RECORD_TAB_CATEGORY_ZITI  @"C0802001"

#define  UM_RECORD_TAB_CATEGORY_HAIBAO  @"C0802002"

#define  UM_RECORD_TAB_CATEGORY_RUANJIAN  @"C0802003"


#define  UM_RECORD_TAB_CATEGORY_ZONGHE  @"C0802004"

#define  UM_RECORD_TAB_CATEGORY_C4D  @"C0802005"

#define  UM_RECORD_TAB_CATEGORY_PERSON_CENTER  @"C0901001" // 底部tab 我的


#define  UM_RECORD_PERSON_DOWNLOADED  @"C0902001" //我的-已下载

#define  UM_RECORD__PERSON_PLAYLIST  @"C0902002" //我的-已学

#define  UM_RECORD__PERSON_QUIT  @"C0903001" //我的-退出



//0920
#define  UM_RECORD_LOGIN_PHONE  @"C0102001" //登录页-手机号注册/登录

#define  UM_RECORD_HOME_SEARCH @"C0203001"  //首页-搜索

#define  UM_RECORD_CATEGORY_SEARCH @"C0803001"  //分类页-搜索

#define  UM_RECORD_MYINFO_VIP @"C0904001"   //个人中心-全站通VIP

#define  UM_RECORD_MYINFO_SUGGEST @"C0905001" //个人中心-意见反馈

#define  UM_RECORD_VEDIO_PLAYBOTTOM @"C0701002" //视频详情页-播放时的受限文案

#define  UM_RECORD_VEDIO_DWONLIMIT_BUY @"C0702003"//视频详情页-下载受限弹框-购买



//1016

#define  UM_RECORD_LOGIN_WECHAT @"C0101002"//登录页-微信一键登录

#define  UM_RECORD_HOME_BANNER_1 @"C0204001"//首页-banner-1

#define  UM_RECORD_HOME_BANNER_2 @"C0204002"//首页-banner-2

#define  UM_RECORD_HOME_BANNER_3 @"C0204003"//首页-banner-3

#define  UM_RECORD_HOME_CATEGORY_ZITI @"C0205001"//首页-分类图标-1

#define  UM_RECORD_HOME_CATEGORY_HAIBAO @"C0205002"//首页-分类图标-2

#define  UM_RECORD_HOME_CATEGORY_RUANJIAN @"C0205003"//首页-分类图标-3

#define  UM_RECORD_HOME_CATEGORY_ZONGHE @"C0205004"//首页-分类图标-4

#define  UM_RECORD_HOME_CATEGORY_C4D @"C0205005"//首页-分类图标-5

#define  UM_RECORD_HOME_BATCH @"C0206001" //首页-推荐教程-换一批

#define  UM_RECORD_HOME_TOP @"C0207001" //首页-置顶



#define  UM_RECORD_LIST_SORT @"C0602001"//列表页-排序

#define  UM_RECORD_LIST_DEFAULT_SORT @"C0602002" //列表页-排序-默认排序

#define  UM_RECORD_LIST_NEW_SORT @"C0602003" //列表页-排序-最新

#define  UM_RECORD_LIST_HOT_SORT @"C0602004" //列表页-排序-最热

#define  UM_RECORD_LIST_HARD_SORT @"C0602005" //列表页-排序-最难

#define  UM_RECORD_LIST_EASY_SORT @"C0602006" //列表页-排序-最简单





#define  UM_RECORD_VIDEO_DETAIL_TAB_DETAIL @"C0703001"//视频详情页-详情tab

#define  UM_RECORD_VIDEO_DETAIL_TAB_EVALUATETAB @"C0704001"//视频详情页-评价tab

#define  UM_RECORD_VIDEO_DETAIL_COMMENT @"C0704002"//视频详情页-评价-评价框

#define  UM_RECORD_VIDEO_DETAIL_LIKE @"C0704003" //视频详情页-评价-点赞

#define  UM_RECORD_PERSONAL_BINDPHONE @"C0903002" //我的-绑定手机号

#define  UM_RECORD_HOME_RECOMMEND_VIDEO @"C0206002" //首页-推荐教程-点击视频



//1.4
#define  UM_RECORD_HOME_NEW_VIDEO  @"C0208001"  //首页-最新教程-点击视频

#define  UM_RECORD_DETAIL_EXERCISE @"C0702004"  //视频详情页-练习题按钮

#define  UM_RECORD_DETAIL_CONCERN @"C0703002" //视频详情页-详情tab-关注/取消关注讲师

#define  UM_RECORD_DETAIL_TEACHER @"C0703003" //视频详情页-详情tab-点击讲师头像跳转至讲师主页

#define  UM_RECORD_DETAIL_LIST_TAB @"C0705001" //视频详情页-目录tab

#define  UM_RECORD_DETAIL_LIST_TAB_PLAY @"C0705002" //视频详情页-目录tab-点击教程

#define  UM_RECORD_CATEGORY_SERIES @"C0802006" //分类页-系列课

#define  UM_RECORD_CATEGORY_IAMAGE @"C0802007"  //分类页-图像合成

#define  UM_RECORD_CATEGORY_PRODUCT @"C0802008" //分类页-产品精修


#define  UM_RECORD_PERSON_CENTEE_FOCUS @"C0902003" //我的-我的关注

#define  UM_RECORD_PERSON_CENTEE_NEWS @"C0906001" //我的-消息中心

#define  UM_RECORD_SERIES_HOME @"C1001001" //系列课小首页-筛选

#define  UM_RECORD_HOME_ICON_6 @"C0205006" //首页-分类图标-6

#define  UM_RECORD_HOME_ICON_7 @"C0205007"  //首页-分类图标-7

#define  UM_RECORD_HOME_ICON_8 @"C0205008"  //首页-分类图标-8

#define  UM_RECORD_VIP_BTN @"C1101001" //全站通VIP购买页-购买按钮

//1.5

#define  UM_RECORD_HOME_NEW_COLLECT_VIDEO  @"C0208002"  //首页-最新教程-收藏

#define  UM_RECORD_HOME_FOCUS_ON    @"C0209001" //首页-我的关注-更多关注

#define  UM_RECORD_HOME_MY_FOCUS_VIDEO  @"C0209002"//首页-我的关注-点击视频

#define  UM_RECORD_HOME_MY_FOCUS_TEACHER @"C0209003"//首页-我的关注-点击讲师

#define  UM_RECORD_HOME_SERIES_MORE @"C0210001" //首页-系列课-更多系列课

#define  UM_RECORD_HOME_SERIES_VIDEO @"C0210002"//首页-系列课-点击视频

#define  UM_RECORD_HOME_BEGINNER_MORE   @"C0211001"//首页-新手入门-更多软件

#define  UM_RECORD_HOME_BEGINNER_VIDEO @"C0211002" //首页-新手入门-点击视频

#define  UM_RECORD_LIST_COLLECT @"C0601003" //列表页-收藏

#define  UM_RECORD_LIST_C4D_BEGINNER    @"C0604001"//C4D列表页-软件入门

#define  UM_RECORD_DETAIL_PAGE_SHARE @"C0702006"//视频详情页-分享

#define  UM_RECORD_DETAIL_PAGE_RECOMMEND    @"C0703004" //视频详情页-详情tab-推荐视频

#define  UM_RECORD_PERSON_CENTER_SIGNIN @"C0907001" //我的-签到

#define  UM_RECORD_SINGIN_PAGE_EVALUATE  @"C1201001"//签到页-获得虎课币-评价教程

#define  UM_RECORD_SINGIN_PAGE_PHONE     @"C1201002" //签到页-获得虎课币-绑定手机号


//v1.6版本

#define  UM_RECORD_COLLECT_DEFAULT   @"C0402001"    //收藏-默认收藏tab

#define  UM_RECORD_COLLECT_MY_COLLECTION   @"C0403001"  //收藏-我的合集tab

#define  UM_RECORD_COLLECT_OTHER_COLLECTION  @"C0404001"  //收藏-收藏合集tab

#define  UM_RECORD_DETAIL_PAGE_CACLE_NEXT   @"C0701004"   //视频详情页-播放窗口-取消跳转下一个视频

#define  UM_RECORD_VIP_ALL_TAB   @"C1101002"     //VIP中心-全站通VIPtab

#define  UM_RECORD_VIP_SINGLE_TAB   @"C1102001"  //VIP中心-分类VIPtab

#define  UM_RECORD_VIP_SINGLE_BUY   @"C1102002"     //VIP中心-分类VIP购买页-购买按钮

#define  UM_RECORD_VIP_SINGLE_CHANGE_TYPE    @"C1102003"     //VIP中心-分类VIP购买页-切换VIP

#define  UM_RECORD_VIP_MY_VIP_MORE   @"C1103001"     //我的VIP-了解更多VIP

#define  UM_RECORD_SINGLE_MALL_DETAIL     @"C1202001"   //签到页-虎课币商城-点击商品详情

#define  UM_RECORD_SIGMIN_EXCHANGE    @"C1202002"  //签到页-虎课币商城-点击立即兑换

#define  UM_RECORD_SIGNIN_PAGE_SIGN_BUTTON    @"C1203001"    //签到页-签到按钮

#define  UM_RECORD_COLLECTION_PAGE_COLLECT    @"C1302001"   //合集详情页-收藏按钮

#define  UM_RECORD_SEARCH_PAGE_HOT       @"C1401001"   //搜索页-热门搜索

#define  UM_RECORD_SEARCH_PAGE_ALL_TAB   @"C1402001"    //搜索页-全部tab

#define  UM_RECORD_SEARCH_ALL_CONCERN    @"C1402002"   //搜索页-全部tab-关注讲师

#define  UM_RECORD_SEARCH_PAGE_VIDEO_TAB   @"C1403001"  //搜索页-教程

#define  UM_RECORD_SEARCH_PAGE_TEACHER_TAB  @"C1404001"    //搜索页-讲师tab

#define  UM_RECORD_SEARCH_PAGE_TEACHER_CONCERN    @"C1404002"   //搜索页-讲师tab-关注讲师



//v1.7版本
#define  UM_RECORD_COLLECT_DEFAULT_SELECT  @"C0402002"      //收藏-默认收藏-筛选

#define  UM_RECORD_DETAIL_PAGE_SPEED       @"C0701005"      //视频详情页-播放窗口-倍速

#define  UM_RECORD_PERSONAL_CENTER_SET     @"C0903003"      //我的-设置

#define  UM_RECORD_PERSONAL_CENTER_MY_ORDER  @"C0908001"    //我的-我的订单

#define  UM_RECORD_LEARNED_PAGE_SELECT       @"C1501001"    //已学教程-筛选

//v1.8版本
#define  UM_RECORD_HOME_PAGE_AD  @"C0212001"    //首页-8个图标下广告位

#define  UM_RECORD_DETAIL_PAGE_SHARE_WATCH   @"C0701006"     //视频详情页-播放窗口-分享解锁观看

#define  UM_RECORD_PERSONAL_CENTER_OPEN_VIP  @"C0909001"    //我的-头像右侧-“开通”


//v1.9版本

#define  UM_RECORD_PERSONAL_CENTER_COUPON   @"C0910001" //我的-优惠券

#define  UM_RECORD_PERSONAL_CENTER_VERSION  @"C0911001"//我的-当前版本

#define  UM_RECORD_TAB_STUDY    @"C1701001" //底部学习tab


#define  UM_RECORD_STUDY_PLAYLIST  @"C1703001"  //学习-已学教程

#define  UM_RECORD_STUDY_FOCUS  @"C1705001" //学习-关注讲师
#define  UM_RECORD_STUDY_MYCOLLECTION   @"C1707001" //学习-专辑


//v1.11版本
#define  UM_RECORD_PERSONALCENTER_RECOMMEND @"C0912001"//我的-推荐虎课给好友

#define  UM_RECORD_DOWN_ALLSTART @"C0502001"//正在下载-全部开始/暂停

#define  UM_RECORD_SHOUYE_ICON9 @"C0205009"//首页-分类图标-9

#define  UM_RECORD_SHOUYE_ICON10 @"C02050010"//首页-分类图标-10

#define  UM_RECORD_SHOUYE_ICON11 @"C02050011"//首页-分类图标-11

#define  UM_RECORD_SHOUYE_ICON12 @"C02050012"//首页-分类图标-12

#define  UM_RECORD_SHOUYE_ICON13 @"C02050013"//首页-分类图标-13

#define  UM_RECORD_PERSONALCENTER_PORTRAIT @"C0909002"//我的-点击头像

#define  UM_RECORD_VIP_ZHONGSHENTAB @"C1104001"//VIP中心-终身全站通VIPtab

#define  UM_RECORD_SEARCHPAGE_XILIEKETAB @"C1405001"//搜索页-系列课tab

#define  UM_RECORD_SEARCHPAGE_PGCTAB @"C1406001"//搜索页-名师机构tab

#define  UM_RECORD_SEARCHPAGE_ZHUANJITAB @"C1407001"//搜索页-专辑tab

#define  UM_RECORD_TEACHERPAGE_SHARE @"C1801001"//讲师个人主页-分享

#define  UM_RECORD_TEACHERPAGE_FOLLOW @"C1801002"//讲师个人主页-关注



//v1.12版本

#define  UM_RECORD_CATEGORY_PAGE_RUANJIANRUMEN  @"C0806001" //分类页-软件入门

#define  UM_RECORD_CATEGORY_PAGE_SHEJIJIAOCHENG     @"C0807001"    //分类页-设计教程

#define  UM_RECORD_CATEGORY_PAGE_ZHIYEFAZHEN    @"C0808001"   //分类页-职业发展

#define  UM_RECORD_VIP_MYVIP_RENEWALS   @"C1103002" //我的VIP-立即续费

#define  UM_RECORD_VIP_MYVIP_UPGRADE    @"C1103003"  //我的VIP-立即升级

#define  UM_RECORD_VIP_CONFIRMATION_PAGE_UPGRADE_PAY    @"C1603001"    //VIP升级-立即支付

#define  UM_RECORD_VIP_RUANJIANRUMEN_HOME_BUY   @"C1901001" //软件入门首页-开通SVIP

#define  UM_RECORD_VIP_RUANJIANRUMEN_HOME_RECENT    @"C1902001"  //软件入门首页-最近在学

#define  UM_RECORD_VIP_RUANJIANRUMEN_HOME_HOT   @"C1903001" //软件入门首页-热门排行

#define  UM_RECORD_VIP_RUANJIANRUMEN_HOME_NEW   @"C1903002" //软件入门首页-最新上线




//v1.13版本

#define  UM_RECORD_DETAIL_PAGE_MEMORY_NEXT  @"C0701007"    //视频详情页-记忆播放-跳转下一节

#define  UM_RECORD_DETAIL_PAGE_PLAY_FINISHED_RECOMMED   @"C0701008"  //视频详情页-播放窗口-推荐教程

#define  UM_RECORD_DETAIL_PAGE_SOFTWARE_RECOMMED    @"C0707001"  //软件入门学习成就-推荐教程

#define  UM_RECORD_DETAIL_PAGE_RUANJIAN_RUMEN   @"C0806001"    //分类页-软件入门

#define  UM_RECORD_DETAIL_PAGE_SHEJI_JIAOCHENG  @"C0807001"   //分类页-设计教程

#define  UM_RECORD_DETAIL_PAGE_ZHIYE_FAZHAN    @"C0808001"  //分类页-职业发展

#define  UM_RECORD_STUDY_ACHIEVEMENT     @"C1708001" //学习-学习成就




// v2.0.0版本

#define  UM_RECORD_SHOUYE_NEWEST_FAVOR  @"C0208003"//首页-最新教程-选择学习兴趣

#define  UM_RECORD_SHOUYE_ALBUM_CLICK   @"C0213001"//首页-精选专辑-点击专辑

#define  UM_RECORD_SHOUYE_ALBUM_MORE    @"C0213002"//首页-精选专辑-更多专辑

#define  UM_RECORD_SHOUYE_TEACHER_CLICK @"C0214001"//首页-推荐讲师-点击讲师

#define  UM_RECORD_SHOUYE_TEACHER_VIDEO @"C0214002"//首页-推荐讲师-点击视频

#define  UM_RECORD_SHOUYE_TEACHER_CONCERN   @"C0214003"//首页-推荐讲师-关注讲师

#define  UM_RECORD_DETAIL_PAGE_EVALUATETAB_SCOREEVALUATE    @"C0704004"//视频详情页-评价-评分旁评价

//#define  UM_RECORD_PERSONAL_CENTER_RECOMMENDHK  @"C0912001"//我的-推荐虎课给好友

#define  UM_RECORD_PERSONAL_CENTER_CONTACTUS    @"C0913001"//我的-联系客服

#define  UM_RECORD_STUDY_INTEREST @"C1709001" //学习-学习兴趣




//v2.1.0版本

#define  UM_RECORD_SHOUYE_LASTTIME_LEARN    @"C0215001" //首页-底部弹出-上次学到

#define  UM_RECORD_DETAILPAGE_PLAY_FINISHED_GRAPHIC1    @"C0701009" //视频详情页-初始播放-图文教程

#define  UM_RECORD_DETAILPAGE_PLAY_FINISHED_GRAPHIC2    @"C0701010" //视频详情页-播放窗口-图文教程（倍速右侧）


#define  UM_RECORD_PERSONAL_CENTER_MALL @"C0914001" //我的-虎课币商城

#define  UM_RECORD_TSKCENTER_MALL   @"C1202003"  //任务中心-虎课币商城

#define  UM_RECORD_TSKCENTER_LEARN  @"C1204001" //任务中心-每日任务-学习新教程

#define  UM_RECORD_TSKCENTER_EVALUATE  @"C1204002" //任务中心-每日任务-评价已学教程


#define  UM_RECORD_TSKCENTER_SHARE  @"C1204003" //任务中心-每日任务-分享教程给好友

#define  UM_RECORD_TSKCENTER_JOB    @"C1205001"  //任务中心-新手任务-完善职业资料

#define  UM_RECORD_TSKCENTER_PHONE  @"C1205002"    //任务中心-新手任务-绑定手机

#define  UM_RECORD_TSKCENTER_WECHAT @"C1205003"   //任务中心-新手任务-绑定微信


#define  UM_RECORD_TSKCENTER_QQ @"C1205004"   //任务中心-新手任务-绑定QQ

#define  UM_RECORD_TSKCENTER_WEIBO  @"C1205005"    //任务中心-新手任务-绑定微博





// v2.2.0版本

#define  UM_RECORD_SHOUYE_WORKS_CLICK   @"C0216001" //首页-作品交流-点击作品

#define  UM_RECORD_SHOUYE_WORKS_MORE    @"C0216002" //首页-作品交流-查看更多

#define  UM_RECORD_LIST_GRAPHIC     @"C0605001" //列表页-筛选图文

#define  UM_RECORD_WORKSLIST_QUESTIONMAKR   @"C2001001" //作品交流列表页-右上角问号

#define  UM_RECORD_WORKSLIST_USERCLICK  @"C2002001"    //作品交流列表页-一个作品-用户头像点击

#define  UM_RECORD_WORKSLIST_WORKSCLICK @"C2002002"   //作品交流列表页-一个作品-作品点击

#define  UM_RECORD_WORKSLIST_LIKE   @"C2002003" //作品交流列表页-一个作品-点赞

#define  UM_RECORD_WORKSLIST_TEACHERCOMMENT @"C2002004"   //作品交流列表页-一个作品-老师点评

#define  UM_RECORD_WORKSLIST_USERCOMMENT    @"C2002005"  //作品交流列表页-一个作品-用户评论





//v2.3.0版本

#define  UM_RECORD_DETAILPAGE_ADD_COLLECTION    @"C0702007"  //视频详情页-添加到专辑

#define  UM_RECORD_STUDY_MYCOLLECTION_ADD   @"C1707002"    //学习-专辑-新建专辑


//V2.4.0

#define  UM_RECORD_PERSONAL_CENTER_APPSTORE     @"C0915001"   //我的-APP好评

#define  UM_RECORD_DETAIL_PAGE_SHARE_TO_WATCH   @"C0701006"   //视频详情页-播放窗口-分享解锁观看

#define  UM_RECORD_LIMIT_BUTTON     @"C0701003"    //观看受限-可分享vip开通

#define  UM_RECORD_DETAIL_PAGE_WINDOW_COLLECT   @"C0701011" //视频详情页-播放窗口-收藏视频

#define  UM_RECORD_AD_OPENING_PAGE  @"C2101001"    //广告位入口-点击开屏页广告

#define  UM_RECORD_AD_POPUPS    @"C2102001" //广告位入口-点击首页爆弹广告

#define  UM_RECORD_AD_SUSPENSION    @"C2103001" //广告位入口-点击首页悬浮广告位

#define  UM_RECORD_SHOUYE_ARTICLE_CLICK  @"C0217001"  //首页-推荐文章-点击文章

#define  UM_RECORD_SHOUYE_ARTICLE_MORE  @"C0216002"   //首页-推荐文章-查看更多

#define  UM_RECORD_STUDY_PLAYLIST_BUY_VIP   @"C1703002" //学习-已学教程-充值VIP

#define  UM_RECORD_DETAIL_PAGE_WINDOW_SETTING   @"C0701012" //视频详情页-全屏播放窗口-更多设置



//v2.5.0
#define  UM_RECORD_LIVESTUDIO_PLAY_INTRODUCTION    @"C2201001"   //直播间_播放器_课程介绍页按钮1

#define  UM_RECORD_LIVESTUDIO_PLAY_UPDATE     @"C2201002" //直播间_播放器_刷新按钮1

#define  UM_RECORD_LIVESTUDIO_PLAY_FULLSCREEN    @"C2201003" //直播间_播放器_全屏按钮1

#define  UM_RECORD_LIVESTUDIO_INFORMATION_CLICK_TEACHER   @"C2202001"    //直播间_直播信息区_点击讲师1

#define  UM_RECORD_LIVESTUDIO_INFORMATION_FOLLOW    @"C2202002"  //直播间-直播信息区_关注讲师1

#define  UM_RECORD_LIVESTUDIO_CHATROOM_CLICK_PERSON     @"C2203001"    //直播间_聊天室_点击用户

#define  UM_RECORD_LIVE_INTRODUCTION_APPLY       @"C2301001" //直播介绍页_底部操作区_报名按钮1

#define  UM_RECORD_SHOUYE_GIFT_BUTTON       @"C0218001"  //首页-礼包按钮


//v2.6.0版本
#define  UM_RECORD_IM_TAB   @"C2401001" //底部聊天tab

#define  UM_RECORD_IM_MY_GROUP_BUTTON   @"C2402001"    //IM聊天_我的群组

#define  UM_RECORD_IM_ADD_GROUP_BUTTON  @"C2403001"  //IM聊天_添加群组

#define  UM_RECORD_IM_RECOMMEND_LOOK  @"C2404001"   //IM聊天_默认推荐区_去看看

#define  UM_RECORD_IM_MESSAGE_LIST  @"C2405001" //IM聊天_消息列表区_点击群组消息

#define  UM_RECORD_IM_CHATBOX_CLICK_TEACHER  @"C2501001" //聊天框_点击老师头像

#define  UM_RECORD_IM_CHATBOX_CLICK_USER    @"C2501002"   //聊天框_点击用户头像_包含管理员

#define  UM_RECORD_IM_CHATBOX_SETTING   @"C2502001"  //聊天框_点击群设置按钮

#define  UM_RECORD_IM_GROUP_SET_CLICK_USER  @"C2601001"  //IM群设置_群成员信息_点击头像

#define  UM_RECORD_IM_GROUP_SET_MORE_PEOPLE  @"C2601002"  //IM群设置_群成员信息_查看更多群成员

#define  UM_RECORD_IM_GROUP_SET_MESSAGE_AVOIDANCE    @"C2603001"    //IM群设置_消息免打扰

#define  UM_RECORD_IM_GROUP_SET_EXIT    @"C2603002"    //IM群设置_退出群聊



//v2.7.0版本

#define  UM_RECORD_TSKCENTER_REMIND     @"C1206001"   //任务中心_开启签到提醒

#define  UM_RECORD_TSKCENTER_SUCCESS_SHARE      @"C1207001"    //任务中心_签到成功弹窗_分享按钮

#define  UM_RECORD_TSKCENTER_SUCCESS_RECOMMEND      @"C1207002"    //任务中心_签到成功弹窗_点击推荐教程或文章

#define  UM_RECORD_LIVES_STUDIO_INFORMATION_JOIN      @"C2202003"    //直播间-直播信息区_加入群组

#define  UM_RECORD_LIVES_STUDIO_ENDING_JOIN     @"C2204001" //直播间_直播结束后引导加入IM群组

#define  UM_RECORD_LIVES_LISTPAGE_HISTORY       @"C2701001"  //直播列表页-精彩回放

#define  UM_RECORD_LIVES_START      @"C2701002" //直播列表页-即将开始


//v2.11.0版本

#define  SHOUYE_ICON14   @"C02050014" // 首页_分类图标_14
#define  SHOUYE_ICON15   @"C02050015" // 首页_分类图标_15
#define  SHOUYE_ICON16   @"C02050016" // 首页_分类图标_16
#define  SHOUYE_ICON17   @"C02050017" // 首页_分类图标_17
#define  SHOUYE_ICON18   @"C02050018" // 首页_分类图标_18
#define  SHOUYE_ICON19   @"C02050019" // 首页_分类图标_19
#define  SHOUYE_ICON20   @"C02050020" // 首页_分类图标_20
#define  LIST_SCREEN_XILIEKE   @"C0603002" // 列表页_筛选_系列课标签
#define  LIST_SCREEN_NEIRONG   @"C0603003" // 列表页_筛选_内容标签
#define  LIST_SCREEN_YONGTU   @"C0603004" // 列表页_筛选_内容子集标签
#define  LIST_SCREEN_RUANJIAN   @"C0603005" // 列表页_筛选_软件标签
#define  LIST_SCREEN_TUWEN   @"C0603006" // 列表页_筛选_图文标签
#define  CATEGORYPAGE_SHEJIJIAOCHENG_ZITI   @"C0807002" // 分类页_设计教程_字体设计
#define  CATEGORYPAGE_SHEJIJIAOCHENG_HAIBAO   @"C0807003" // 分类页_设计教程_海报设计
#define  CATEGORYPAGE_SHEJIJIAOCHENG_PINPAI   @"C0807004" // 分类页_设计教程_品牌设计
#define  CATEGORYPAGE_SHEJIJIAOCHENG_TUXIANG   @"C0807005" // 分类页_设计教程_图像设计
#define  CATEGORYPAGE_SHEJIJIAOCHENG_C4D   @"C0807006" // 分类页_设计教程_C4D教程
#define  CATEGORYPAGE_SHEJIJIAOCHENG_RENXIANG   @"C0807007" // 分类页_设计教程_人像精修
#define  CATEGORYPAGE_SHEJIJIAOCHENG_CHANPIN   @"C0807008" // 分类页_设计教程_产品精修
#define  CATEGORYPAGE_SHEJIJIAOCHENG_DIANPU   @"C0807009" // 分类页_设计教程_店铺精修
#define  CATEGORYPAGE_SHEJIJIAOCHENG_UI   @"C0807010" // 分类页_设计教程_UI设计
#define  CATEGORYPAGE_SHEJIJIAOCHENG_SHEYING   @"C0807011" // 分类页_设计教程_摄影艺术
#define  CATEGORYPAGE_SHEJIJIAOCHENG_SHINEI   @"C0807012" // 分类页_设计教程_室内设计
#define  CATEGORYPAGE_SHEJIJIAOCHENG_YINGSHI   @"C0807013" // 分类页_设计教程_影视动画
#define  CATEGORYPAGE_SHEJIJIAOCHENG_HUIHUA   @"C08070014" // 分类页_设计教程_绘画插画
#define  CATEGORYPAGE_SHEJIJIAOCHENG_BANGONG   @"C0807015" // 分类页_设计教程_办公软件
#define  CATEGORYPAGE_SHEJIJIAOCHENG_HAIWAI   @"C0807016" // 分类页_设计教程_海外教程
#define  CATEGORYPAGE_SHEJIJIAOCHENG_ZONGHE   @"C0807017" // 分类页_设计教程_综合教程
#define  TSKCENTER_XUNZHANG   @"C1206002" // 任务中心_勋章入口
#define  STUDY_XUNZHANGCHENGJIU   @"C1710001" // 学习-勋章成就
#define  DETAILPAGE_SCREENING   @"C0701013" // 视频详情页-全屏播放窗口-投屏
#define  DETAILPAGE_LISTTAB_EXERCISE   @"C0705003" // 视频详情页-目录tab-点击练习题
#define  SHORTVIDEO_TAB   @"C2801001" // 底部短视频tab
#define  SHORTVIDEO_TEACHER   @"C2802001" // 短视频_点击讲师头像和名字
#define  SHORTVIDEO_FOLLOWTEACHER   @"C2802002" // 短视频_关注讲师
#define  SHORTVIDEO_LIKE   @"C2803001" // 短视频_点赞
#define  MYHOMEPAGE_LIKESHORTVIDEO   @"C2901001" // 用户个人主页_点赞短视频tab
#define  SELECTINTEREST_RECOMMENDEDCOURSE_FIRSTVIDEO   @"C3001001" // 学习兴趣页推荐课程_点击第1个课程
#define  SELECTINTEREST_RECOMMENDEDCOURSE_COLLECTFIRSTVIDEO   @"C3001002" // 学习兴趣页推荐课程_收藏第1个课程
#define  SELECTINTEREST_RECOMMENDEDCOURSE_SECONDVIDEO   @"C3001003" // 学习兴趣页推荐课程_点击第2个课程
#define  SELECTINTEREST_RECOMMENDEDCOURSE_COLLECTSECONDVIDEO   @"C3001004" // 学习兴趣页推荐课程_收藏第2个课程
#define  SELECTINTEREST_RECOMMENDEDCOURSE_THIRDVIDEO   @"C3001005" // 学习兴趣页推荐课程_点击第3个课程
#define  SELECTINTEREST_RECOMMENDEDCOURSE_COLLECTTHIRDVIDEO   @"C3001006" // 学习兴趣页推荐课程_收藏第3个课程
#define  SELECTINTEREST_RECOMMENDEDCOURSE_FOURTHVIDEO   @"C3001007" // 学习兴趣页推荐课程_点击第4个课程
#define  SELECTINTEREST_RECOMMENDEDCOURSE_COLLECTFOURTHVIDEO   @"C3001008" // 学习兴趣页推荐课程_收藏第4个课程



// v 2.12
#define UM_RECORD_SHORTVIDEO_COMMENT    @"C2803002"    //短视频_评论

#define UM_RECORD_SHORTVIDEO_SHARE      @"C2803003"  //短视频_分享

#define UM_RECORD_SHORTVIDEO_TYPE       @"C2804001"   //短视频_分类

#define UM_RECORD_STUDY_MYLIKE      @"C1711001"  //学习_我的点赞



//v2.13.0版本
#define UM_RECORD_STUDY_TREND   @"C1712001"    //学习_今日学习趋势图

#define UM_RECORD_CAREERPATH_RECENTSTUDY    @"C3101001" //职业路径页_最近在学_点击课程

#define UM_RECORD_CAREERPATH_HOT    @"C3102001" //职业路径页_热门职业_点击课程

#define UM_RECORD_GPRS_ALERT_ALLOW_4G     @"C3201001"    //流量提醒弹窗_开启流量播放

#define UM_RECORD_GPRS_ALERT_CANCLE   @"C3202001" //流量提醒弹窗_取消

#define UM_RECORD_GPRS_ALERT_CONTINUEPLAY @"C3203001"   //流量提醒弹窗_继续播放



// v2.14.0版本

#define UM_RECORD_SHOUYE_AUDIO_CLIKC    @"C0219001" //首页_虎课读书_点击书籍

#define UM_RECORD_SHOUYE_AUDIO_MORE     @"C0219002"  //首页_虎课读书_查看更多

#define UM_RECORD_CATEGORY_PAGE_HUKEDUSHU   @"C0810001"  //分类页_虎课读书

#define UM_RECORD_HUKEDUSHU_DETAILPAGE_PLAY     @"C3301001"   //虎课读书详情页_播放按钮

#define UM_RECORD_HUKEDUSHU_DETAILPAGE_LIST     @"C3301002"   //虎课读书详情页_目录

#define UM_RECORD_HUKEDUSHU_DETAILPAGE_CONTRIBUTION     @"C3301003"   //虎课读书详情页_文稿

#define UM_RECORD_HUKEDUSHU_DETAILPAGE_TIMING       @"C3301004" //虎课读书详情页_定时

#define UM_RECORD_AUDIO_FALIATING_WINDOW_CLICK  @"C3401001"  //音频悬浮窗_点击进入

#define UM_RECORD_AUDIO_FALIATING_WINDOW_CLOSE     @"C3401002"  //音频悬浮窗_关闭





//v2.15.0版本

#define UM_RECORD_LIST_RECOMMOND_CARRERPATH     @"C0606001"  //列表页_系统课程推荐_职业路径

#define UM_RECORD_LIST_RECOMMOND_SOFTWARE       @"C0606002"    //列表页_系统课程推荐_软件入门

#define UM_RECORD_DETAILPAGE_AUDIO  @"C0101014"   //视频详情页_播放窗口_音频播放

#define UM_RECORD_SHORTVIDEO_LABEL  @"C2805001"   //短视频_点击标签

#define UM_RECORD_SHORTVIDEO_ASSOCIATED_VIDEO  @"C2805002" //短视频_点击查看视频

#define UM_RECORD_HUKEDUSHU_DETAIL_PAGE_SHARE       @"C3301005" //虎课读书详情页_分享



///v2.16.0版本

#define UM_RECORD_HUKEDUSHU_DETAILPAGE_DIRECTCOMMENT    @"C3301006"  //虎课读书详情页_直接评论框

#define UM_RECORD_HUKEDUSHU_DETAILPAGE_COMMENT  @"C3301007"//虎课读书详情页_评论按钮

#define UM_RECORD_HUKEDUSHU_DETAILPAGE_COLLECT  @"C3301008"//虎课读书详情页_收藏按钮

#define UM_RECORD_AUDIO_FLOATINGWINDOW_PAUSE    @"C3401003"//音频悬浮窗_播放暂停






/////v2.18.0版本
#define um_shouye_qiandao  @"C0202002"  //首页_签到入口

#define um_fenleiye_ruanjian_banner @"C0806002"    //分类页_软件入门_banner点击

#define um_fenleiye_ruanjian_biaoqianyi  @"C0806003"    //分类页_软件入门_标签一软件点击

#define um_fenleiye_ruanjian_morebiaoqianyi  @"C0806004"    //分类页_软件入门_标签一软件更多点击

#define um_fenleiye_ruanjian_biaoqianer  @"C0806005"    //分类页_软件入门_标签二软件点击

#define um_fenleiye_ruanjian_morebiaoqianer  @"C0806006"    //分类页_软件入门_标签二软件更多点击

#define um_fenleiye_ruanjian_biaoqiansan  @"C0806007"   //分类页_软件入门_标签三软件点击

#define um_fenleiye_ruanjian_morebiaoqiansan  @"C0806008"   //分类页_软件入门_标签三软件更多点击

#define um_fenleiye_ruanjian_biaoqiansi  @"C0806009"    //分类页_软件入门_标签四软件点击

#define um_fenleiye_ruanjian_morebiaoqiansi  @"C0806010"    //分类页_软件入门_标签四软件更多点击

#define um_fenleiye_ruanjian_biaoqianwu  @"C0806011"    //分类页_软件入门_标签五软件点击

#define um_fenleiye_ruanjian_morebiaoqianwu  @"C0806012"    //分类页_软件入门_标签五软件更多点击

#define um_fenleiye_ruanjian_biaoqianliu  @"C0806013"   //分类页_软件入门_标签六软件点击

#define um_fenleiye_ruanjian_morebiaoqianliu  @"C0806014"   //分类页_软件入门_标签六软件更多点击

#define um_fenleiye_ruanjian_biaoqianqi  @"C0806015"    //分类页_软件入门_标签七软件点击

#define um_fenleiye_ruanjian_morebiaoqianqi  @"C0806016"    //分类页_软件入门_标签七软件更多点击

#define um_fenleiye_ruanjian_biaoqianba  @"C0806017"    //分类页_软件入门_标签八软件点击

#define um_fenleiye_ruanjian_morebiaoqianba  @"C0806018"    //分类页_软件入门_标签八软件更多点击

#define um_fenleiye_ruanjian_biaoqianjiu  @"C0806019"   //分类页_软件入门_标签九软件点击

#define um_fenleiye_ruanjian_morebiaoqianjiu  @"C0806020"   //分类页_软件入门_标签九软件更多点击

#define um_fenleiye_zhiye_banner  @"C0808002"   //分类页_职业发展_banner点击

#define um_fenleiye_zhiye_bangong  @"C0808003"  //分类页_职业发展_办公软件点击

#define um_fenleiye_zhiye_morebangong  @"C0808004"  //分类页_职业发展_办公软件更多点击

#define um_fenleiye_zhiye_zhiye  @"C0808005"    //分类页_职业发展_职业发展点击

#define um_fenleiye_zhiye_morezhiye  @"C0808006"    //分类页_职业发展_职业发展更多点击

#define um_fenleiye_xueshengtab  @"C0811001"    //分类页_学生专区

#define um_fenleiye_xuesheng_banner  @"C0811002"    //分类页_学生专区_banner点击

#define um_fenleiye_xuesheng_biaoqianyi  @"C0811003"    //分类页_学生专区_标签一内容点击

#define um_fenleiye_xuesheng_morebiaoqianyi  @"C0811004"    //分类页_学生专区_标签一内容更多点击

#define um_fenleiye_xuesheng_biaoqianer  @"C0811005"    //分类页_学生专区_标签二内容点击

#define um_fenleiye_xuesheng_morebiaoqianer  @"C0811006"    //分类页_学生专区_标签二内容更多点击

#define um_fenleiye_xuesheng_biaoqiansan  @"C0811007"   //分类页_学生专区_标签三内容点击

#define um_fenleiye_xuesheng_morebiaoqiansan  @"C0811008"   //分类页_学生专区_标签三内容更多点击

#define um_fenleiye_xuesheng_biaoqiansi  @"C0811009"    //分类页_学生专区_标签四内容点击

#define um_fenleiye_xuesheng_morebiaoqiansi  @"C0811010"    //分类页_学生专区_标签四内容更多点击

#define um_fenleiye_xuesheng_biaoqianwu  @"C08110011"   //分类页_学生专区_标签五内容点击

#define um_fenleiye_xuesheng_morebiaoqianwu  @"C0811012"    //分类页_学生专区_标签五内容更多点击

#define um_fenleiye_xuesheng_biaoqianliu  @"C0811013"   //分类页_学生专区_标签六内容点击

#define um_fenleiye_xuesheng_morebiaoqianliu  @"C0811014"   //分类页_学生专区_标签六内容更多点击

#define um_hukedushushouye_tab @"C3501001" //底部虎课读书tab

#define um_hukedushushouye_banner @"C3502001"  //虎课读书小首页_banner点击

#define um_hukedushushouye_meiridushu  @"C3503001"  //虎课读书小首页_每日读本书点击

#define um_hukedushushouye_biaoqian  @"C3504001"    //虎课读书小首页_书籍列表_标签点击

#define um_hukedushushouye_ruanjian  @"C3504002"    //虎课读书小首页_书籍列表_书籍点击




/// 2.19.0


#define um_hukedushu_detailpage_speed   @"C3301009"  //虎课读书详情页_倍速按钮
#define um_hukedushu_speedpage_0_75     @"C3601001"    //虎课读书_倍速选择框0_75X
#define um_hukedushu_speedpage_1_0X     @"C3601002"    //虎课读书_倍速选择框1_0X
#define um_hukedushu_speedpage_1_25X    @"C3601003"   //虎课读书_倍速选择框1_25X
#define um_hukedushu_speedpage_1_5X     @"C3601004"    //虎课读书_倍速选择框1_5X
#define um_hukedushu_speedpage_2_0X     @"C3601005"    //虎课读书_倍速选择框2_0X

#define um_ruanjianrumen_home_label  @"C1903003"    //软件入门首页_软件标签点击
#define um_ruanjianrumen_home_clicksoftware  @"C1903004"    //软件入门首页_软件点击

#define um_videodetailpage_smallplayer_caststreen  @"C0708001"  //视频详情页_竖屏播放窗口_投屏
#define um_videodetailpage_smallplayer_audio    @"C0708002"   //视频详情页_竖屏播放窗口_音频播放
#define um_videodetailpage_smallplayer_graphic  @"C0708003" //视频详情页_竖屏播放窗口_图文教程
#define um_videodetailpage_smallplayer_speed    @"C0708004"   //视频详情页_竖屏播放窗口_倍速
#define um_videodetailpage_smallplayer_fast5    @"C0708005"   //视频详情页_竖屏播放窗口_快进5s
#define um_videodetailpage_smallplayer_return5  @"C0708006" //视频详情页_竖屏播放窗口_快退5s

#define um_videodetailpage_fulllplayer_caststreen  @"C0709001"  //视频详情页_全屏播放窗口_投屏
#define um_videodetailpage_fulllplayer_audio    @"C0709002"   //视频详情页_全屏播放窗口_音频播放
#define um_videodetailpage_fulllplayer_graphic  @"C0709003" //视频详情页_全屏播放窗口_图文教程
#define um_videodetailpage_fulllplayer_speed    @"C0709004"   //视频详情页_全屏播放窗口_倍速
#define um_videodetailpage_fulllplayer_fast5    @"C070905"    //视频详情页_全屏播放窗口_快进5s

#define um_videodetailpage_fulllplayer_return5  @"C0709006" //视频详情页_全屏播放窗口_快退5s
#define um_videodetailpage_fulllplayer_setting  @"C0709007" //视频详情页_全屏播放窗口_更多设置
#define um_videodetailpage_fulllplayer_lock     @"C0709008"    //视频详情页_全屏播放窗口_锁屏
#define um_videodetailpage_fulllplayer_buy      @"C0709009" //视频详情页_全屏播放窗口_充值VIP

#define um_videodetailpage_fulllplayer_speed0_75    @"C0710001"     //视频详情页_全屏播放窗口_倍速选择框0_75X
#define um_videodetailpage_fulllplayer_speed1_0X    @"C0710002"    //视频详情页_全屏播放窗口_倍速选择框1_0X
#define um_videodetailpage_fulllplayer_speed1_25X   @"C0710003"   //视频详情页_全屏播放窗口_倍速选择框1_25X
#define um_videodetailpage_fulllplayer_speed1_5X    @"C0710004"    //视频详情页_全屏播放窗口_倍速选择框1_5X
#define um_videodetailpage_fulllplayer_speed2_0X    @"C0710005"    //视频详情页_全屏播放窗口_倍速选择框2_0X

#define um_videodetailpage_smalllplayer_speed0_75   @"C0712001" //视频详情页_竖屏播放窗口_倍速选择框0_75X
#define um_videodetailpage_smalllplayer_speed1_0X   @"C0712002" //视频详情页_竖屏播放窗口_倍速选择框1_0X
#define um_videodetailpage_smalllplayer_speed1_25X  @"C0712003" //视频详情页_竖屏播放窗口_倍速选择框1_25X
#define um_videodetailpage_smalllplayer_speed1_5X   @"C0712004" //视频详情页_竖屏播放窗口_倍速选择框1_5X
#define um_videodetailpage_smalllplayer_speed2_0X   @"C0712005" //视频详情页_竖屏播放窗口_倍速选择框2_0X

#define um_videodetailpage_fulllplayer_settingpage_wifiopen     @"C0711001" //视频详情页_全屏播放窗口_更多设置_wifi下自动播放开启
#define um_videodetailpage_fulllplayer_settingpage_wificlose    @"C0711002" //视频详情页_全屏播放窗口_更多设置_wifi下自动播放关闭
#define um_videodetailpage_fulllplayer_settingpage_speedopen    @"C0711003" //视频详情页_全屏播放窗口_更多设置_记住倍速开启
#define um_videodetailpage_fulllplayer_settingpage_speedclose   @"C0711004" //视频详情页_全屏播放窗口_更多设置_记住倍速关闭
#define um_videodetailpage_fulllplayer_settingpage_report   @"C0711005" //视频详情页_全屏播放窗口_更多设置_举报视频
#define um_videodetailpage_fulllplayer_settingpage_line1    @"C0711006" //视频详情页_全屏播放窗口_更多设置_切换线路_线路一  七牛
#define um_videodetailpage_fulllplayer_settingpage_line2    @"C0711007" //视频详情页_全屏播放窗口_更多设置_切换线路_线路二  腾讯

#define um_videodetailpage_smallplayer_nextvideo    @"C0708007"   //视频详情页_竖屏播放窗口_目录课播放结束_立即播放下一节
#define um_videodetailpage_smallplayer_replay   @"C0708008"  //视频详情页_竖屏播放窗口_目录课播放结束_重播
#define um_videodetailpage_fulllplayer_nextvideo    @"C0709010"   //视频详情页_全屏播放窗口_目录课播放结束_立即播放下一节
#define um_videodetailpage_fulllplayer_replay   @"C0709011"  //视频详情页_全屏播放窗口_目录课播放结束_重播


#define um_searchpage_history   @"C1401002"  //搜索页_搜索历史
#define um_searchpage_related   @"C1401003"  //搜索页_关联搜索
#define um_searchpage_videotab_teacher  @"C1403002" //搜索页_教程tab_点击讲师
#define um_searchpage_videotab_software     @"C1403003" //搜索页_教程tab_点击软件


#define um_searchpage_videotab_series   @"C1403004" //搜索页_教程tab_点击系列课
#define um_searchpage_videotab_video    @"C1403005" //搜索页_教程tab_点击课程
#define um_searchpage_teachertab_click  @"C1404003" //搜索页_讲师tab_点击讲师
#define um_searchpage_seriestab_click   @"C1405002" //搜索页_系列课tab_点击系列课
#define um_searchpage_albumtab_click    @"C1407002" //搜索页_专辑tab_点击专辑
#define um_searchpage_softwaretab   @"C1408001" //搜索页_软件tab
#define um_searchpage_softwaretab_click     @"C1408002" //搜索页_软件tab_点击软件

#define um_searchpage_articletab    @"C1409001" //搜索页_文章tab
#define um_searchpage_articletab_click  @"C1409002" //搜索页_文章tab_点击文章



#define um_pop_notice_open      @"C3701001" //开启通知弹窗_开启通知
#define um_pop_notice_close     @"C3701002" //开启通知弹窗_关闭

#define um_pop_comment_like     @"C3801001" //引导评论弹窗_我喜欢
#define um_pop_comment_dislike  @"C3801002" //引导评论弹窗_想吐槽
#define um_pop_comment_close    @"C3801003" //引导评论弹窗_关闭



#define um_train_tian_weixin_click  @"C3901001" //训练营日历页面_添加班主任微信按钮点击
#define um_train_weixin_save_click  @"C3902001"  //训练营日历页面_添加班主任微信弹框_保存二维码图片


//2.25
#define login_thisphone @"C0101004" //登录页_本机号码一键登录
#define shouye_livestudio @"C0220001" //首页_今日直播_点击直播
#define shouye_guessyoulike @"C0221001" //首页_猜你喜欢_点击视频
#define shouye_hukedushu_clickbook @"C0222001" //首页_虎课读书_点击书籍
#define shouye_hukedushu_more @"C0222002" //首页_虎课读书_点击查看更多
#define shouye_login_click @"C0224001" //首页_底部弹出_点击登录
#define detailpage_clickcertificate @"C0713001" //视频详情页_点击课程证书
#define detailpage_sharelimit_buy @"C0701015" //视频详情页_播放窗口_分享次数消耗完充值按钮
#define fenleiye_hukedushu_banner @"C0810002" //分类页_虎课读书_banner点击
#define fenleiye_hukedushu_play @"C0810003" //分类页_虎课读书_播放音频
#define fenleiye_zhiyelujingtab @"C0812001" //分类页_职业路径
#define fenleiye_zhiyelujing_zhiye @"C0812002" //分类页_职业路径_职业课程点击
#define fenleiye_zhiyelujing_more @"C0812003" //分类页_职业路径_更多点击
#define fenleiye_hukewangxiao @"C0813001" //分类页_虎课网校
#define fenleiye_hukewangxiao_livestudio @"C0813002" //分类页_虎课网校_直播课点击
#define fenleiye_hukewangxiao_more @"C0813003" //分类页_虎课网校_更多点击
#define ruanjianrumen_lunbo @"C1901001" //软件入门首页_点击轮播信息
#define tuwenjiaocheng_read @"C4001001" //图文教程_阅读按钮
#define tuwenjiaocheng_viewlimit_buy @"C4001002" //图文教程_次数消耗完付费按钮
#define shouye_view @"C0223001" //首页_浏览 1、启动进入 2、切换进入
#define hukedushu_detailpage_playing @"C3301010" //虎课读书详情页_播放音频
#define detailpage_playing @"C0701016" //视频详情页_播放视频

//直播训练营新增埋点
#define training_camp_wechat_view  @"C3902002" //训练营日历页面_添加班主任微信icon点击
#define training_camp_view  @"C3903001" //训练营日历页面浏览
#define training_camp_invite_like  @"C3904001" //训练营日历页面_请人点赞按钮点击
#define dailytask_view  @"C4101001" //每日任务列表页浏览
#define dailytask_specialtask_click  @"C4102001" //每日任务列表页_特殊任务卡片_特殊任务点击
#define dailytask_regulartask_videoclick  @"C4103001" //每日任务列表页_作业任务卡片_视频教学点击
#define dailytask_regulartask_upload  @"C4103002" //每日任务列表页_作业任务卡片_作业上传点击
#define dailytask_regulartask_share  @"C4103003" //每日任务列表页_作业任务卡片_作品分享点击
#define dailytask__takeaward  @"C4104001" //每日任务列表页_奖品领取按钮点击
#define hukewangxiao_view  @"C4201001" //虎课网校首页浏览
#define hukewangxiao_today_livestudio  @"C4202001" //虎课网校首页_今日直播_直播课程点击
#define hukewangxiao_classlist_click  @"C4203001" //虎课网校首页_课程列表_正在招募课程点击
#define liveclass_free_view  @"C4301001" //免费直播课程详情页浏览
#define liveclass_free_enroll_button  @"C4302001" //免费直播课程详情页_报名按钮_点击报名
#define liveclass_free_details_followteacher  @"C4303001" //免费直播课程详情页_课程详情_关注讲师
#define liveclass_view  @"C4401001" //付费直播课程详情页浏览
#define liveclass_enroll_button  @"C4402001" //付费直播课程详情页_报名按钮_点击报名
#define liveclass_details_followteacher  @"C4403001" //付费直播课程详情页_课程详情_关注讲师

#define my_home_page_ad_banner  @"C0916001" //我的-广告banner



//2.27-1版本埋点需求

#define detailpage_notice          @"C0714001"   //视频详情页-学习计划提醒弹框-确定开启
#define personalcenter_news_notice @"C0906002"   //我的-点击消息提醒浮层
#define study_focus_teacher        @"C1705002"   //学习-关注讲师-关注讲师头像总点击
#define study_focus_teacher_live   @"C1705003"   //学习-关注讲师-直播中讲师头像点击
#define study_focus_teacher_update @"C1705004"   //学习-关注讲师-有更新讲师头像点击
#define study_focus_teacher_normal @"C1705005"   //学习-关注讲师-无更新讲师头像点击
#define study_focus_class_update   @"C1705006"   //学习-关注讲师-课程更新模块点击
#define hukedushu_detailpage_book  @"C3301011"   //虎课读书详情页_实体书
#define livestudio_assistant       @"C2202004"   ////直播间-直播信息区_联系班主任
#define training_camp_QRcode       @"C4501001"   ////训练营二维码引导弹框页面浏览
#define liveintroduction_QRcode    @"C4601001"  ////直播课二维码引导弹框页面浏览

//2.29.0 版本埋点需求
#define newtask_icon                 @"C0226001"     //新手任务-限时领图标点击
#define newtask_signin               @"C0226002"     //新手任务弹框-去注册点击（后台同步增加路径登录统计）
#define newtask_tolearn              @"C0226003"     //新手任务弹框-去学习点击
#define newtask_getvip               @"C0226004"     //新手任务弹框-领取奖励点击
#define newtask_getcamp              @"C0226005"     //新手任务弹框-领取免费训练营点击
#define newtask_oldfriends           @"C0226006"     //新手任务弹框-查看老用户福利点击
#define newtask_signedtips           @"C0226007"     //新手任务-注册完成领取奖励提示点击
#define newcamp_forfree              @"C0226008"     //领取训练营-免费领取按钮点击
#define newcamp_sharevx              @"C0226009"     //领取训练营-保存图片并分享到微信按钮点击
#define personalcenter_recommend1    @"C0916001"     //我的tab-推荐-模块1点击
#define personalcenter_recommend2    @"C0916002"     //我的tab-推荐-模块2点击
#define personalcenter_recommend3    @"C0916003"     //我的tab-推荐-模块3点击
#define personalcenter_recommend4    @"C0916004"     //我的tab-推荐-模块4点击
#define searchpage_all_teacher_live  @"C1403006"     //搜索页_教程tab_点击讲师头像跳转直播
#define login_unfold                 @"C0103001"     //登录框-展开社交账号
#define shouye_album1_video          @"C0213003"     //首页-专辑一-点击视频
#define shouye_album1_more           @"C0213004"     //首页-专辑一-点击全部
#define shouye_album2_video          @"C0213005"     //首页-专辑二-点击视频
#define shouye_album2_more           @"C0213006"     //首页-专辑二-点击全部
#define shouye_albumlist_album       @"C0213007"     //首页-专辑-点击专辑
#define shouye_albumlist_more        @"C0213008"     //首页-专辑-点击全部
#define shouye_teacherlist_video     @"C0214004"     //首页-推荐讲师-点击视频-信息流
#define shouye_teacherlist_teacher   @"C0214005"     //首页-推荐讲师-点击头像/主页-信息流
#define careerpath_TotalVip          @"C3103001"     //职业路径课程详情页-全站通畅学提示
#define shouye_topDialogs_view       @"C0227001"     //首页_直播课导流顶部弹框_浏览
#define shouye_topDialogs_click      @"C0227002"     //首页_直播课导流顶部弹框_点击
     
//2.30 版本埋点需求
#define list_advance_prime      @"C0607006"//列表页-筛选进阶课程(主包)
#define list_series_prime      @"C0607007"//列表页-筛选系列课(主包)
#define list_graphic_prime      @"C0607008"//列表页-筛选图文(主包)（筛选栏直接选中图文教程）
#define list_save_prime      @"C0607009"//列表页-筛选-确定(主包)
#define list_select_prime      @"C0607010"//列表页-筛选(主包)
#define list_video_prime      @"C0609004"//列表页-结果课程点击(主包)
#define list_vip_prime      @"C0606003"//列表页-全站通vip尊享
#define list_tab      @"C0611001"//列表页-切换tab
#define list_search      @"C0611002"//列表页-搜索

#define shouye_chendu_class      @"C0228001"//首页-晨读精选-点击书籍
#define shouye_chendu_more      @"C0228002"//首页-晨读精选-查看更多

#define detailpage_note_show      @"C0715001"//视频全屏-笔记选择-展示
#define detailpage_note_show_savepic      @"C0715002"//视频全屏-笔记选择-保存为截图笔记
#define detailpage_note_show_addnotes      @"C0715003"//视频全屏-笔记选择-添加文字笔记
#define detailpage_note_show_share      @"C0715004"//视频全屏-笔记选择-分享
#define detailpage_note_click      @"C0715005"//视频全屏-记录笔记
#define detailpage_note_select      @"C0715006"//视频全屏-精选笔记
#define detailpage_note_select_like      @"C0715007"//视频全屏-精选笔记-点赞
#define detailpage_note_select_time      @"C0715008"//视频全屏-精选笔记-时间点

#define detailpage_watchedcomment      @"C0716001"//视频详情页-观看后评论悬浮按钮

#define personalcenter_note      @"C0917001"//我的-我的笔记

#define notelist_search      @"C4701001"//笔记列表-搜索
#define notelist_like      @"C4701002"//笔记列表-点赞笔记
#define notelist_edit      @"C4701003"//笔记列表-编辑笔记
#define notelist_delete      @"C4701004"//笔记列表-删除笔记
#define notelist_time      @"C4701005"//笔记列表-时间点
#define notelist_search_class      @"C4702001"//笔记搜索-课程tab点击
#define notelist_search_click      @"C4702002"//笔记搜索-笔记内容结果点击
#define notelist_search_class_click      @"C4702003"//笔记搜索-课程结果点击

#define personalcenter_news_comment      @"C0906003"//我的-消息中心-评论/回复
#define personalcenter_news_like      @"C0906004"//我的-消息中心-收到的赞
 
#define hukewangxiao_mylivestudio      @"C4204001"//虎课网校首页_我的直播课_我的直播课按钮点击


#define eclass_free_comment      @"C4304001"//免费直播课程详情页_评价tab点击
#define liveclass_free_comment_publish      @"C4304002"//免费直播课程详情页_评价tab_评价入口（点击页面底部评价入口按钮次数。“说点什么吧”）
#define liveclass_free_list      @"C4305001"//免费直播课程详情页_目录tab
#define liveclass_cost_comment      @"C4404001"//付费直播课程详情页_评价tab
#define liveclass_comment_publish      @"C4404002"//付费直播课程详情页_评价tab_评价入口
#define liveclass_list      @"C4405001"//付费直播课程详情页_目录tab



#define training_camp_qrcode_wechat      @"C4501002"//训练营二维码引导弹框页面_微信分享
#define mylivestudio_view      @"C4801001"//我的直播课页面浏览
#define mylivestudio_classlist_class      @"C4802001"//我的直播课页面_课程列表_课程点击
#define training_camp_shouye_view      @"C4901001"//训练营首页浏览
#define training_camp_shouye_apply_recruit      @"C4902001"//训练营首页_火热报名中_训练营招募点击



//2.31 版本埋点需求
//新增
#define community_follow_tab               @"C5001001"//社区动态首页-关注tab点击

#define community_question_tab             @"C5001002"//社区动态首页-提问答疑tab点击

#define community_task_tab                 @"C5001003"//社区动态首页-作业点评tab点击

#define community_works_tab                @"C5001004"//社区动态首页-作品tab点击

#define community_hot_topics               @"C5001005"//社区动态首页-热门话题区域点击

#define community_publish                  @"C5002001"//社区动态首页-悬浮按钮点击

#define community_publish_content          @"C5002002"//社区动态首页-悬浮按钮-发动态

#define community_publish_question         @"C5002003"//社区动态首页-悬浮按钮-提问

#define community_content_follow           @"C5003001"//动态-关注按钮点击
#define community_content_relevantclass    @"C5003002"//动态-关联课程点击
#define community_content_topic            @"C5003003"//动态-关联话题点击
#define community_content_class            @"C5003004"//动态-课程类动态点击
#define community_content_works            @"C5003005"//动态-作品类动态点击
#define community_content_liveclass        @"C5003006"//动态-直播类动态点击
#define content_view                       @"C5004001"//动态详情页-浏览
#define content_class                      @"C5004002"//动态详情页-关联课程点击
#define publish_content_choose_topic       @"C5005001"//发表动态-选择话题
#define publish_content_release            @"C5005002"//发表动态-发布
#define publish_content_cancel             @"C5005003"//发表动态-放弃发布
#define community_follow_tab_unfollow_view @"C5006001"//社区动态-关注-未关注人-浏览
#define community_follow_tab_notlogin_view @"C5006002"//社区动态-关注-未登录-浏览
#define community_follow_tab_nocontent_view @"C5006003"//社区动态-关注-动态少于2条-浏览
#define community_follow_tab_follow        @"C5006004"//社区动态-关注tab-可能感兴趣的人-关注
#define community_follow_tab_homepage      @"C5006005"//社区动态-关注tab-可能感兴趣的人-跳转主页
#define community_topic_tab_hot            @"C5007001"//社区动态-话题-最热
#define community_question_tab_hot         @"C5007002"//社区动态-提问答疑-最热答疑
#define community_question_tab_filter      @"C5007003"//社区动态-提问答疑-按分类筛选-确定
#define community_task_tab_hot             @"C5007004"//社区动态-作业点评-最热点评
#define community_works_tab_hot            @"C5007005"//社区动态-作品-最热作品
#define personalcenter_message_interact_follow @"C0906005"//我的-消息中心-互动-关注按钮点击


//2.31 版本埋点需求
#define community_question_select             @"C5001006"   //社区动态-提问-精选答疑
#define community_question_answered           @"C5001007"   //社区动态-提问-已解答
#define community_question_unanswered         @"C5001008"   //社区动态-提问-待解答

#define community_question_quiz               @"C5001009"   //社区动态-提问-我要提问

#define videodetailpage_fulllplayer_series    @"C0101016"   //视频详情页-全屏播放窗口-选集
//#define shouye_recommend_content              @"C0229001"   //首页-安利墙-区域内容点击

#define shouye_recommend_more                 @"C0229002"   //首页-安利墙-查看更多点击
#define shouye_recommend_class                @"C0229003"   //首页-安利墙-课程区域点击
#define shouye_recommend_more_content         @"C0229004"   //首页-安利墙更多页面-内容点击

#define training_camp_Switch_date             @"C3905001"   //训练营日历-切换上一天/下一天
#define training_camp_date                    @"C3905002"   //训练营日历-日期点击
#define training_camp_clockon                 @"C3905003"   //训练营日历-已打卡/未打卡点击
#define fenleiye_hukedushu_more               @"C0810004"   //分类tab-虎课读书-查看更多点击

//#ios
//中间tab点击（可沿用虎课读书tab点击埋点）C3501001

//v2.34
#define community_personal_tab                 @"C5001010"//社区动态首页-我的tab点击
#define community_content_share                @"C5003007"//动态-分享动态按钮
#define content_share                          @"C5004003"//动态详情页-右上角-分享
#define searchpage_booktab                     @"C1410001"//搜索页_读书tab
#define searchpage_booktab_book                @"C1410002"//搜索页_读书tab_点击书籍
#define detailpage_detailtab_tag               @"C0703005"//视频详情页-详情tab-视频标签
#define detailpage_catalog_recommend_video     @"C0702008"//视频详情页-有目录-推荐视频点击
#define detailpage_catalog_recommend_more      @"C0702009"//视频详情页-有目录-更多视频点击
#define detailpage_album_click                 @"C0702010"//视频详情页-专辑收录-点击查看
#define detailpage_taoke_copylink              @"C0702011"//视频详情页-超职套课-复制链接
#define careerpath_labeltab                    @"C3104001"//职业路径页_分类tab切换
//直播  
#define searchpage_livetab                     @"C1411001"//搜索页_直播课tab
#define searchpage_livetab_liveclass           @"C1411002"//搜索页_直播课tab_点击直播课
#define study_intoplaylist_livetab_liveclass   @"C1703007"//学习_已学教程列表_直播tab_点击直播课


// 2.35
#define community_carousel                    @"C5001010"//社区动态首页-轮播信息点击
#define community_ad1                         @"C5003007"//社区动态首页-广告位1
#define community_ad2                         @"C5003007"//社区动态首页-广告位2
#define community_content_moreanswer          @"C5003007"//社区动态首页-动态评论-共x条评论
#define community_message                     @"C5003007"//社区动态首页-消息中心
#define mytabpersonal_openVip                 @"C0904004"//我的tab-开通会员

#define personalcenter_bottom_banner          @"C0918001"//我的tab-底部会员广告
#define vippage_banner                        @"C1106001"//vip会员页-横幅广告
#define hukedushu_trial_buy                   @"C3301012"//虎课读书试听结束弹框-立即开通
#endif /* HukeDefine_h */


// 2.36
#define hukedushushouye_search            @"C3301013" //虎课读书详情页-搜索按钮
#define albumpage_search                  @"C1302002" //专辑详情页-搜索按钮
#define designarticlepage_search          @"C1303001" //设计文章-搜索入口
#define downloadpage_copylink             @"C0503001" //视频下载页-复制链接按钮
#define fenleiye_hukewangxiao_training    @"C0813004" //分类页-网校-训练营推荐（点击训练营）


//v2.37
#define detailpage_evaluate_task                    @"C0704005"  //视频详情页-评论tab-作业
#define detailpage_evaluate_question                @"C0704006"  //视频详情页-评论tab-提问
#define detailpage_evaluate_all_taskpic             @"C0704007"  //视频详情页-评论tab-全部-作业图片点击
#define detailpage_evaluate_all_copylink            @"C0704008"  //视频详情页-评论tab-全部-复制链接点击
#define shouye_guessyoulike_select_card             @"C0208004"  //首页-猜你喜欢-选择学习兴趣（卡片）
#define detailpage_screening_nextclass              @"C0701018"  //全屏视频详情页-下一节按钮点击






