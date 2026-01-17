//
//  HKNewUserGiftTool.m
//  Code
//
//  Created by Ivan li on 2018/8/14.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKNewUserGiftTool.h"
#import "HKHomeGiftModel.h"

#import <LUKeychainAccess/LUKeychainAccess.h>
#import "HKNewUserFirstVC.h"
#import "HKNewUserSecondVC.h"
#import "HKNewUserThirdVC.h"
#import "HKHomeGiftModel.h"


#define   HK_NO_Show_Gift  @"HK_NO_Show_Gift"

#define   HK_Show_Day  [CommonFunction getUserId] // @"HK_Show_Day"

#define   HK_Get_Gift_Day  [NSString stringWithFormat:@"%@-gift-day",[CommonFunction getUserId]]    //@"HK_Get_Gift_Day"



@implementation HKNewUserGiftTool


#pragma mark  礼包 信息
+ (void)userGiftInfo {
    
    if (!isLogin()) {
        return;
    }
//    [HKHttpTool POST:GIft_GET_DAY_INFO parameters:nil success:^(id responseObject) {
//        if (HKReponseOK) {
//            HKHomeGiftModel *model = [HKHomeGiftModel mj_objectWithKeyValues:responseObject[@"data"]];
//            NSInteger day = [model.day intValue] ?[model.day intValue] :1;
//            if (model.show_pop) {
//                [self presentHKNewUserVC:day model:model];
//            }
//            [self setGiftDayUserDefaults:[NSString stringWithFormat:@"%ld",day]];
//        }
//        [self setGiftTimeUserDefaults];
//        [CommonFunction setFistGiftKeychain];
//    } failure:^(NSError *error) {
//        [CommonFunction setFistGiftKeychain];
//    }];
}



/*
 #pragma mark 第三天 礼包
 + (void)thirdGiftReqeust {
 
 [HKHttpTool POST:GIft_GET_DAY_INFO parameters:nil success:^(id responseObject) {
 if (HKReponseOK) {
 HKHomeGiftModel *model = [HKHomeGiftModel mj_objectWithKeyValues:responseObject[@"data"]];
 if (model.show_pop) {
 [self presentHKNewUserVC:[model.day intValue] model:model];
 }
 }
 [self setGiftTimeUserDefaults];
 [self setGiftDayUserDefaults:@"3"];
 } failure:^(NSError *error) {
 
 }];
 }
 
 
 #pragma mark  第二天 礼包
 + (void)secondeGiftReqeust {
 
 [HKHttpTool POST:GIft_GET_DAY_INFO parameters:nil success:^(id responseObject) {
 if (HKReponseOK) {
 HKHomeGiftModel *model = [HKHomeGiftModel mj_objectWithKeyValues:responseObject[@"data"]];
 if (model.show_pop) {
 [self presentHKNewUserVC:[model.day intValue] model:model];
 }
 }
 [self setGiftTimeUserDefaults];
 [self setGiftDayUserDefaults:@"2"];
 } failure:^(NSError *error) {
 
 }];
 }
 
 */


/** 第一天 礼包 */
+ (void)firstGiftInfoReqeust {
    
//    [HKHttpTool POST:GIft_GET parameters:nil success:^(id responseObject) {
//        if (HKReponseOK) {
//            HKHomeGiftModel *model = [HKHomeGiftModel mj_objectWithKeyValues:responseObject[@"data"]];
//            //NO - 刚刚获得礼包    YES - 已经获得礼包
//            if (model.first_day_gift.has_get == NO) {
//                [self presentHKNewUserVC:1 model:model];
//            }
//        }
//        [self setGiftTimeUserDefaults];
//        [self setGiftDayUserDefaults:@"1"];
//        //存储 标识 非新用户
//        [CommonFunction setFistGiftKeychain];
//    } failure:^(NSError *error) {
//        [CommonFunction setFistGiftKeychain];
//    }];
}



/** 存储 礼包领取 的日期 */
+ (void)setGiftTimeUserDefaults {
    
    NSString *day = [DateChange getCurrentTime_day];
    [HKNSUserDefaults setValue:day forKey:HK_Get_Gift_Day];
    [HKNSUserDefaults synchronize];
}



/** 获得 礼包领取 的日期 */
+ (NSString*)getGiftTimeUserDefaults {
    NSString *day = [HKNSUserDefaults objectForKey:HK_Get_Gift_Day];
    [HKNSUserDefaults synchronize];
    return day;
}


/** 礼包领取到 那一天 */
+ (void)setGiftDayUserDefaults:(NSString*)day {
    
    [HKNSUserDefaults setValue:day forKey:HK_Show_Day];
    [HKNSUserDefaults synchronize];
}




/**
 * 请求接口判断 用户是否 是首次下载的新用户
 * 新用户 则 弹新手礼包
 */

+ (void)giftShowRequest {
    
//    [HKHttpTool POST:GIft_CAN_SHOW parameters:nil success:^(id responseObject) {
//        if (HKReponseOK) {
//            HKHomeGiftModel *model = [HKHomeGiftModel mj_objectWithKeyValues:responseObject[@"data"]];
//            if (model.result) {
//                //首次安装 弹出新手礼包 登录框
//                [HKLoginTool pushGiftLoginVC];
//            }
//        }
//        //存储 标识 非新用户
//        [CommonFunction setFistGiftKeychain];
//    } failure:^(NSError *error) {
//        
//    }];
}





/**
 *@ isRunGiftShow  （YES 执行新手礼包显示请求）
 *
 */
+ (void)newUserGiftAction:(BOOL)isRunGiftShow {
    
    if ([CommonFunction isFistGiftDownload] && !isLogin() && isRunGiftShow) {
        [self giftShowRequest];
    }else{
        
        if (isLogin()) {
            NSString *day = [HKNSUserDefaults objectForKey:HK_Show_Day];
            
            if (!isEmpty(day)) {
                NSString *date = [self getGiftTimeUserDefaults];
                NSDate *time = [DateChange dayFromString:date];
                NSDate *currentTime = [DateChange dayFromString:[DateChange getCurrentTime_day]];
                NSInteger dayCount = [DateChange numberOfDaysWithFromDate:time toDate:currentTime];
                
                switch ([day intValue]) {
                    case 1:
                    {// 2天
                        if (dayCount == 1) { [self userGiftInfo];}
                    }
                        break;
                        
                    case 2:
                    {// 3天
                        if (dayCount == 1) { [self userGiftInfo];}
                    }
                        break;
                }
            }else{
                // 1-未访问 GIft_CAN_SHOW 在其他入口登录成功   2- 访问 GIft_CAN_SHOW登录成功
                [self firstGiftInfoReqeust];
            }
        }
    }
}




+ (void)presentHKNewUserVC:(NSInteger)day model:(HKHomeGiftModel *)model {
    
    switch (day) {
        case 1:
            [HKNewUserFirstVC presentHKNewUserFirstVC:model];
            break;
            
        case 2:
            [HKNewUserSecondVC presentHKNewUserSecondVC:model];
            break;
            
        case 3:
            [HKNewUserThirdVC presentHKNewUserThirdVC:model];
            break;
    }
}




@end





