//
//  AppConst.h
//


#import <UIKit/UIKit.h>

// 0 -随系统  1- 强制
extern BOOL isFouceLight;

// 0 -- 正式服务器  1 -- 测试  2- 预发步
extern NSInteger hk_testServer;

extern  int secondLoad; //标记第二次打开APP

/** 侧滑 菜单栏 高度 */
extern  CGFloat const HKMMenuViewHeight;

/******************** Notification ********************/
extern NSString *const GoodsCountDidChangedNotification;

extern NSString *const ksaveAndUseAddressNotification;

extern NSString *const KsubmitOrderNotification;

extern NSString *const KdownloadCompleteNotification;

extern NSString *const KNetworkStatusNotification;

extern NSString *const HKSingleModelChangeNotification;

extern NSString *const KdownloadCount;

extern NSString *const KdownloadArray;

extern NSString *const KdownloadingChangeNotification;

extern NSString *const KLoginStatusNotification;

extern NSString *const KLookPermissionsNotification;

extern NSString *const KCommentLevelNotification;

//extern NSString *const KCommentSucessNotification; //评论成功
extern NSString *const KPlayCommentNotification;

extern NSString *const KAPPStatusNotification; // APP 状态

extern NSString *const KSortTagSelectedNotification;; // 筛选 确定

extern NSString *const KSortVideoCountNotification ;// 筛选 视频数量

extern NSString *const KResetPlayModelNotification;//重置播放数据模型

extern NSString *const KReplyCommentSucessNotification; //回复评论成功

extern NSString *const KLoginSucessNotification;//登录成功

extern NSString *const HKLogoutSuccessNotification;//注销成功

extern NSString *const KH5UrlNotification; //H5 URL

extern NSString *const KDeleteCommentSucessNotification; //删除评论

extern NSString *const HKPresentVCRefreshNotification; // 刷新签到页面

extern NSString *const HKCollectionVCRefreshNotification; // 刷新收藏页面

extern NSString *const HKLoginSuccessNotification; // 登录成功

extern NSString *const HKMineRedPointNotification; // 我的红点


extern NSString *const HKAllVipNotification;// 全站通VIP

extern NSString *const HKUserInfoChangeNotification;// 用户信息发送变化

extern NSString *const HKBindPhoneNumNotification;// 绑定手机号

extern NSString *const HKEditContainerTitleNotification;// 编辑合集名称

extern NSString *const KSearchSortTagSelectedNotification;// 搜索 筛选标签 确定

extern NSString *const KQuitOrCollectAlbumNotification;// 取消或者收藏 专辑

extern NSString *const KAlbumSortTagSelectedNotification;// 专辑 筛选

extern NSString *const KSearchResultCountNotification;// 搜索结果数量 更新菜单标题

extern NSString *const HKBuyVIPSuccessNotification; // 充值VIP成功

extern NSString *const KPlayNextVideoNotification ;// 播放下一个视频

extern NSString *const KPlayVideoScreenRotationNotification;// 播放全屏切换

extern NSString *const KShareVideoNotification;//  分享视频-> 解锁视频

extern NSString *const KRemoveGuidePageNotification;//  引导页移除

extern NSString *const HKSelectStudyTagNotification;//  选择学习兴趣

extern NSString *const HKSelectHomeTabTwiceNotification;//  首页tab第二次点击

extern NSString *const HKSelectTabItemIndexNotification;// 选择tab Item

extern NSString *const HKScreenShotSwitch;// 截屏开关
extern NSString *const HKPersonalRecommandSwitch;// 个性化推荐开关

extern NSString *const HKDeleteAlbumNotification;// 删除专辑

extern NSString *const HKCollectVideoNotification ;//视频详情 收藏视频

extern NSString *const HKAutoPlay; // 自动播放

extern NSString *const HKRatePlay; // 记住倍速

extern NSString *const HKPlayerPlayRate; // 倍速
/** 开启通知 */
extern NSString *const HKOpenNotification;
/** 关闭通知 */
extern NSString *const HKCloseNotification;
/** 添加专辑弹窗*/
extern NSString *const HKContainerListVCCloseOrShowNotification ;
/**首页 tab 短视频引导*/
extern NSString *const HKRemoveReadBookGuideViewNotification;
/**短视频 点赞 */
extern NSString *const HKShortVideoPraiseNotification;

/** 短视频 开始播放 */
extern NSString *const HKShortVideoStartPlayNotification;

/** 签到成功 */
extern NSString *const HKPresentResultNotification;

extern NSString *const HKPushAllLearnNotification;
///web浏览器跳转
extern NSString *const HKWebPushTargetVCNotification;



/** YES 显示 短视频 tab */
extern BOOL isShowShortVideoTab;

/** YES 使用流量观看  默认 NO */
extern BOOL isViaWWANPlayVideo;

/** YES 显示 短视频 限免tag */
extern BOOL isShowShortVideoFreeTag;

/** 流量开关*/
extern NSString *const HKGPRSSwitch;
/** 日历提醒开关*/
extern NSString *const HKCanlendarWitch;


/** YES - （更新 APP后打开） NO - （新下载打开） */
extern BOOL isUpdateAppLoad;

/** 支付宝 AppScheme */
extern NSString *const HKAliPayAppScheme;

/// 读书倍速
extern NSString *const HKBookPlayRateIndex;

/// 播放线路  1(七牛 默认七牛)  2(腾讯)
extern NSString *const HKVideoPlayerPlayLine;
