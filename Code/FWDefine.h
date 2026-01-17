//
//  FWDefine.h
//  Code
//
//  Created by pg on 16/3/8.
//  Copyright © 2016年 pg. All rights reserved.
//

#ifndef FWDefine_h
#define FWDefine_h




/**
 * SN_EXTERN user this as extern
 */
#if !defined(SN_EXTERN)
#  if defined(__cplusplus)
#   define SN_EXTERN extern "C"
#  else
#   define SN_EXTERN extern
#  endif
#endif



/**
 * 判断当前设备 1 模拟器  0 真机
 */
#if TARGET_IPHONE_SIMULATOR

#define SIMULATOR 1

#elif TARGET_OS_IPHONE

#define SIMULATOR 0

#endif





//国际化
#define L(key) \
[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]



#define BBAlertLeavel  300


//检测block是否可用
#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };

#define WeakSelf     __weak typeof (self) weakSelf = self;

#define StrongSelf   __strong typeof(weakSelf) strongSelf = weakSelf;



//#ifndef weakify
//#if DEBUG
//#if __has_feature(objc_arc)
//#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
//#else
//#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
//#endif
//#else
//#if __has_feature(objc_arc)
//#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
//#else
//#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
//#endif
//#endif
//#endif
//
//#ifndef strongify
//#if DEBUG
//#if __has_feature(objc_arc)
//#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
//#else
//#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
//#endif
//#else
//#if __has_feature(objc_arc)
//#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
//#else
//#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
//#endif
//#endif
//#endif






/*****************************   RGB  *****************************/
// 2.获得RGB颜色
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b,a)                      RGBA(r, g, b, a)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define navigationBarColor RGB(33, 192, 174,1.0)

#define themeColor [UIColor colorWithHexString:@"#252525"]]

//颜色创建
#undef  RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#undef  RGBACOLOR
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#undef    HEX_RGB
#define HEX_RGB(V)        [UIColor colorWithRGBHex:V]





/*****************************   UIImage  *****************************/

//#define imageName(a)      [UIImage alloc] initWithContentsOfFile:[[NSString alloc] initWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], a];

#define imageName(a) [UIImage imageNamed:a]

#define imageWithURL(a)    [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:a]]]
//#define UIColorA(_ref) [UIColor colorWith:_ref]

#define   HKURL(urlString)    [NSURL URLWithString:urlString]


/*****************************   SCREEN FRAME  *****************************/
#define SCREEN_W ( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ?[UIScreen mainScreen].bounds.size.width :[UIScreen mainScreen].bounds.size.height )
#define SCREEN_H ( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ?[UIScreen mainScreen].bounds.size.height :[UIScreen mainScreen].bounds.size.width )  //([UIScreen mainScreen].bounds.size.height)

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)  //([UIScreen mainScreen].bounds.size.height)

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define FRAME_WIDTH (self.view.frame.size.width)
#define FRAME_HEIGHT (self.view.frame.size.height)

#define MyNotification   [NSNotificationCenter defaultCenter]

#define Ratio    (SCREEN_WIDTH/375.0)  //屏幕比列 （6s参考）

#define iPadRatio    (SCREEN_WIDTH/768.0)  //屏幕比列 （9.7英寸参考）
#define iPadHRatio    (SCREEN_WIDTH/1024.0)  //屏幕比列 （9.7英寸参考）//:1024×768
#define iPadContentWidth    (SCREEN_WIDTH * 0.6)
#define iPadContentMargin    (SCREEN_WIDTH - iPadContentWidth) * 0.5  //屏幕比列 （9.7英寸参考）

/****************** 导航栏高度  ******************/

/****************** 导航栏高度  ******************/
#define isIOS7  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

//#define KNavBarHeight64 ( IS_IPHONE_X ? 88 : 64)
#define KNavBarHeight64 (IS_IPAD ? 70 : (IS_IPHONE_X ? 88: 64))
#define STATUS_BAR_EH (IS_IPHONE_X ? 44 : 20)
#define STATUS_BAR_XH (IS_IPHONE_X ? 24 : 0)
#define TAR_BAR_XH (IS_IPHONE_X ? 34 : 0)

#define KTabBarHeight49 ( IS_IPHONE_X ? 83 : 49)

//#define IS_IPHONEX (SCREEN_HEIGHT == 812.0f || SCREEN_HEIGHT == 896.0f)
//#define IS_IPHONE_X_Max (SCREEN_HEIGHT == 896.0f)
//#define NAVIGATION_H (IS_IPHONEX ? 88 : 64)
//#define NAVIGATION_CENTY (IS_IPHONEX ? 64 : 0)
//#define STATUS_BAR_EH (IS_IPHONEX ? 44 : 20)
//#define STATUS_BAR_XH (IS_IPHONEX ? 24 : 0)
//#define TAR_BAR_XH (IS_IPHONEX ? 34 : 0)
//#define TABBAR_HEIGHT (IS_IPHONEX ? 83 : 49)
//#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
//#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
//#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

//是否为iOS7
//#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define HKiOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)


/*****************************   PADDING FRAME  *****************************/
#define kWidth0  0
#define kHeight10  10
#define kWidth40 40
#define kHeight44  44
#define kHeight64  64
#define kHeight68  68
#define kHeight49  49
#define kHeight20  20
#define kHeight25  25
#define kHeight40  40
#define kHeight15  15
#define kHeight83  83


#define PADDING_5  5
#define PADDING_10 10
#define PADDING_15 15
#define PADDING_20 20
#define PADDING_25 25
#define PADDING_30 30
#define PADDING_35 35
#define PADDING_40 40
#define PADDING_100 100

#define PADDING_13 13

//通知配置列表
#define PushNoticeModelFile [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"pushNoticeModelArray.data"]


/*****************************   Font Size  *****************************/


#define HK_FONT(n,s)             [UIFont fontWithName:(n) size:(s)]  //自定义

#define HK_FONT_SYSTEM(s)        [UIFont systemFontOfSize:(s)]       //普通

#define HK_FONT_SYSTEM_BOLD(s)   [UIFont boldSystemFontOfSize:(s)]   //加粗

#define HK_FONT_SYSTEM_WEIGHT(s,w)     [UIFont systemFontOfSize:(s) weight:(w)]//字体 字重

// 显示time 由于普通字号 数字宽度的不相等
#define HK_TIME_FONT(s)     [UIFont timeFontWithFloat:(s)]



/*****************************   通知  *****************************/
#define HK_NOTIFICATION_ADD(n, f)      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(f) name:(n) object:nil]  //添加

#define HK_NOTIFICATION_ADD_OBJ(n, f, obj)  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(f) name:(n) object:(obj)]  //添加

#define HK_NOTIFICATION_POST(n, o)     [[NSNotificationCenter defaultCenter] postNotificationName:(n) object:(o)]  //发送

#define HK_NOTIFICATION_POST_DICT(n, o,dict)     [[NSNotificationCenter defaultCenter] postNotificationName:(n) object:(o) userInfo:(dict)]  //发送

#define HK_NOTIFICATION_REMOVE()       [[NSNotificationCenter defaultCenter] removeObserver:self]; //删除




/*****************************   屏幕尺寸  *****************************/

#define Iphone_35Inch_Width     320.0f
#define Iphone_40Inch_Width     320.0f
#define Iphone_47Inch_Width     375.0f
#define Iphone_55Inch_Width     414.0f
//像素1242x2208 在这个分辨率下渲染后，图像等比降低piexl分辨率至1080p(1080x1920)

#define Iphone_35Inch_Height    480.0f
#define Iphone_40Inch_Height    568.0f
#define Iphone_47Inch_Height    667.0f
#define Iphone_55Inch_Height    736.0f
#define Iphone_X_Height         812.0f
#define Iphone_ProMax_Height    926.0f

//刘海屏
#define IS_NotchScreen [UIApplication sharedApplication].windows[0].safeAreaInsets.bottom > 0

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_IPHONE_ProMax (IS_IPHONE && SCREEN_HEIGHT == Iphone_ProMax_Height)

#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ((NSInteger)(([[UIScreen mainScreen] currentMode].size.height/[[UIScreen mainScreen] currentMode].size.width)*100) == 216) : NO)


//#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define IS_IPHONE_XS (IS_IPHONE && SCREEN_HEIGHT > 736.0)

//(IS_IPHONE && ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ? ([[UIScreen mainScreen] bounds].size.height >= 812.0f) :([[UIScreen mainScreen] bounds].size.width >= 812.0f)))



#define IS_IPHONE6PLUS (SCREEN_WIDTH > Iphone_47Inch_Width)

#define IS_IPHONE5S (SCREEN_WIDTH <= Iphone_40Inch_Width)

// 大于4.7英寸的屏幕
#define IS_IPHONEMORE4_7INCH IS_IPHONE6PLUS || IS_IPAD || IS_IPHONE_X

#define IS_IPAD     [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad

#define HKSystemVersion    [[[UIDevice currentDevice] systemVersion] floatValue]

#define Font_Size_6     (IS_IPHONE6PLUS ? 22 : 18)
#define Font_6          [UIFont systemFontOfSize:Font_Size_6]


#define HKNSUserDefaults  [NSUserDefaults standardUserDefaults]

#define HKLUKeychainAccess [LUKeychainAccess standardKeychainAccess]


/*****************************   SAFE RELEASE  *****************************/
/*safe release*/
#undef TT_RELEASE_SAFELY
#define TT_RELEASE_SAFELY(__REF) \
{\
if (nil != (__REF)) \
{\
__REF = nil;\
}\
}




//view安全释放
#define TTVIEW_RELEASE_SAFELY(__REF) \
{\
if (nil != (__REF))\
{\
[__REF removeFromSuperview];\
__REF = nil;\
}\
}



//释放定时器
#define TT_INVALIDATE_TIMER(__TIMER) \
{\
[__TIMER invalidate];\
__TIMER = nil;\
}







/*****************************   login  *****************************/

#define LOGIN_NAME  @"userNameForLogin"
#define LOGIN_PWD   @"passwordForLogin"
#define USER_ID     @"userId"
#define LOGIN_TOKEN @"token"

#define LOGIN_VIP_TYPE @"vipType"

#define SING_TYPE   @"sign_type"

#define SING_CONTINUE_NUM   @"sign_continue_num"


//#define LOGIN_SIGN_TYPE @"signType"

#define TOURIST_VIP_TYPE @"touristVipType"

#define LOGIN_AVATOR  @"avator"

#define LOGIN_PHONE  @"phone"


#define TOUURIST_VIP_STATUS  @"TOUURIST_VIP_STATUS" //记录游客身份时VIP状态

#define APP_PassWord  @"APP_PassWord"

#define APP_VERSION  @"APP_VERSION"


//密码输入长度小于6位或者大于20位
#define EM_Password_Length              @"密码需要6-20位长哟"


#define K_str_emptyPassword       @"密码空空如也"
#define K_str_lessSix             @"密码长度少于6位"
#define K_Str_RegisterNoCommon            @"两次密码不一致"


#define K_str_rightPhoneNum       @"请输入正确的手机号格式 "
#define K_str_inputPhoneNum       @"请输入手机号"
#define K_str_input_password     @"请输入密码"

#define K_str_login     @"登录"
#define K_str_want_register    @"我要注册"
#define K_str_forgot_password  @"忘记密码"
#define K_str_quickLogin       @"快速登录"

//#define K_str_quickRegister    @"手机快速注册"

#define K_str_inputAuthCode    @"请输入验证码"



/***********************  登录限制提示  ***********************/

#define REMOTE_LOGIN   @"您的账号已在别处登录，如非本人操作请立即重新登录哦~"

#define TOO_MANY_LOGIN  @"登录太频繁可能会导致封号哦~请验证绑定手机，才能登录成功~"

#define LIMIT_TOO_MANY_LOGIN  @"您账号近期频繁登录，今日已无法登录，请明日再来学习哦~若非您本人操作，建议及时修改账号密码"


/***********************  alertView dialog  *****************************/
#undef  alertView_quit
#define alertView_quit           @"取消"

#undef  alertView_sure
#define alertView_sure           @"确定"



//alipay
//APPID: 2016011201086883
//APP SECRET: e5e410e6afc042e286301f03963316d5
//pid ：2088121518485690  收款账号： tt@techsun.com.cn

#define aliPayKey @"//MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDXYUPvRiP/hQj4nrzCI5h8NQpNJKmhhECv2711V5kFoeVddAXEVmKCz03t4H8f7CGh2l5qzGeC/YxwdE5O8upbgfBfT54VF4r/FavR1OF3XxsXf3qPq3+TFZkDjB5qUFV0+Zrit1sGeOdTueIK4npISe+bHgpO9QTJb0UnqGORTQIDAQAB"





/****************  状态栏 背景 ********************/
#define  HKStatusBarStyleLightContent    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

#define  HKStatusBarStyleDefault     if (@available(iOS 13.0, *)) {[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;} else {[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;}





#define HKAdjustsScrollViewInsetNever(controller,view) self.extendedLayoutIncludesOpaqueBars = YES; if(@available(iOS 11.0, *)) {view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;} else if([controller isKindOfClass:[UIViewController class]]) {controller.automaticallyAdjustsScrollViewInsets = false;}



/**************** DEBUG LOG ****************/
#ifdef DEBUG
#define NSLog( s, ... ) NSLog( @"< %@:(%d) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define NSLog( s, ... )
#endif


#endif /* FWDefine_h */

