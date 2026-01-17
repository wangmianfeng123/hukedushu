//
//  BaseUrl.h
//  FamousWine
//
//  Created by pg on 15/11/6.
//  Copyright © 2015年 pg. All rights reserved.2
//



#ifndef BaseUrl_h
#define BaseUrl_h


static const int HomePageSize = 15;

//成功
#define SERVICE_RESPONSE_OK @"1"


/** 后台 API 版本*/

#define API_VERSION   @"2.43.3"

/** 后台 APP 类型（1- 安卓 2 - IOS） */
#define APP_TYPE  @"2"

/** 平板判断  */
#define STRING_TABLET IS_IPAD? @"1" : @"0"

/**设备uuid */
#define DEVICE_NUM  @"device-num"

#define HK_TEST_SERVER @"testServer"



//#define BaseUrl  @"https://api.huke88.com/v5"

#define BaseUrl    [CommonFunction HK_BaseUrl]

#define BaseUrl_Channl    [CommonFunction HK_BaseUrl_Channl]


#endif /* BaseUrl_h */

// 待解决问题
//2 -平板上下黑边问题
