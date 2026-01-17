
#import "MBProgressHUD.h"

typedef NS_ENUM(NSInteger, LMBProgressHUDStatus) {
    
    /** 成功 */
    LMBProgressHUDStatusSuccess,
    
    /** 失败 */
    LMBProgressHUDStatusError,
    
    /** 提示 */
    LMBProgressHUDStatusInfo,
    
    /** 等待 */
    LMBProgressHUDStatusWaitting
};

@interface HKProgressHUD : MBProgressHUD

/** 返回一个 HUD 的单例 */
+ (instancetype)sharedHUD;

/**
 *  在 window 上添加一个 HUD
 *
 *  显示时 不影响 其他操作
 *
 */
+ (void)showEnabledHUDStatus:(LMBProgressHUDStatus)status text:(NSString *)text;


/**
 *  在 window 上添加一个 HUD
 *
 *  显示时 禁止 其他操作
 *
 */
+ (void)showStatus:(LMBProgressHUDStatus)status text:(NSString *)text;

#pragma mark - 建议使用的方法

/** 在 window 上添加一个只显示文字的 HUD 2s消失 */
+ (void)showMessage:(NSString *)text;

/** 在 window 上添加一个只显示文字的 HUD 自定义延迟时间消失 */
+ (void)showMessage:(NSString *)text  afterDelay:(NSTimeInterval)afterDelay;

/** 在 window 上添加一个提示`信息`的 HUD */
+ (void)showInfoMsg:(NSString *)text;

/** 在 window 上添加一个提示`失败`的 HUD */
+ (void)showFailure:(NSString *)text;

/** 在 window 上添加一个提示`成功`的 HUD */
+ (void)showSuccess:(NSString *)text;

/** 在 window 上添加一个提示`等待`的 HUD, 需要手动关闭 */
+ (void)showLoading:(NSString *)text;

/** 手动隐藏 HUD */
+ (void)hide;

+ (void)hideAfterDelay:(NSTimeInterval)delay;


#pragma mark - 延迟2s 消失提示框
+ (void)showCustomViewMessage:(NSString *)text;

@end
