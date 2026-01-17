//
//  AppConst.m
//


#import <UIKit/UIKit.h>

BOOL isFouceLight = 0;

NSInteger hk_testServer = 1;

int secondLoad = 0; //标记第二次打开APP

CGFloat const HKMMenuViewHeight = 50.0;



NSString *const GoodsCountDidChangedNotification = @"GoodsCountDidChangedNotification";

//NSString *const ksaveAndUseAddressNotification = @"SaveAndUseAddressNotification";

NSString *const KdownloadCompleteNotification = @"DownloadCompleteNotification";

NSString *const KdownloadingChangeNotification = @"DownloadCompleteNotification";

NSString *const HKSingleModelChangeNotification = @"HKSingleModelChangeNotification";// 单个下载通知

NSString *const KdownloadCount = @"downloadCount";

NSString *const KdownloadArray = @"KdownloadArray";

NSString *const KsubmitOrderNotification = @"SubmitOrderNotification";

NSString *const KNetworkStatusNotification = @"NetworkStatusNotification"; //网络改变通知

NSString *const KLoginStatusNotification = @"KLoginStatusNotification";  //用户VIP类型

NSString *const KLookPermissionsNotification = @"KLookPermissionsNotification";

NSString *const KCommentLevelNotification = @"KCommentLevelNotification";

NSString *const KPlayCommentNotification = @"KPlayCommentNotification";  //评论框弹出

NSString *const KAPPStatusNotification = @"KAPPStatusNotification";// APP 状态

NSString *const KSortTagSelectedNotification = @"KSortTagSelectedNotification";// 筛选 确定

NSString *const KSortVideoCountNotification = @"KSortVideoCountNotification";// 筛选 视频数量

NSString *const KResetPlayModelNotification = @"KResetPlayModelNotification";//重置播放数据模型

NSString *const KReplyCommentSucessNotification = @"KReplyCommentSucessNotification";//回复评论成功

NSString *const KLoginSucessNotification = @"KLoginSucessNotification";//登录成功

NSString *const KH5UrlNotification = @"KH5UrlNotification";//H5 URL

NSString *const KDeleteCommentSucessNotification = @"KDeleteCommentSucessNotification";//删除评论成功

NSString *const HKPresentVCRefreshNotification = @"HKPresentVCRefreshNotification";// 刷新签到页面

NSString *const HKCollectionVCRefreshNotification = @"HKCollectionVCRefreshNotification";// 刷新收藏页面

NSString *const HKLoginSuccessNotification = @"HKLoginSuccessNotification";// 登录成功

NSString *const HKMineRedPointNotification = @"HKMineRedPointNotification";// 红点

NSString *const HKLogoutSuccessNotification = @"HKLogoutSuccessNotification";// 注销账号成功

NSString *const HKBuyVIPSuccessNotification = @"HKBuyVIPSuccessNotification";// 充值VIP成功

NSString *const HKAllVipNotification = @"HKAllVipNotification";// 全站通VIP

NSString *const HKUserInfoChangeNotification = @"HKUserInfoChangeNotification";// 用户信息发送变化

NSString *const HKBindPhoneNumNotification = @"HKBindPhoneNumNotification";// 绑定手机号

NSString *const HKEditContainerTitleNotification = @"HKEditContainerTitleNotification";// 编辑合集名称

NSString *const KSearchSortTagSelectedNotification = @"KSearchSortTagSelectedNotification";// 搜索 筛选标签 确定

NSString *const KQuitOrCollectAlbumNotification = @"KQuitOrCollectAlbumNotification";// 取消或者收藏 专辑

NSString *const KAlbumSortTagSelectedNotification = @"KAlbumSortTagSelectedNotification";// 专辑 筛选

NSString *const KSearchResultCountNotification = @"KSearchResultCountNotification";// 搜索结果数量 更新菜单标题

NSString *const KPlayNextVideoNotification = @"KPlayNextVideoNotification";// 播放下一个视频

NSString *const KPlayVideoScreenRotationNotification = @"KPlayVideoScreenRotationNotification";// 播放全屏切换

NSString *const KShareVideoNotification = @"KPlayVideoScreenRotationNotification";//  分享视频-> 解锁视频

NSString *const KRemoveGuidePageNotification = @"KRemoveGuidePageNotification";//  引导页移除

NSString *const HKSelectStudyTagNotification = @"HKSelectStudyTagNotification";//  选择学习兴趣

NSString *const HKSelectHomeTabTwiceNotification = @"HKSelectHomeTabTwiceNotification";//  首页tab第二次点击

NSString *const HKSelectTabItemIndexNotification = @"HKSelectTabItemIndexNotification";// 选择tab Item

NSString *const HKScreenShotSwitch = @"HKScreenShotSwitch";// 截屏开关

NSString *const HKPersonalRecommandSwitch = @"HKPersonalizationRecommandSwitch";// 个性化推荐开关


NSString *const HKDeleteAlbumNotification = @"HKDeleteAlbumNotification";// 删除专辑


NSString *const HKCollectVideoNotification = @"HKCollectVideoNotification";//视频详情 收藏视频

NSString *const HKAutoPlay = @"HKAutoPlay"; // 自动播放

NSString *const HKRatePlay = @"HKRatePlay"; // 记住倍速

NSString *const HKPlayerPlayRate = @"HKPlayerPlayRate"; // 倍速


NSString *const HKOpenNotification = @"HKOpenNotification"; //开启通知

NSString *const HKCloseNotification = @"HKCloseNotification"; //关闭通知

NSString *const HKContainerListVCCloseOrShowNotification = @"HKContainerListVCCloseOrShowNotification"; // 添加专辑弹窗

NSString *const HKRemoveReadBookGuideViewNotification = @"HKRemoveReadBookGuideViewNotification";//  首页 tab 短视频引导

NSString *const HKShortVideoPraiseNotification = @"HKShortVideoPraiseNotification";//短视频 点赞

NSString *const HKShortVideoStartPlayNotification = @"HKShortVideoStartPlayNotification"; //短视频 开始播放

NSString *const HKPresentResultNotification = @"HKPresentResultNotification"; /** 签到成功 */

NSString *const HKPushAllLearnNotification = @"HKPushAllLearnNotification"; /** 签到页跳转学习 */

NSString *const HKWebPushTargetVCNotification = @"HKWebPushTargetVCNotification"; //web浏览器跳转


BOOL isShowShortVideoTab = NO;

BOOL isViaWWANPlayVideo = NO;

BOOL isShowShortVideoFreeTag = NO;


NSString *const HKGPRSSwitch  = @"HKGPRSSwitch";// 流量开关
NSString *const HKCanlendarWitch  = @"RemindMeMarkBtn";// 事务提醒开关

BOOL isUpdateAppLoad = NO;


NSString *const HKAliPayAppScheme = @"HuKeWangAliPay";

/// 读书倍速
NSString *const HKBookPlayRateIndex = @"HKBookPlayRateIndex";

/// 播放线路
NSString *const HKVideoPlayerPlayLine = @"HKVideoPlayerPlayLine";
