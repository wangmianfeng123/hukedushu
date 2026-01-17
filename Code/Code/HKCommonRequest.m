//
//  HKCommonRequest.m
//  Code
//
//  Created by Ivan li on 2018/6/26.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKCommonRequest.h"
#import "CommonFunction.h"
#import "MRProgress.h"
#include <sys/param.h>
#include <sys/mount.h>
#import "DownloadManager.h"
#import "HomeServiceMediator.h"
#import <LUKeychainAccess/LUKeychainAccess.h>
#import "NSString+MD5.h"
#import "HKStudyTagModel.h"
#import "AppDelegate.h"
#import <CYLTabBarController/CYLTabBarController.h>

@implementation HKCommonRequest



/**
 分享成功回调

 @param model 分享model
 @param success （成功后 执行回调）
 */
+ (void)shareDataSucess:(ShareModel*)model  success:(void (^)(id responseObject))success  failure:(void (^)(NSError *error))failure {
    NSString *device_num = [CommonFunction getUUIDFromKeychain];
    //NSDictionary *dict = @{@"device_num":device_num, @"type":isEmpty(model.type)?@"":model.type};
    NSDictionary *dict = @{@"video_id":isEmpty(model.video_id)?@"":model.video_id, @"device_num": device_num, @"type":isEmpty(model.type)?@"":model.type };
    [HKHttpTool POST:VIDEO_SHARE_CALLBACK parameters:dict success:^(id responseObject) {
        if (success) {
            success(model);
        }
        showTipDialog([responseObject objectForKey:@"msg"]);
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


@end




