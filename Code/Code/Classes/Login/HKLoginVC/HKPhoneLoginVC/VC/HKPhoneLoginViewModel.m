//
//  HKPhoneLoginViewModel.m
//  Code
//
//  Created by ivan on 2020/6/12.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKPhoneLoginViewModel.h"
#import "AppDelegate.h"


@implementation HKPhoneLoginViewModel


+ (RACSignal *)signalLoginWithWithPhone:(NSString *)phone code:(NSString *)code {
    
    //vip_class：5-分类限五vip 4-套餐vip 3-终身全站通 2-全站通VIP 1-分类无限VIP 0-非VIP，
    //out_line：1-正常登陆 2-验证绑定的手机 3-请绑定手机号码 4-今天登录太频繁，已限制登录
    RACReplaySubject *subject = [RACReplaySubject subject];
    FWNetWorkServiceMediator *mange = [FWNetWorkServiceMediator sharedInstance];
    [mange loginWithAuthCode:code phone:phone completion:^(FWServiceResponse *response) {
        [subject sendNext:response];
        [subject sendCompleted];
    } failBlock:^(NSError *error) {
        [subject sendError:error];
    }];
    
    return subject;
}



+ (RACSignal *)signalLoginWithUnionId:(NSString*)unionId
                           name:(NSString*)name
                         openid:(NSString*)openid
                        iconurl:(NSString*)iconurl
                     clientType:(NSString*)clientType
                   registerType:(NSString*)registerType
                     jsonString:(NSString*)string
{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    FWNetWorkServiceMediator *mange = [FWNetWorkServiceMediator sharedInstance];
    [mange loginWithUserId:name
                    avator:iconurl
                    openid:openid
                   unionid:unionId
                    client:clientType
              registerType:registerType
                jsonString:string
                completion:^(FWServiceResponse *response) {
        
        
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            [HKLoginTool saveLastLoginPattern:clientType];
        }
        [HKProgressHUD hideHUD];
        [AppDelegate sharedAppDelegate].showLoadMessage = NO;
        [subject sendNext:response];
        [subject sendCompleted];
    } failBlock:^(NSError *error) {
        [HKProgressHUD hideHUD];
        [AppDelegate sharedAppDelegate].showLoadMessage = NO;
        showTipDialog(error.localizedDescription);
        [subject sendError:error];
    }];
    
    return subject;
    
}



+ (RACSignal *)signalUMSocialLoginForPlatform:(UMSocialPlatformType)platformType
                  currentViewController:(UIViewController*)currentViewController {
        
        RACReplaySubject *subject = [RACReplaySubject subject];
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType
                                            currentViewController:currentViewController
                                                       completion:^(id result, NSError *error) {
    
                                                           UMSocialUserInfoResponse *resp = result;
                                                           // 授权信息
                                                           NSLog(@"Sina unionId: %@", resp.unionId);
                                                           NSLog(@"Sina openid: %@", resp.openid);
                                                           NSLog(@"Sina uid: %@", resp.uid);
                                                           NSLog(@"Sina accessToken: %@", resp.accessToken);
                                                           NSLog(@"Sina refreshToken: %@", resp.refreshToken);
                                                           NSLog(@"Sina expiration: %@", resp.expiration);
                                                           // 用户信息
                                                           NSLog(@"Sina name: %@", resp.name);
                                                           NSLog(@"Sina iconurl: %@", resp.iconurl);
                                                           NSLog(@"Sina gender: %@", resp.unionGender);
                                                           // 第三方平台SDK源数据
                                                           NSLog(@"Sina originalResponse: %@", resp.originalResponse);
    
                                                           if (error) {
                                                               [HKProgressHUD hideHUD];
                                                               [AppDelegate sharedAppDelegate].showLoadMessage = NO;
                                                               showTipDialog(Cancel_Authorized);
                                                               [subject sendError:error];
                                                           }else{
                                                               // 第三方登录数据(为空表示平台未提供)
                                                               NSString * platType = nil;
                                                               if (platformType == UMSocialPlatformType_WechatSession) {
                                                                   platType = @"2";
                                                               }else if (platformType == UMSocialPlatformType_QQ) {
                                                                   platType = @"1";
                                                               }else {
                                                                   platType = @"3";
                                                               }
                                                               
                                                               NSError * parseError;
                                                               NSData * jsonData = [NSJSONSerialization dataWithJSONObject:resp.originalResponse options:NSJSONWritingPrettyPrinted error:&parseError];
                                                               if (parseError) {
                                                                 //解析出错
                                                                   showTipDialog(@"授权信息解析出错");
                                                               }
                                                               NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                                                               
                                                               [[[self class]signalLoginWithUnionId:resp.unionId
                                                                                               name:isEmpty(resp.name) ? nil :resp.name
                                                                                             openid:resp.openid
                                                                                            iconurl:isEmpty(resp.iconurl) ? nil :resp.iconurl
                                                                                         clientType:platType
                                                                                       registerType:platType
                                                                                         jsonString:str
                                                                 ]subscribeNext:^(FWServiceResponse *response) {
                                                                   [subject sendNext:response];
                                                               }error:^(NSError * _Nullable error) {
                                                                   [subject sendError:error];
                                                               } completed:^{
                                                                   [subject sendCompleted];
                                                               }];
                                                           }
        }];
    return subject;
}




@end
