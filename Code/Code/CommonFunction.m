//
//  FWCommonMain.m
//  FamousWine
//
//  Created by pg on 15/11/13.
//  Copyright © 2015年 pg. All rights reserved.
//

#import "CommonFunction.h"
#import "MRProgress.h"
#include <sys/param.h>
#include <sys/mount.h>
#import "DownloadManager.h"
#import "HomeServiceMediator.h"
#import "DateChange.h"
#import <LUKeychainAccess/LUKeychainAccess.h>
#import "NSString+MD5.h"
#import "HKStudyTagModel.h"
#import "AppDelegate.h"
#import <CYLTabBarController/CYLTabBarController.h>
#import <YYText/YYText.h>
#import <AdSupport/AdSupport.h>
#import "HKCustomMarginLabel.h"
#import "HKAdWindow.h"
#import "HKOpenPushView.h"


#import <sys/sysctl.h>
#import <UIKit/UIDevice.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <CommonCrypto/CommonDigest.h>
#import <AppTrackingTransparency/ATTrackingManager.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <sys/stat.h>



/** 标记 第二次打开APP */
#define  HK_SecondLoad  @"HK_SecondLoad"
#define CAID_VERSION @"00"


static  MBProgressHUD *mbStaticProgressHUD;
static  MBProgressHUD *HUD;

static MRActivityIndicatorView *activityIndicatorView;


@implementation CommonFunction



//判读是否为空或输入只有空格
BOOL isEmpty(id str){
    
    //
    if ([str isKindOfClass:[NSString class]]) {
        if (!str)
        {
            return YES;
        }
        else{
            NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
            NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
            
            if ([trimedString length] == 0)
            {
                return YES;
            }
            else{
                return NO;
            }
        }
        
        // 数值
    }else if ([str isKindOfClass:[NSNumber class]]) {
        return str == 0;
        
    }else if ([str isKindOfClass:[NSNull class]]) {
        return YES;
        
    }else if ([str isEqual:[NSNull null]]) {
        return YES;
        
    }else {
        return YES;
    }
    
}


static BOOL readBookGuideView = NO;
+ (BOOL)isReadBookGuideView{
    return readBookGuideView;
}

+ (void)setReadBookGuideView:(BOOL)yes {
    readBookGuideView = yes;
}


BOOL validateMobileNo (NSString * mobileNo)
{
    NSString *mobileNoRegex = @"1[0-9]{10,10}";
    NSPredicate *mobileNoTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileNoRegex];
    return [mobileNoTest evaluateWithObject:mobileNo];
}



/** 将手机号 中间四位 用****代替 */
+ (NSString *)phoneNumToAsterisk:(NSString*)phoneNum {
    if (isEmpty(phoneNum)) {
        return nil;
    }
    NSUInteger length = phoneNum.length;
    if (length > 11) {
        return [phoneNum stringByReplacingCharactersInRange:NSMakeRange(5,4) withString:@"****"];
    }else if(11 == length){
        return [phoneNum stringByReplacingCharactersInRange:NSMakeRange(3,4) withString:@"****"];
    }else{
        return phoneNum;
    }
}





BOOL isBlankString (NSString *string)
{
    
    if (string == nil || string == NULL )
    {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        
        return YES;
    }
    return NO;
}







void showWarningDialog (NSString * strText, UIView* view ,int time)
{
    if (isEmpty(strText)) {
        return;
    }
    __block MBProgressHUD *mbProgressHUD = nil;
    
    mbProgressHUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:mbProgressHUD];
    mbProgressHUD.label.text = strText;
    mbProgressHUD.mode = MBProgressHUDModeText;
    mbProgressHUD.label.font = [UIFont systemFontOfSize: (IS_IPHONE6PLUS ? 15:14)];
    mbProgressHUD.yOffset = -SCREEN_HEIGHT/10;
    
    mbProgressHUD.bezelView.color = [UIColor blackColor];
    mbProgressHUD.bezelView.alpha = 0.5f;
    mbProgressHUD.contentColor = [UIColor whiteColor];
    
    [mbProgressHUD showAnimated:YES];
    [mbProgressHUD setRemoveFromSuperViewOnHide:YES];
    [mbProgressHUD hideAnimated:YES afterDelay:time];
}





void showCustomViewDialogWithText(NSString * strText,int delaySecond,CGFloat leftAndRightMargin) {
    
    if (isEmpty(strText)) {
        return;
    }
    
    TTVIEW_RELEASE_SAFELY(mbStaticProgressHUD);
    
    mbStaticProgressHUD = [[MBProgressHUD alloc] initWithView:[[[UIApplication sharedApplication] delegate] window]];
    [[[[UIApplication sharedApplication]delegate]window] addSubview:mbStaticProgressHUD];
    mbStaticProgressHUD.layer.zPosition =  INT8_MAX;
    
    mbStaticProgressHUD.bezelView.color = [UIColor blackColor];
    mbStaticProgressHUD.bezelView.alpha = 0.5f;
    mbStaticProgressHUD.contentColor = [UIColor whiteColor];
    mbStaticProgressHUD.mode = MBProgressHUDModeCustomView;
    
    HKCustomMarginLabel *marginLabel = [[HKCustomMarginLabel alloc] init];
    
    //mbStaticProgressHUD 默认 margin 20
    if (leftAndRightMargin != 0 ) {
        if (leftAndRightMargin >20) {
            marginLabel.textInsets = UIEdgeInsetsMake(0, leftAndRightMargin-20, 0, leftAndRightMargin-20);
        }
    }
    [marginLabel setTextColor:[UIColor whiteColor]];
    marginLabel.font = HK_FONT_SYSTEM( (IS_IPHONE6PLUS ? 15:14));
    marginLabel.textAlignment = NSTextAlignmentCenter;
    marginLabel.numberOfLines = 0;
    marginLabel.text = strText;
    
    mbStaticProgressHUD.customView = marginLabel;
    mbStaticProgressHUD.userInteractionEnabled = NO;
    
    mbStaticProgressHUD.yOffset = -SCREEN_HEIGHT/10;
    
    [mbStaticProgressHUD showAnimated:YES];
    [mbStaticProgressHUD setRemoveFromSuperViewOnHide:YES];
    [mbStaticProgressHUD hideAnimated:YES afterDelay:delaySecond];
}





void showTipDialog(NSString * strText) {
    
    if (isEmpty(strText)) {
        return;
    }
    NSLog(@"-------");
    
    if (mbStaticProgressHUD!=nil){
        [mbStaticProgressHUD hideAnimated:YES];
        mbStaticProgressHUD=nil;
    }
    
    mbStaticProgressHUD = [[MBProgressHUD alloc] initWithView:[[[UIApplication sharedApplication] delegate] window]];
    
    [[[[UIApplication sharedApplication]delegate]window] addSubview:mbStaticProgressHUD];
    mbStaticProgressHUD.layer.zPosition = INT8_MAX;
    
    mbStaticProgressHUD.bezelView.color = [UIColor blackColor];
    mbStaticProgressHUD.bezelView.alpha = 0.5f;
    mbStaticProgressHUD.label.numberOfLines = 0;
    mbStaticProgressHUD.contentColor = [UIColor whiteColor];
    
    mbStaticProgressHUD.label.text = strText;
    mbStaticProgressHUD.label.font = [UIFont systemFontOfSize: (IS_IPHONE6PLUS ? 15:14)];
    mbStaticProgressHUD.mode = MBProgressHUDModeText;
    
    mbStaticProgressHUD.userInteractionEnabled = NO;
    
    mbStaticProgressHUD.yOffset = -SCREEN_HEIGHT/10;
    
    [mbStaticProgressHUD showAnimated:YES];
    [mbStaticProgressHUD setRemoveFromSuperViewOnHide:YES];
    [mbStaticProgressHUD hideAnimated:YES afterDelay:3];
    
}

void showOffsetTipDialog(NSString * strText, CGPoint offsetPoint) {
    if (isEmpty(strText)) {
        return;
    }
    
    if (mbStaticProgressHUD!=nil){
        [mbStaticProgressHUD hideAnimated:YES];
        mbStaticProgressHUD=nil;
    }
    
    mbStaticProgressHUD = [[MBProgressHUD alloc] initWithView:[[[UIApplication sharedApplication] delegate] window]];
    [[[[UIApplication sharedApplication]delegate]window] addSubview:mbStaticProgressHUD];
    mbStaticProgressHUD.layer.zPosition = INT8_MAX;
    
    mbStaticProgressHUD.bezelView.color = [UIColor blackColor];
    mbStaticProgressHUD.bezelView.alpha = 0.5f;
    mbStaticProgressHUD.label.numberOfLines = 0;
    mbStaticProgressHUD.contentColor = [UIColor whiteColor];
    
    mbStaticProgressHUD.label.text = strText;
    mbStaticProgressHUD.label.font = [UIFont systemFontOfSize: (IS_IPHONE6PLUS ? 15:14)];
    mbStaticProgressHUD.mode = MBProgressHUDModeText;
    
    mbStaticProgressHUD.userInteractionEnabled = NO;
    
    //    mbStaticProgressHUD.yOffset = -SCREEN_HEIGHT/10;
    mbStaticProgressHUD.offset = offsetPoint;
    [mbStaticProgressHUD showAnimated:YES];
    [mbStaticProgressHUD setRemoveFromSuperViewOnHide:YES];
    [mbStaticProgressHUD hideAnimated:YES afterDelay:2];
}




void tb_showTipDialogTitle(NSString * strText, NSString *detailText)
{
    if (isEmpty(strText)) {
        return;
    }
    if (mbStaticProgressHUD!=nil)
    {
        [mbStaticProgressHUD hideAnimated:YES];
        mbStaticProgressHUD=nil;
    }
    
    mbStaticProgressHUD = [[MBProgressHUD alloc] initWithView:[[[UIApplication sharedApplication] delegate] window]];
    [[[[UIApplication sharedApplication]delegate]window] addSubview:mbStaticProgressHUD];
    mbStaticProgressHUD.layer.zPosition =  INT8_MAX;
    
    mbStaticProgressHUD.bezelView.color = HKColorFromHex(0xeeeeee, 1.0);
    mbStaticProgressHUD.bezelView.alpha = 0.9f;
    mbStaticProgressHUD.label.numberOfLines = 0;
    mbStaticProgressHUD.detailsLabel.numberOfLines = 0;
    mbStaticProgressHUD.contentColor = [UIColor blackColor];
    
    mbStaticProgressHUD.label.text = strText;
    mbStaticProgressHUD.label.font = [UIFont systemFontOfSize: (IS_IPHONE6PLUS ? 17:16) weight:UIFontWeightBold];
    mbStaticProgressHUD.detailsLabel.text = detailText;
    mbStaticProgressHUD.detailsLabel.font = [UIFont systemFontOfSize: (IS_IPHONE6PLUS ? 15:14)];
    mbStaticProgressHUD.mode = MBProgressHUDModeText;
    mbStaticProgressHUD.yOffset = -SCREEN_HEIGHT/ 20;
    
    [mbStaticProgressHUD showAnimated:YES];
    [mbStaticProgressHUD setRemoveFromSuperViewOnHide:YES];
    [mbStaticProgressHUD hideAnimated:YES afterDelay:2];
}





void addGoodDialog(NSString * strText) {
    
    [UILabel showStats:@"添加成功" atView:[[[UIApplication sharedApplication] delegate] window]];
}





void showWaitingDialogWithStr (NSString * strText)
{
    if (isEmpty(strText)) {
        return;
    }
    if (mbStaticProgressHUD!=nil)
    {
        [mbStaticProgressHUD hideAnimated:YES];
        mbStaticProgressHUD=nil;
    }
    mbStaticProgressHUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:mbStaticProgressHUD];
    mbStaticProgressHUD.label.text = strText;
    mbStaticProgressHUD.mode = MBProgressHUDModeText;
    mbStaticProgressHUD.yOffset = -SCREEN_HEIGHT/12;
    
    mbStaticProgressHUD.bezelView.color = [UIColor blackColor];
    mbStaticProgressHUD.bezelView.alpha = 0.5f;
    mbStaticProgressHUD.label.numberOfLines = 0;
    mbStaticProgressHUD.contentColor = [UIColor whiteColor];
    [mbStaticProgressHUD showAnimated:YES];
}

void tb_showWaitingDialogWithStr (NSString * strText)
{
    if (isEmpty(strText)) {
        return;
    }
    if (mbStaticProgressHUD!=nil)
    {
        [mbStaticProgressHUD hideAnimated:YES];
        mbStaticProgressHUD=nil;
    }
    mbStaticProgressHUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:mbStaticProgressHUD];
    mbStaticProgressHUD.label.text = strText;
    mbStaticProgressHUD.mode = MBProgressHUDModeIndeterminate;
    mbStaticProgressHUD.yOffset = -SCREEN_HEIGHT/12;
    
    mbStaticProgressHUD.bezelView.color = [UIColor blackColor];
    mbStaticProgressHUD.bezelView.alpha = 0.5f;
    mbStaticProgressHUD.label.numberOfLines = 0;
    mbStaticProgressHUD.contentColor = [UIColor whiteColor];
    [mbStaticProgressHUD showAnimated:YES];
}


void showWaitingDialogWithView (NSString * strText, UIView *View)
{
    if (isEmpty(strText)) {
        return;
    }
    if (mbStaticProgressHUD!=nil)
    {
        [mbStaticProgressHUD hideAnimated:YES];
        mbStaticProgressHUD=nil;
    }
    mbStaticProgressHUD = [[MBProgressHUD alloc] initWithView:View];
    [View addSubview:mbStaticProgressHUD];
    mbStaticProgressHUD.label.text = strText;
    mbStaticProgressHUD.mode = MBProgressHUDModeText;
    mbStaticProgressHUD.yOffset = -SCREEN_HEIGHT/12;
    
    mbStaticProgressHUD.bezelView.color = [UIColor blackColor];
    mbStaticProgressHUD.bezelView.alpha = 0.5f;
    mbStaticProgressHUD.label.numberOfLines = 0;
    mbStaticProgressHUD.contentColor = [UIColor whiteColor];
    [mbStaticProgressHUD showAnimated:YES];
    
    [mbStaticProgressHUD setRemoveFromSuperViewOnHide:YES];
    [mbStaticProgressHUD hideAnimated:YES afterDelay:2];
}




void showWaitingDialog()
{
    //showWaitingDialogWithStr(@"正在加载");
    showWaitingDialogWithStr(@"正在登录");
}







void closeWaitingDialog()
{
    if (mbStaticProgressHUD!=nil){
        [mbStaticProgressHUD removeFromSuperview];
        //[mbStaticProgressHUD hideAnimated:YES];
        mbStaticProgressHUD=nil;
    }
}




void closeshowTextDialog()
{
    if (HUD!=nil)
    {
        [HUD removeFromSuperview];
        HUD=nil;
    }
}



#pragma mark - 播放器 提醒
void playerShowDialog (NSString *text, UIView *targetView,NSTimeInterval delay) {
    
    if (isEmpty(text)) {
        return;
    }
    if (mbStaticProgressHUD!=nil){
        [mbStaticProgressHUD hideAnimated:YES];
        mbStaticProgressHUD=nil;
    }
    
    if (nil == targetView) {
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        mbStaticProgressHUD = [[MBProgressHUD alloc] initWithView:window];
        [window addSubview:mbStaticProgressHUD];
        mbStaticProgressHUD.center = window.center;
    }else{
        mbStaticProgressHUD = [[MBProgressHUD alloc] initWithView:targetView];
        [targetView addSubview:mbStaticProgressHUD];
        mbStaticProgressHUD.center = targetView.center;
    }
    
    mbStaticProgressHUD.bezelView.color = [UIColor blackColor];
    mbStaticProgressHUD.bezelView.alpha = 0.5f;
    mbStaticProgressHUD.label.numberOfLines = 0;
    mbStaticProgressHUD.contentColor = [UIColor whiteColor];
    
    mbStaticProgressHUD.label.text = text;
    mbStaticProgressHUD.label.font = [UIFont systemFontOfSize: (IS_IPHONE6PLUS ? 15:14)];
    mbStaticProgressHUD.mode = MBProgressHUDModeText;
    
    mbStaticProgressHUD.userInteractionEnabled = NO;
    
    [mbStaticProgressHUD showAnimated:YES];
    [mbStaticProgressHUD setRemoveFromSuperViewOnHide:YES];
    [mbStaticProgressHUD hideAnimated:YES afterDelay:delay];
    
}




BOOL checkPassword (NSString *password)
{
    NSString *tempPassword  = password;
    NSInteger passwordLength    = tempPassword.length;
    if (isEmpty(tempPassword))
    {
        showTipDialog(K_str_emptyPassword);
        return NO;
    }else{
        
        if (passwordLength <6 || passwordLength >20) {
            showTipDialog(EM_Password_Length);
            return NO;
        }
        else{
            return YES;
        }
    }
    return NO;
}





BOOL isCorrectPhoneNo (NSString *str_TempPhone)
{
    NSString *strTempPhone = str_TempPhone;
    if (isEmpty(strTempPhone)) {
        showTipDialog(K_str_inputPhoneNum);
    }else{
        
        if (strTempPhone.length != 11) {
            showTipDialog(@"请输入正确的11位手机号码");
            return NO;
        }
        
        BOOL  bTrue =  validateMobileNo(strTempPhone);
        if (bTrue)
            return YES;
        else{
            showTipDialog(K_str_rightPhoneNum);
            return NO;
        }
    }
    return NO;
}





#pragma mark  进度条
void showProgress() {
    
    activityIndicatorView = [[MRActivityIndicatorView alloc]initWithFrame:
                             CGRectMake(SCREEN_WIDTH/2-15, SCREEN_HEIGHT/2-15 , 30, 30)];
    //NSLog(@"开始地址%p",activityIndicatorView);
    activityIndicatorView.tintColor = [UIColor grayColor];
    [[[[UIApplication sharedApplication] delegate] window]addSubview:activityIndicatorView];
    
    activityIndicatorView.layer.zPosition = INT8_MAX;
    [activityIndicatorView startAnimating];
}

void hideProgress() {
    
    [CommonFunction performBlock:^{
        if (activityIndicatorView != nil) {
            [activityIndicatorView stopAnimating];
            [activityIndicatorView setHidden:YES];
            [activityIndicatorView removeFromSuperview];
            activityIndicatorView = nil;
        }else{
            
        }
    } afterDelay:2];
}


#pragma mark  设定时间延迟执行
+ (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    //    dispatch_after(popTime, dispatch_get_main_queue(), block);
    dispatch_after(popTime, dispatch_get_global_queue(0, 0), block);
    
    /*******        设定时间延迟执行方法二         *******/
    //    [self performSelector:@selector(hideDelayed) withObject:nil afterDelay:2];
}




#pragma mark 拉伸图片
UIImage *resizableImageOfImage(UIImage *image) {
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
}



/**
 *
 *限定宽度 ，行间距，计算字符串 所占的高度
 */
- (void)stringHeight:(NSString*)String {
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    UIColor *color = [UIColor blackColor];
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:String
                                                                 attributes:@{NSForegroundColorAttributeName : color, NSParagraphStyleAttributeName: paragraphStyle}];
    
    CGSize size =  [string boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                    | NSStringDrawingUsesFontLeading context:nil].size;
    
    //NSLog(@"%f",size.height);
}




+ (NSString*)appCurVersion {
    
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return appCurVersion;
}


#pragma mark - 后台系统版本
void systemVersion(NSString *Version) {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:Version forKey:@"Version"];
    [defaults synchronize];
}


#pragma mark - 获得后台系统版本
+ (NSString*)getVersionCode{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *Version = [defaults objectForKey:@"Version"];
    return Version;
}




#pragma mark - 保存用户登录信息用于默认登录
void userDefaultsWithModel(HKUserModel *model){
    
    [HKAccountTool saveOrUpdateAccount:model];
}

#pragma mark - 获得用户手机号
+ (NSString*)getUserPhoneNo {
    
    NSString *phone = [HKAccountTool shareAccount].phone;
    if (isEmpty(phone)) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *temp = [defaults objectForKey:LOGIN_PHONE];
        [defaults synchronize];
        [HKAccountTool shareAccount].phone = temp;
    }
    return [HKAccountTool shareAccount].phone;
    
    
}



#pragma mark - 获得用户ID
+ (NSString*)getUserToken {
    
    return [HKAccountTool shareAccount].access_token;
    
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSString *token = [defaults objectForKey:LOGIN_TOKEN];
    //    [defaults synchronize];
    //    return token;
}




/**
 推广渠道
 
 @return 推广渠道名
 */
+ (NSString*)getHKChannel {
    NSString *channel = [[NSUserDefaults standardUserDefaults] objectForKey:@"hk_channel"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return channel;
}

+ (NSString*)getXHSCaid {
    NSString *caid = [[NSUserDefaults standardUserDefaults] objectForKey:@"xhs_caid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return caid;
}

+ (NSString*)getXHSClickid {
    NSString *clickid = [[NSUserDefaults standardUserDefaults] objectForKey:@"xhs_clickid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return clickid;
}

+ (NSString*)getXHScaid_md5 {
    NSString *caid_md5 = [[NSUserDefaults standardUserDefaults] objectForKey:@"xhs_caid_md5"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return caid_md5;
}

+ (NSString*)getXHSpaid {
    
    NSString * sysd =[CommonFunction getDeviceUptime];
    NSString * sysu =[CommonFunction getSysU];
    NSString * sysb =[CommonFunction getSysB];
    NSLog(@"sysd = %@ ,sysu = %@, sysb =%@",sysd,sysu,sysb);
//    [NSString md5:sysd];
//    [NSString md5:sysu];
//    [NSString md5:sysb];
    NSString * paid = [NSString stringWithFormat:@"%@-%@-%@",[NSString md5:sysd],[NSString md5:sysu],[NSString md5:sysb]];
//    NSLog(@"paid = %@",paid);
    
    return paid;
}

/**
 存储 推广渠道 名
 
 @param channel 渠道名
 */
+ (void)setHKChannelWithName:(NSString*)channel {
    
    if (!isEmpty(channel)) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:channel forKey:@"hk_channel"];
        [defaults synchronize];
    }
}

+ (void)setXHSCaidWithName:(NSString*)caid {
    
    if (!isEmpty(caid)) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:caid forKey:@"xhs_caid"];
        [defaults synchronize];
    }
}

+ (void)setXHSClickidWithName:(NSString*)clickid {
    if (!isEmpty(clickid)) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:clickid forKey:@"xhs_clickid"];
        [defaults synchronize];
    }
}

+ (void)setXHScaid_md5WithName:(NSString*)clickid {
    if (!isEmpty(clickid)) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:clickid forKey:@"xhs_caid_md5"];
        [defaults synchronize];
    }
}

//+ (void)setXHSpaidWithName:(NSString*)clickid {
//    if (!isEmpty(clickid)) {
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setValue:clickid forKey:@"xhs_paid"];
//        [defaults synchronize];
//    }
//}


#pragma mark - 获得用户ID
+ (NSString*)getUserId {
    
    return [HKAccountTool shareAccount].ID;
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSString *userId = [defaults objectForKey:USER_ID];
    //    [defaults synchronize];
    //    return userId;
}


#pragma mark - 判断是否登录  返回NO - 未登录  YES - 登录
BOOL isLogin() {
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSString *userName = [defaults objectForKey:USER_ID];
    //    [defaults synchronize];
    
    NSString *userName = [HKAccountTool shareAccount].ID;
    if(isEmpty([CommonFunction getUserId])) {
        return NO;
    }
    else{
        return YES;
    }
}





#pragma mark - 退出登录
void signOut() {
    
    // 友盟记录 用户账号 退出功能
    [MobClick profileSignOff];
    // 删除账号
    [HKAccountTool deleteAccount];
    //    //退出 IM
    //    [HKIMLoginTool IM_logout];
}





#pragma mark -  获取手机剩余空间
+ (void)freeDiskSpaceInBytes:(void(^)(unsigned long long space))freeDiskBlock{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        struct statfs buf;
        unsigned long long freeSpace = -1;
        
        if (statfs("/var", &buf) >= 0) {
            
            freeSpace = (unsigned long long)(buf.f_bsize * buf.f_bavail);
        }
        
        //NSString *str = [NSString stringWithFormat:@"手机剩余存储空间为：%0.2lld MB",freeSpace/1024/1024];
        
        !freeDiskBlock? : freeDiskBlock(freeSpace);
    });
}




#pragma mark - 获取文件夹目录
+ (NSString *)getLocalUrlWithVideoUrl:(NSString *)videoUrl
{
    if (videoUrl == nil || [videoUrl isEqualToString:@""])
    {
        return nil;
    }
    else{
        if ([videoUrl length] > 7 && [videoUrl containsString:@"http://"])
        {
            NSString *subStr = [videoUrl substringFromIndex:7];
            subStr = [subStr stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
            subStr = [@"download" stringByAppendingPathComponent:subStr];
            subStr = [subStr stringByReplacingOccurrencesOfString:@"." withString:@"_"];
            return subStr;
        }
        return nil;
    }
}



+ (NSString *)getM3U8LocalUrlWithVideoUrl:(NSString *)videoUrl
{
    NSString *m3u8Path = [self getLocalUrlWithVideoUrl:videoUrl];
    m3u8Path = [m3u8Path stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    return m3u8Path;
}




#pragma mark - 获取设备信息
+ (NSString*)getUUIDString {
    
    NSString *identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    return identifier;
}


#pragma mark - 获取 IDFA
+ (NSString*)getIDFAString {
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //NSLog(@"adId ------ > %@",adId);
    NSLog(@"identifier:%@",adId);
    //BOOL enabled = [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
    NSLog(@"identifier:%@",adId);
    return adId;
}

+ (void)requestTrackingAuthorization{
    if (@available(iOS 14.0, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            switch (status) {
                case ATTrackingManagerAuthorizationStatusAuthorized:
                    NSLog(@"identifier:用户授权允许跟踪");
                    break;
                case ATTrackingManagerAuthorizationStatusDenied:
                    NSLog(@"identifier:用户拒绝允许跟踪");
                    break;
                case ATTrackingManagerAuthorizationStatusRestricted:
                    NSLog(@"identifier:跟踪受到限制");
                    break;
                case ATTrackingManagerAuthorizationStatusNotDetermined:
                    NSLog(@"identifier:用户尚未作出决定");
                    break;
                    
                default:
                    break;
            }
        }];
    }
//    else{
//        NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//    }
}

#pragma mark - 游客 是否是VIP  2- VIP  否则非VIP
+ (void) setTouristVIPStatus {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"2" forKey:TOUURIST_VIP_STATUS];
    [defaults synchronize];
}


#pragma mark - 获得 游客 VIP
+ (NSString*)getTouristVIPStatus {
    return [[NSUserDefaults standardUserDefaults] objectForKey:TOUURIST_VIP_STATUS];
}

#pragma mark - 获得  APP状态 1--线下状态
+ (NSString*)getAPPStatus {
    //1审核 2正式
    return [[NSUserDefaults standardUserDefaults] objectForKey:APP_STATUS];
}


#pragma mark - 查询 APP状态 审核或者线上？
+ (void)checkAPPStatus {
    
    UserInfoServiceMediator *mange = [UserInfoServiceMediator sharedInstance];
    [mange checkAppStatus:^(FWServiceResponse *response) {
        
        // 获取状态
        NSString *status = response.msg;
        NSString *password = response.password;
        if (status) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:status  forKey:APP_STATUS];
            if (password.length) {
                [defaults setObject:password  forKey:APP_PassWord];
            }
            
            [defaults synchronize];
        }
    } failBlock:^(NSError *error) {
        
    }];
    
}




+ (void)checkAPPStatus:(void(^)())sureAction {
    
    UserInfoServiceMediator *mange = [UserInfoServiceMediator sharedInstance];
    [mange checkAppStatus:^(FWServiceResponse *response) {
        
        // 获取状态
        NSString *status = response.msg;
        if (status) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:status  forKey:APP_STATUS];
            [defaults synchronize];
            
            if (NO == [status isEqualToString:@"1"]) {
                if (sureAction) {
                    sureAction();
                }
            }
        }
    } failBlock:^(NSError *error) {
        
    }];
}




#pragma mark - 统计用户登录人数 当天第一次打开，并且是已登录状态,
+ (void)recordUserLoginCount {
    if (isLogin()) {
        //统计用户登录人数
        NSString *key = [NSString stringWithFormat:@"%@-%@",[HKAccountTool shareAccount].ID, [DateChange getCurrentTime_day]];
        BOOL isRequest = [HKNSUserDefaults boolForKey:key];
        if (NO == isRequest) {
            [[HomeServiceMediator sharedInstance]recordLoginCount:nil completion:^(FWServiceResponse *response) {
                [HKNSUserDefaults setBool:YES forKey:key];
                [HKNSUserDefaults synchronize];
            } failBlock:^(NSError *error) {
                
            }];
        }
    }
    //统计设备
    [self recordDeviceCount];
}



#pragma mark -  统计当天设备数量
+ (void)recordDeviceCount {
    
    NSString *key = [NSString stringWithFormat:@"HKDevice-%@",[DateChange getCurrentTime_day]];
    BOOL isRequest = [HKNSUserDefaults boolForKey:key];
    if (NO == isRequest) {
        [[HomeServiceMediator sharedInstance]newDeviceAndActiveUser:^(FWServiceResponse *response) {
            [HKNSUserDefaults setBool:YES forKey:key];
            [HKNSUserDefaults synchronize];
        } failBlock:^(NSError *error) {
            
        }];
    }
}


/********************* APP 版本号*********************/
#pragma mark - APP 当前版本号
+ (NSString*)appVersionCode {
    return [self appCurVersion];
}


#pragma mark - 保存 当前 APP版本号
+ (void)saveAppVersionCode {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self appVersionCode] forKey:APP_VERSION];
    [defaults setValue:@"1" forKey:HK_SecondLoad];
    [defaults synchronize];
}


#pragma mark - 获取 版本号
+ (NSString*)getSaveAppVersionCode {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:APP_VERSION];
}


#pragma mark - 第一次打开 APP
+ (BOOL)isFirstLoad {
    static BOOL isFirstInFunc = NO;
    static BOOL isFirstLoadTempty = NO;
    
    if (!isFirstInFunc) {
        NSString *currentVersion = [self appVersionCode];
        NSString *lastRunVersion = [self getSaveAppVersionCode];
        
        if (isEmpty(lastRunVersion)) {
            [self saveAppVersionCode];
            isFirstLoadTempty =YES;
        } else if (![lastRunVersion isEqualToString:currentVersion]) {
            [self saveAppVersionCode];
            isFirstLoadTempty = YES;
        }
        isFirstInFunc = YES;
    }
    return isFirstLoadTempty;
}



+ (BOOL)isNeedShowADWindow {
    NSString *lastRunVersion = [self getSaveAppVersionCode];
    if (isEmpty(lastRunVersion)) {
        // 首次下载
        return NO;
    }
    
    if ( YES == [self isUpdateAppFirstLoad]) {
        // 更新后 打开
        return NO;
    }
    
    return YES;
}


/** 更新后 第一次打开 */
+ (BOOL)isUpdateAppFirstLoad {
    
    NSString *currentVersion = [self appVersionCode];
    NSString *lastRunVersion = [self getSaveAppVersionCode];
    
    if (isEmpty(lastRunVersion)) {
        // 首次下载
        return NO;
    }
    
    if (![lastRunVersion isEqualToString:currentVersion]) {
        
        isUpdateAppLoad = YES;
        return YES;
    }
    return NO;
}



#pragma mark - 第二次打开 APP 222
+ (BOOL)isSecondLoad {
    
    if(2 == secondLoad) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *temp = [defaults objectForKey:HK_SecondLoad];
        
        if ([temp isEqualToString:@"1"]) {
            [defaults setValue:@"2" forKey:HK_SecondLoad];
            [defaults synchronize];
            return YES;
        }else{
            return NO;
        }
    }else if(1 ==secondLoad){
        return NO;
    } else {
        return NO;
    }
}


/** 保存服务器APP版本 */
+ (NSString *)getServerVersion {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *versionString = [defaults objectForKey:@"HK_Server_App_Version"];
    if (!versionString.length) {
        versionString = [self appCurVersion];
    }
    
    
    return versionString;
}

/** 获取服务器APP版本 */
+ (void)saveServerVersion:(NSString *)version {
    
    if (version.length) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:version forKey:@"HK_Server_App_Version"];
        [defaults synchronize];
    }
}


/**
 是否 当天 第一次打开 APP
 
 @return
 */
+ (BOOL)isFirstLoadOfDay {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDateFormatter *dateformatter = [NSDateFormatter new];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *locationString = [dateformatter stringFromDate:[NSDate date]];
    if (![locationString isEqualToString:[defaults objectForKey:@"firstOpen"]]) {
        //当天第一次启动
        [defaults setValue:locationString forKey:@"firstOpen"];
        [defaults synchronize];
        return YES;
    }else{
        return NO;
    }
}




/**
 获得 UUID 并 将UUID 保存到钥匙串(UUID 经过MD5加密)
 */
//+ (NSString*)getUUIDFromKeychain {
//
//    NSString *strId = @"HK_DeviceID";
//    //NSString *uuid = [NSString md5:[self getUUIDString]];
//    LUKeychainAccess *keychain = [LUKeychainAccess standardKeychainAccess];
//    NSString *strKey = [keychain objectForKey:strId];
//    if (isEmpty(strKey)) {
//        NSString *uuid = [NSString md5:[self getUUIDString]];
//        [keychain setObject:uuid forKey:strId];
//        return uuid;
//    }else{
//        return strKey;
//    }
//}

+ (NSString*)getUUIDFromKeychain {
    
    NSString *strId = @"HK_DeviceID";
    //NSString *uuid = [NSString md5:[self getUUIDString]];
    LUKeychainAccess *keychain = [LUKeychainAccess standardKeychainAccess];
    NSString *strKey = [keychain objectForKey:strId];
    if (isEmpty(strKey)) {
        NSString *uuid = nil;
        if (!isEmpty([HKKeychainModel sharedInstance].keychainAccess)) {
            // 由于锁屏 时候 取到的钥匙串信息 不一样
            uuid = [HKKeychainModel sharedInstance].keychainAccess;
            return uuid;
        }
        uuid = [NSString md5:[self getUUIDString]];
        [keychain setObject:uuid forKey:strId];
        return uuid;
    }else{
        if (isEmpty([HKKeychainModel sharedInstance].keychainAccess)) {
            [HKKeychainModel sharedInstance].keychainAccess = strKey;
        }
        return strKey;
    }
}



/**
 七天 提醒一次 跳转到虎课APP 系统设置
 */
+ (void)jumpToAPPSetForSevenDay {
    if ([self isOpenNotificationSetting]) {
        // 已经开启通知
        return;
    }
    __block NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str_oldDate = [defaults objectForKey:@"HKSevenDayOpen"];
    NSDate *oldDate = [DateChange dateFromString24:str_oldDate];
    
    NSString *str_nowDate = [DateChange getCurrentTime];
    NSDate *nowDate = [DateChange dateFromString24:str_nowDate];
    
    if (!isEmpty(str_oldDate)) {
        NSInteger count = [DateChange numberOfDaysWithFromDate:oldDate toDate:nowDate];
        if (count>6) {
            // 七天显示一次
            [defaults setObject:str_nowDate forKey:@"HKSevenDayOpen"];
            [defaults synchronize];
        }else{
            return;
        }
    }
    else{
        [defaults setObject:str_nowDate forKey:@"HKSevenDayOpen"];
        [defaults synchronize];
    }
    [self jumpToAPPSetting];
}

+ (void)setKeyChainObject:(id)key value:(id)value {
    LUKeychainAccess *keychain = [LUKeychainAccess standardKeychainAccess];
    [keychain setObject:value forKey:key];
}

+ (id)getKeyChainObject:(id)key {
    LUKeychainAccess *keychain = [LUKeychainAccess standardKeychainAccess];
    id value = [keychain objectForKey:key];
    return value;
}





/** 将 记录保存到 钥匙串中 记录是否是第一次下载APP */
+ (BOOL)isFistDownload {
    
    //    NSString *strId = @"HK_firstDownload";
    //    LUKeychainAccess *keychain = [LUKeychainAccess standardKeychainAccess];
    //    NSString *strKey = [keychain objectForKey:strId];
    //    if (isEmpty(strKey)) {
    //        [keychain setObject:@"1" forKey:strId];
    //        return YES;
    //    }else{
    //        return NO;
    //    }
    
    NSString *versionCode = [CommonFunction getSaveAppVersionCode];
    NSString *key = @"HK_New_Download";
    NSString *str = [HKNSUserDefaults objectForKey:key];
    if (isEmpty(versionCode) && isEmpty(str)) {
        // 首次下载或再次下载APP
        [HKNSUserDefaults setValue:@"1" forKey:key];
        return YES;
    }else{
        return NO;
    }
}



/** 保存到钥匙串中 记录 新手礼包已经不是 第一次下载APP */
+ (BOOL)setFistGiftKeychain {
    
    NSString *strId = @"HK_FistGiftDownload";
    LUKeychainAccess *keychain = [LUKeychainAccess standardKeychainAccess];
    NSString *strKey = [keychain objectForKey:strId];
    if (isEmpty(strKey)) {
        [keychain setObject:@"1" forKey:strId];
        return YES;
    }else{
        return NO;
    }
}



/** 保存到钥匙串中 记录 新手礼包 是否第一次下载APP */
+ (BOOL)isFistGiftDownload {
    NSString *strId = @"HK_FistGiftDownload";
    LUKeychainAccess *keychain = [LUKeychainAccess standardKeychainAccess];
    //[keychain deleteObjectForKey:strId];
    NSString *strKey = [keychain objectForKey:strId];
    if (isEmpty(strKey)) {
        return YES;
    }else{
        return NO;
    }
}



/**
 跳转到虎课APP 系统设置
 */
+ (void)jumpToAPPSetting {
    
    HKOpenPushView *view = [[HKOpenPushView alloc] initWithFrame:CGRectMake(0, 0, 290, 134+35+150)];
    view.closeBlock = ^{
        [LEEAlert closeWithCompletionBlock:nil];
    };
    
    [LEEAlert alert].config
        .LeeCustomView(view)
        .LeeQueue(YES)
        .LeePriority(1)
        .LeeCornerRadius(5)
        .LeeHeaderInsets(UIEdgeInsetsZero)
        .LeeHeaderColor([UIColor clearColor])
        .LeeMaxWidth(320)
        .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
        .LeeShow();
    
}



/** 跳转通知 设置 */
+ (void)openNotificationSetting {
    
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if (HKSystemVersion > 10.0) {
        if( [[UIApplication sharedApplication] canOpenURL:url] ) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                
            }];
        }
    }else{
        if( [[UIApplication sharedApplication] canOpenURL:url] ) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}


/** yes 开启通知  */
+ (BOOL)isOpenNotificationSetting {
    if ( [[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone) {
        return YES;
    }
    return NO;
}



/**  获取不带 版本号的 主路径 */
+ (NSString*)getBaseUrl {
    NSRange rang =  [BaseUrl rangeOfString:@".com"];
    NSString *url = [BaseUrl substringWithRange:NSMakeRange(0, rang.location+4)];
    return url;
}





#pragma mark - 保存学习兴趣标签

+ (void)saveStudyTagWithArray:(NSMutableArray*)studyTagArr {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"HK-%@",[HKAccountTool shareAccount].ID];
    [defaults setObject:studyTagArr forKey:key];
    [defaults synchronize];
}


#pragma mark - 获取学习兴趣标签

+ (NSMutableArray<HKStudyTagModel*>*)getStudyTagArr {
    
    NSString *key = [NSString stringWithFormat:@"HK-%@",[HKAccountTool shareAccount].ID];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arr = [defaults arrayForKey:key];
    [defaults synchronize];
    return arr;
}



#pragma mark - YES 最新APP版本
+ (BOOL)isLatestVersion {
    NSString *currentVerString = [CommonFunction appCurVersion];
    NSString *serverVerString = [CommonFunction getServerVersion];
    BOOL isNew = NO;
    
    NSComparisonResult result3 = [currentVerString compare:serverVerString options:NSNumericSearch];
    if (result3 == NSOrderedDescending || result3 == NSOrderedSame) {
        isNew = YES;
    }
    return isNew;
}



#pragma mark 跳转到 tab 页控制器
+ (void)pushTabVCWithCurrectVC:(UIViewController *)currectVC index:(NSUInteger)index {
    
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    UIViewController *tabViewController = appDelegate.window.rootViewController;
    
    if ([tabViewController isKindOfClass:[CYLTabBarController class]]) {
        [(CYLTabBarController*)tabViewController setSelectedIndex:index];
        
    }else if ([tabViewController isKindOfClass:[UITabBarController class]]) {
        [(UITabBarController *)tabViewController setSelectedIndex:index];
    }
    if (nil != currectVC) {
        [currectVC.navigationController popViewControllerAnimated:YES];
    }
}




#pragma mark  计算 文本高度
+ (CGFloat)getTextHeight:(NSString *)mess font:(UIFont*)font lineSpacing:(CGFloat)lineSpacing  width:(CGFloat)width {
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:mess];
    text.yy_font = font;
    text.yy_lineSpacing = lineSpacing;
    
    CGSize size = CGSizeMake((width == 0) ?SCREEN_WIDTH :width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:text];
    
    CGFloat height = layout.textBoundingSize.height;
    return height;
}


+ (CGFloat)getTextWidth:(NSString *)mess font:(UIFont*)font lineSpacing:(CGFloat)lineSpacing  width:(CGFloat)width{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:mess];
    text.yy_font = font;
    text.yy_lineSpacing = lineSpacing;
    
    CGSize size = CGSizeMake((width == 0) ?SCREEN_WIDTH :width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:text];
    
    CGFloat w = layout.textBoundingSize.width;
    return w;
}



#pragma mark  计算 文本行数
+ (NSInteger)getTextRow:(NSString *)mess font:(UIFont*)font lineSpacing:(CGFloat)lineSpacing  width:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode {
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:mess];
    text.yy_font = font;
    text.yy_lineSpacing = lineSpacing;
    text.yy_lineBreakMode = lineBreakMode;
    
    CGSize size = CGSizeMake((width == 0) ?SCREEN_WIDTH :width, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:text];
    
    NSInteger temp = layout.rowCount;
    return temp;
}



/** 当前控制器 */
+ (UIViewController *)topViewController {
    
    UIWindow *win = nil;
    if ([[UIApplication sharedApplication].keyWindow isMemberOfClass:[HKAdWindow class]]) {
        // 广告 窗口 正在显示
        win = [AppDelegate sharedAppDelegate].window;
    }else{
        win = [UIApplication sharedApplication].keyWindow;
    }
    
    UIViewController *resultVC;
    resultVC = [self _topViewController:[win rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
    
    //    UIViewController *resultVC;
    //    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    //    while (resultVC.presentedViewController) {
    //        resultVC = [self _topViewController:resultVC.presentedViewController];
    //    }
    //    return resultVC;
}


+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}





+ (NSString *)HK_BaseUrl {
    NSString *url = nil;
    
    switch (hk_testServer) {
        case 0:
        {
            url = @"https://api.huke88.com/v5";
        }
            break;
        case 1:
        {
            url = @"https://app-test.huke88.com/v5";
        }
            break;
        case 2:
        {
            url = @"http://app-release.huke88.com/v5";
        }
            break;
        default:
            url = @"https://api.huke88.com/v5";
            break;
    }
    return url;
}

+ (NSString *)HK_BaseUrl_Channl {
    NSString * url = @"https://api-xhs.huke88.com/v5";
    
//    switch (hk_testServer) {
//        case 0:
//        {
//            url = @"https://api-xhs.huke88.com/v5";
//        }
//            break;
//        case 1:
//        {
//            url = @"https://api-xhs.huke88.com/v5";
//        }
//            break;
//        case 2:
//        {
//            url = @"https://api-xhs.huke88.com/v5";
//        }
//            break;
//        default:
//            url = @"https://api-xhs.huke88.com/v5";
//            break;
//    }
    return url;
}

/// 返回 不带 V5 的 URL
+ (NSString *)HK_BaseUrl_NO_V5 {
    NSString *baseUrl = BaseUrl;
    if ([baseUrl hasSuffix:@"/v5"]) {
        baseUrl = [baseUrl substringWithRange:NSMakeRange(0, baseUrl.length - 3)];
    }
    return baseUrl;
}



/** 拨打客服电话 */
+ (void)callServiceWithPhone:(NSString*)phoneNum {
    
    if (isEmpty(phoneNum)) {
        return;
    }
    NSString *phone = [NSString stringWithFormat:@"telprompt://%@",phoneNum];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        /// 大于等于10.0系统使用此openURL方法
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
    }
}


+ (NSString *)timeFromNow:(NSString *)str {
    if (!str.length) return @"时间未知";
    
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:str.integerValue];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:timeDate];
    long temp = 0;
    NSString *result;
    if (timeInterval/60 < 1)
    {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    return  result;
}

+ (BOOL)detalResponse:(id)responseObject{
    BOOL isRight = responseObject[@"code"] && [[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"1"] && [responseObject isKindOfClass:[NSDictionary class]];
    if (isRight) {
        NSDictionary* dic = (NSDictionary *)responseObject;
        BOOL isHave = [[dic[@"data"] allKeys]  containsObject: @"business_code"];
        if (isHave && [[NSString stringWithFormat:@"%@", responseObject[@"data"][@"business_code"]] isEqualToString:@"200"]) {
            return YES;
        }else{
            if (isHave) {
                return NO;
            }else{
                return isRight;
            }
        }
    }
    return NO;
}


#pragma mark - 获取 CAID
+ (NSString*)getCAIDString {

    NSString *caid = [CommonFunction getXHSCaid];
    if (isEmpty(caid)) {
        NSString *totalString = [self getStringTotal];
        return [NSString stringWithFormat:@"%@_%@", CAID_VERSION, totalString];
    }else{
        return [NSString stringWithFormat:@"%@", caid];
    }
}

+(NSString *)getStringTotal {
    NSString *sysV = [self systemVersion];
    NSString *memory = [self memory];
    NSString *machine = [self machine];
    NSString *diskSize = [self diskSize];
    
    
    NSString *sysU = [self getSysU];
    
    NSString *source1 = [NSString stringWithFormat:@"%@++%@++%@++%@++%@",diskSize, machine, memory, sysV, sysU];
    
    NSString *param1 = [self MD5:source1 ? source1 : @"unknown"];
    
    NSString *deviceName = [self deviceName];
    
    NSString *carrier = [self carrierInfo];
    
    NSString *countryCode = [self countryCode];
    
    NSString *sysB = [self getSysB];
    
    NSString *source2 = [NSString stringWithFormat:@"%@++%@++%@++%@",deviceName, carrier, countryCode, sysB];
    
    NSString *param2 = [self MD5:source2 ? source2 : @"unknown"];
    
    NSString *result = [NSString stringWithFormat:@"%@_%@", param1, param2];
    return result;
}

//判断字符串
+ (BOOL) isValidString:(id)input
{
    if (!input) {
        return NO;
    }
    
    if ((NSNull *)input == [NSNull null]) {
        return NO;
    }
    
    if (![input isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if ([input isEqualToString:@""]) {
        return NO;
    }
    if ([input isEqualToString:@"(null)"]) {
        return NO;
    }
    return YES;
}

+ (NSString *)MD5:(NSString *)source {
    if (![self isValidString:source] || source.length == 0) {
        return nil;
    }
    
    const char *cStr = [source UTF8String]; if (cStr == NULL) {
        return nil;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    return result;
    
}

//硬盘大小
+ (NSString *)diskSize {
    int64_t space = -1;
    
    NSError *error = nil;
    
    NSDictionary *attrs = [NSFileManager.defaultManager attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (!error) {
        space = [[attrs objectForKey:NSFileSystemSize] longLongValue]; }
    if (space < 0) { space = -1;
    }
    return [NSString stringWithFormat:@"%lld", space];
    
}

//机器名称
+ (NSString *)machine {
    NSString *machine = [self systemHardwareByName:"hw.machine"];
    return machine == nil ? @"" : machine;
}

//内存大小
+ (NSString *)memory {
    return [NSString stringWithFormat:@"%lld", [NSProcessInfo processInfo].physicalMemory];
}

//系统版本
+ (NSString *)systemVersion {
    return UIDevice.currentDevice.systemVersion;
}

//设备的初始化时间
+ (NSString *)getDeviceUptime{
    struct stat info;
    int result = stat("/var/mobile"
    , &info);
    if (result != 0) {
        return @"";
    }
    struct timespec time = info.st_birthtimespec;
    return [NSString stringWithFormat:@"%ld.%09ld", time.tv_sec, time.tv_nsec];
}

//系统启动时间
+ (NSString *)getSysB {
    
    struct timeval boottime;
    int mib[2] = {CTL_KERN, KERN_BOOTTIME};
    size_t size = sizeof(boottime);
    time_t uptime = -1;
    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0) {
        uptime = boottime.tv_sec;
        
    }
    return [NSString stringWithFormat:@"%ld", uptime];
    
}

// 系统更新时间
+ (NSString *)getSysU {
    NSString *result = nil;
    
    NSString *information = @"L3Zhci9tb2JpbGUvTGlicmFyeS9Vc2VyQ29uZmlndXJhdGlvblByb2ZpbGVzL1B1YmxpY0luZm8vTUNNZXRhLnBsaXN0";
    
    NSData *data=[[NSData alloc] initWithBase64EncodedString:information options:0];
    if(data == nil) return @"";
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSError *error = nil;
    
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:dataString error:&error]; 
    if (fileAttributes) {
        id singleAttibute = [fileAttributes objectForKey:NSFileCreationDate];
        
        if ([singleAttibute isKindOfClass:[NSDate class]]) {
            NSDate *dataDate = singleAttibute;
            result = [NSString stringWithFormat:@"%.6f", [dataDate timeIntervalSince1970]];
        }
        
    }
    return result ? : @"";
}

//设备类型
+ (NSString *)systemHardwareByName:(const char *)typeSpecifier {
    size_t size;
    
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *name = malloc(size);
    
    sysctlbyname(typeSpecifier, name, &size, NULL, 0);
    NSString *results = [NSString stringWithUTF8String:name];
    free(name);
    return results;
}

//用户名
+ (NSString *)deviceName {
    NSString *result = [NSString stringWithFormat:@"%@", [UIDevice currentDevice].name];
    return [self MD5:result ? : @"unknown"];
}

//运营商名称
+ (NSString *)carrierInfo {
#if TARGET_IPHONE_SIMULATOR
    return @"SIMULATOR";
#else
    static dispatch_queue_t _queue; static dispatch_once_t once; dispatch_once(&once, ^{
        _queue = dispatch_queue_create([[NSString stringWithFormat:@"com.carr.%@", self] UTF8String], NULL);
    });
    
    __block NSString *carr = nil;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); dispatch_async(_queue, ^(){
        CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init]; CTCarrier *carrier = nil;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 12.1) {
            if ([info respondsToSelector:@selector(serviceSubscriberCellularProviders)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability-new"
                NSArray *carrierKeysArray = [info.serviceSubscriberCellularProviders.allKeys sortedArrayUsingSelector:@selector(compare:)];
                
                carrier = info.serviceSubscriberCellularProviders[carrierKeysArray.firstObject]; if (!carrier.mobileNetworkCode) {
                    
                    carrier = info.serviceSubscriberCellularProviders[carrierKeysArray.lastObject];
                    
                }
#pragma clang diagnostic pop
                
            }
        }
        
        if (!carrier) {
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            
            carrier = info.subscriberCellularProvider;
#pragma clang diagnostic pop
            
        }
        
        if (carrier) {
            
            NSString *networkCode = [carrier mobileNetworkCode]; NSString *countryCode = [carrier mobileCountryCode];
            
            if (countryCode && [countryCode isEqualToString:@"460"] && networkCode) {
                
                if ([networkCode isEqualToString:@"00"] || [networkCode isEqualToString:@"02"] ||
                    
                    [networkCode isEqualToString:@"07"] || [networkCode isEqualToString:@"08"]) { carr = @"中国移动";
                    
                }
                
                if ([networkCode isEqualToString:@"01"] || [networkCode isEqualToString:@"06"] || [networkCode isEqualToString:@"09"]) {
                    
                    carr = @"中国联通";
                    
                }
                
                if ([networkCode isEqualToString:@"03"] || [networkCode isEqualToString:@"05"] || [networkCode isEqualToString:@"11"]) {
                    
                    carr = @"中国电信";
                    
                }
                
                
                if ([networkCode isEqualToString:@"04"]) {
                    carr = @"中国卫通";
                }
                
                if ([networkCode isEqualToString:@"20"]) {
                    
                    carr = @"中国铁通";
                    
                }
                
            } else {
                
                carr = [carrier.carrierName copy];
                
            }
            
        }
        
        if (carr.length <= 0) {
            carr = @"unknown";
            
        }
        
        dispatch_semaphore_signal(semaphore);
        
    });
    
    dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC); dispatch_semaphore_wait(semaphore, t);
    
    return [carr copy];
    
#endif
}

//国家码
+ (NSString *)countryCode {
    return [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
}



+ (UIViewController *)getRootViewController{
    
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    return window.rootViewController;
}

+ (NSString * )makeRandomNumber{
    NSString * currentTime = [DateChange getNowTimeTimestamp];
    NSString * platform = IS_IPAD ? @"21" : @"20";
    NSString * devicec_num = [CommonFunction getUUIDFromKeychain];
    NSLog(@"video_random_id============ %@ ===== %@ =====%@",devicec_num,platform,currentTime);
    return [NSString stringWithFormat:@"%@%@%@",devicec_num,platform,currentTime];
}
@end


                    

