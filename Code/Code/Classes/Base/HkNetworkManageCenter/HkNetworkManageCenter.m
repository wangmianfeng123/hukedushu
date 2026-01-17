//
//  HkNetworkManageCenter.m
//  Code
//
//  Created by Ivan li on 2019/1/28.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HkNetworkManageCenter.h"

@interface HkNetworkManageCenter()

@property(nonatomic,assign) AFNetworkReachabilityStatus networkStatus;

@property(nonatomic,assign) BOOL isNoActiveNetStatus;

@property(nonatomic,assign) AFNetworkReachabilityStatus frontNetworkStatus;

@end



@implementation HkNetworkManageCenter

+ (instancetype)shareInstance {
    static HkNetworkManageCenter *networkManageCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         networkManageCenter = [[HkNetworkManageCenter alloc] init];
        
        [[AFNetworkReachabilityManager sharedManager ] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            networkManageCenter.networkStatus = status;
            NSString *text = nil;
            switch (status) {
                case -1:
                    text = @"未知网络";
                    break;
                case 0:
                    
                    text = @"网络不可达";
                    break;
                case 1:
                    text = @"GPRS网络";
                    break;
                case 2:
                    text = @"wifi网络";
                    break;
                default:
                    break;
            }
                        
            if(status ==AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi)
            {
                NSLog(@"有网");
                networkManageCenter.isNoActiveNetStatus = YES;
            }else{
                NSLog(@"没有网");
                networkManageCenter.isNoActiveNetStatus = NO;
            }
            // 网络改变通知
            NSDictionary *dict =  @{@"status": [NSString stringWithFormat:@"%ld",(long)status]};
            HK_NOTIFICATION_POST_DICT(KNetworkStatusNotification, nil, dict);
            
            networkManageCenter.frontNetworkStatus = status;
            
            //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [CommonFunction requestTrackingAuthorization];
            //});
        }];
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        
        
    });
    return networkManageCenter;
}


@end

