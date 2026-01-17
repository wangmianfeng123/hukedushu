//
//  FWCommonMain.h
//  FamousWine
//
//  Created by pg on 15/11/13.
//  Copyright © 2015年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
//#include "MBProgressHUD.h"
#import "MBProgressHUD.h"


@class HKUserModel ,HKStudyTagModel;

@interface CommonFunction : NSObject

@property(nonatomic,strong)__block  MBProgressHUD *HUD;


/**
 *
 *  判断字符串是否为空或只有空格
 *  @param str
 *
 */
BOOL isEmpty(id str);

/**
 *
 *
 *  判断网络数据字符串是否为空
 *
 *
 */
BOOL isBlankString (NSString *string);


/**
 *
 *
 *  检测手机号码是否合法
 *
 *
 */
BOOL validateMobileNo (NSString * mobileNo);

/**
 *将手机号 中间四位 用****代替
 */
+ (NSString *)phoneNumToAsterisk:(NSString*)phoneNum;

/**
 *
 *
 *  当前视图提示框
 *
 *
 */
//void showWarningDialog (NSString * strText, UIView* view );

void showWarningDialog (NSString * strText, UIView* view ,int time);

/**
 *
 *
 *  窗口视图提示框
 *  显示 2s
 *
 */
void showTipDialog(NSString * strText);

/**
 *
 *
 *  窗口视图提示框，基于showTipDialog偏移量
 *  显示 2s
 *
 */
void showOffsetTipDialog(NSString * strText, CGPoint offsetPoint);

/**
 *
 *
 *  窗口视图提示框
 *  显示时间 delaySecond
 *  leftAndRightMargin 左右 margin 
 */
void showCustomViewDialogWithText(NSString * strText,int delaySecond,CGFloat leftAndRightMargin);


void tb_showTipDialogTitle(NSString * strText, NSString *detailText);

/**
 *
 *
 *  警告提示
 *
 *
 */
void showWaitingDialogWithStr(NSString * strText);

void tb_showWaitingDialogWithStr (NSString * strText);

/**
 *
 *
 *  添加提示框到指定视图
 *
 *
 */
void showWaitingDialogWithView (NSString * strText, UIView *View);


/**
 *
 *
 *  正在加载提示
 *
 *
 */
void showWaitingDialog();



/**
 *
 *
 *  关闭正在加载提示
 *
 *
 */
void closeWaitingDialog();




/**
 *
 *
 *  关闭文本提示
 *
 *
 */
void closeshowTextDialog ();



/**
 *
 *
 *  检测密码长度
 *
 *
 */
BOOL checkPassword (NSString *str_Password);


/**
 *
 *
 *  检测手机号码的是否合法
 *
 *
 */

BOOL isCorrectPhoneNo (NSString *str_TempPhone);


/**
 *
 *
 *  圆形进度条
 *
 *
 */

void showProgress();


/**
 *
 *
 *  移除圆形进度条
 *
 *
 */
void hideProgress();

UIImage *resizableImageOfImage(UIImage *image);


void addGoodDialog(NSString * strText);

/**
 *
 *限定宽度 ，行间距，计算字符串 所占的高度
 */
- (void)stringHeight:(NSString*)String;

/**
 获取app版本号

 @return app版本号
 */
+ (NSString*)appCurVersion;


/**
 保存用户登录信息用于默认登录

 @param userName
 @param password
 */

void userDefaultsWithModel(HKUserModel *model);// __attribute__((deprecated("请使用 [HKAccountTool saveOrUpdateAccount:]")));

#pragma mark - 获得用户手机号
+ (NSString*)getUserPhoneNo;// __attribute__((deprecated("请使用 [HKAccountTool shareAccount]")));

#pragma mark - 获得用户ID
+ (NSString*)getUserId ;//__attribute__((deprecated("请使用 [HKAccountTool shareAccount]")));


#pragma mark - 获得用户token
+ (NSString*)getUserToken; //__attribute__((deprecated("请使用 [HKAccountTool shareAccount]")));

#pragma mark - 判断是否登录  返回NO - 未登录  YES - 登录
BOOL isLogin();// __attribute__((deprecated("请使用 [HKAccountTool shareAccount]")));



void signOut(); //__attribute__((deprecated("请使用 [HKAccountTool deleteAccount]")));
/**
 获取手机剩余空间

 @param NSString
 @return
 */
+ (void)freeDiskSpaceInBytes:(void(^)(unsigned long long space))freeDiskBlock;


#pragma mark - 后台系统版本
void systemVersion(NSString *Version);

#pragma mark - 获得后台系统版本
+ (NSString*)getVersionCode;



#pragma mark - 获取文件夹目录
+ (NSString *)getLocalUrlWithVideoUrl:(NSString *)videoUrl;


+ (NSString *)getM3U8LocalUrlWithVideoUrl:(NSString *)videoUrl;

#pragma mark - 获取设备信息
+ (NSString*)getUUIDString;

#pragma mark - 获取 IDFA
+ (NSString*)getIDFAString;

#pragma mark - 获取 CAID
+ (NSString*)getCAIDString;

#pragma mark - 游客 是否是VIP  1- VIP  否则非VIP
+ (void) setTouristVIPStatus;

#pragma mark - 获得用户ID
+ (NSString*)getTouristVIPStatus;

#pragma mark - 查询是否是 APP状态
+ (void)checkAPPStatus;


+ (void)checkAPPStatus:(void(^)())sureAction;

#pragma mark - 获得  APP状态 1--线下状态
+ (NSString*)getAPPStatus;


/**
  统计用户登录人数 当天第一次打开，并且是已登录状态,

 @return
 */
+ (void)recordUserLoginCount;



/**
 更新后 第一次打开

 @return 
 */
+ (BOOL)isUpdateAppFirstLoad;


/**
 第一次打开 APP

 @return YES - 第一次打开 APP
 */
+ (BOOL) isFirstLoad;


/**
 第一次打开 APP
 
 @return YES - 第二次打开 APP
 */
+ (BOOL) isSecondLoad;


/**
 是否 当天 第一次打开 APP
 
 @return
 */
+ (BOOL)isFirstLoadOfDay;

/**
 *获得 UUID 并 将UUID 保存到钥匙串(UUID 经过MD5加密)
 */
+ (NSString*)getUUIDFromKeychain;

/**
 *跳转到虎课APP 系统设置
 */
+ (void)jumpToAPPSetting;

/**
 *七天 提醒一次 跳转到虎课APP 系统设置
 */
+ (void)jumpToAPPSetForSevenDay;

/**
 * 跳转通知 设置
 */
+ (void)openNotificationSetting;

/**
 YES - 已开启通知
 */
+ (BOOL)isOpenNotificationSetting;

/**
 * 保存服务器APP版本
 */
+ (NSString *)getServerVersion;

/**
 * 获取服务器APP版本
*/
+ (void)saveServerVersion:(NSString *)version;

/**
 *将 记录保存到 钥匙串中 记录是否是第一次下载APP
 */
+ (BOOL)isFistDownload;


/**
 *保存到钥匙串中 记录 新手礼包已经不是 第一次下载APP
 */
+ (BOOL)setFistGiftKeychain;

/**
 * 保存到钥匙串中 记录 新手礼包 是否第一次下载APP
 */
+ (BOOL)isFistGiftDownload;


/**
 *  YES - 显示开屏广告
 */
+ (BOOL)isNeedShowADWindow;


/**
 *获取不带 版本号的 主路径
 */
+ (NSString*)getBaseUrl;


/**
 *保存学习兴趣标签
*/
+ (void)saveStudyTagWithArray:(NSMutableArray*)studyTagArr;

/**
 * 获取学习兴趣标签
 */
+ (NSMutableArray<HKStudyTagModel*>*)getStudyTagArr;

/** YES 最新APP版本 */
+ (BOOL)isLatestVersion;


/**
 跳转到 tab 页控制器

 currectVC -- 当前控制器 (如果当前控制器 是tab页 则传 nil)
 
 @param currectVC : 当前控制器
 @param index :tab index
 */
+ (void)pushTabVCWithCurrectVC:(UIViewController *)currectVC index:(NSUInteger)index;


/**
  计算 文本高度

 @param mess 文本
 @param font 字体
 @param lineSpacing 行间距
 @param width 宽度 （默认屏幕宽度）
 @return
 */
+ (CGFloat)getTextHeight:(NSString *)mess font:(UIFont*)font lineSpacing:(CGFloat)lineSpacing  width:(CGFloat)width;


+ (CGFloat)getTextWidth:(NSString *)mess font:(UIFont*)font lineSpacing:(CGFloat)lineSpacing  width:(CGFloat)width;



/** 计算 文本行数 */
+ (NSInteger)getTextRow:(NSString *)mess font:(UIFont*)font lineSpacing:(CGFloat)lineSpacing  width:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;

/** 当前控制器 */
+ (UIViewController *)topViewController;

/**
 *
 * base url
 */
+ (NSString *)HK_BaseUrl;

+ (NSString *)HK_BaseUrl_Channl ;

/// 返回 不带 V5 的 URL
+ (NSString *)HK_BaseUrl_NO_V5;

/**
 拨打客服电话

 @param phoneNum
 */
+ (void)callServiceWithPhone:(NSString*)phoneNum;


/**
 播放器 dialog

 @param text 提示文案
 @param targetView 目标 view
 @param delay 显示时间
 */
void playerShowDialog (NSString *text, UIView *targetView,NSTimeInterval delay);

/** 第一次启动 短视频引导 */
+ (BOOL)isReadBookGuideView;
+ (void)setReadBookGuideView:(BOOL)yes;


+ (void)setKeyChainObject:(id)key value:(id)value;

+ (id)getKeyChainObject:(id)key;


/** 日期时间戳改为几分钟前... */
+ (NSString *)timeFromNow:(NSString *)str;


/**
 推广渠道
 
 @return 推广渠道名
 */
+ (NSString*)getHKChannel;
+ (NSString*)getXHSCaid ;
+ (NSString*)getXHSClickid ;
+ (NSString*)getXHSpaid;
+ (NSString*)getXHScaid_md5;

/**
 存储 推广渠道 名
 
 @param channel 渠道名
 */
+ (void)setHKChannelWithName:(NSString*)channel;
+ (void)setXHSCaidWithName:(NSString*)caid ;
+ (void)setXHSClickidWithName:(NSString*)clickid ;
+ (void)setXHScaid_md5WithName:(NSString*)clickid ;
//+ (void)setXHSpaidWithName:(NSString*)clickid ;

+ (BOOL)detalResponse:(id)responseObject;

/**
 获取根控制器
 */
+ (UIViewController *)getRootViewController;

//运营商名称
+ (NSString *)carrierInfo;

/**
 不重复的随机数
 */
+ (NSString * )makeRandomNumber;

+ (void)requestTrackingAuthorization;

//设备的初始化时间
+ (NSString *)getDeviceUptime;
//系统启动时间
+ (NSString *)getSysB ;

// 系统更新时间
+ (NSString *)getSysU ;

@end




