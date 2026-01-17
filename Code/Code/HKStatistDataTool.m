//
//  HKStatistDataTool.m
//  Code
//
//  Created by eon Z on 2022/8/10.
//  Copyright © 2022 pg. All rights reserved.
//

#import "HKStatistDataTool.h"
#import "HKVideoPlayParamesModel.h"
#import "HKPageVisitParamesModel.h"
#import "HKClickParamesModel.h"

@implementation HKStatistDataTool


+ (instancetype)sharedInstance
{
    static HKStatistDataTool * _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
        _sharedInstance.uuid = [CommonFunction makeRandomNumber];
    });
    return _sharedInstance;
}

+ (void)reportVideoPlayData:(HKVideoPlayParamesModel *)model{
    [HKStatistDataTool reportParames:model];
}

+ (void)reportPageVisitPage_title:(NSString *)page_title{
    HKPageVisitParamesModel * model = [[HKPageVisitParamesModel alloc] initWithPageTitle:page_title];
    [HKStatistDataTool reportParames:model];
}


//+ (void)reportClickEventDataRoute:(NSString *)route module:(NSInteger )module{
//    [self reportClickEventDataRoute:route module:module position:0 paramDics:nil];
//}
//
//+ (void)reportClickEventDataRoute:(NSString *)route module:(NSInteger )module position:(NSInteger)position{
//    [self reportClickEventDataRoute:route module:module position:position paramDics:nil];
//}
//
//+ (void)reportClickEventDataRoute:(NSString *)route module:(NSInteger )module position:(NSInteger)position paramDics:(NSMutableDictionary *)dic{
////    HKClickParamesModel * model = [[HKClickParamesModel alloc] initWithRoute:route module:module position:position];
////    [HKStatistDataTool reportParames:model];
//}

+ (void)reportParames:(HKDataParamesModel *)model{
//    NSLog(@"reportParames =============== dic:%@", [NSString stringWithCString:[[dic description] cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding]);
    if([model.mj_keyValues isKindOfClass:[NSMutableDictionary class]] && model.mj_keyValues != nil ){
        
        NSString * str = [HKHttpTool jsonStringWithDict:model.mj_keyValues];
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSString * string = [data base64EncodedStringWithOptions:0];
        NSLog(@"reportParames =============== str:%@",str);
        NSLog(@"reportParames =============== string:%@",string);

        
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        [params setSafeObject:string forKey:@"d"];
        [params setSafeObject:[DateChange getNowTimeTimestamp] forKey:@"time"];
        [params setSafeObject:@"nginxlogs" forKey:@"t"];
    //    NSLog(@"reportParames =============== params:%@", [NSString stringWithCString:[[dic description] cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding]);


        [HKHttpTool hk_taskGetUrl:@"https://analytics.huke88.com/sa.gif?" parameters:params success:^(id responseObject) {
            NSLog(@"reportParames =============== responseObject:%@",responseObject);
        } failure:^(NSError *error) {
            NSLog(@"reportParames =============== error:%@",error);
        }];
    }

    
}

@end
