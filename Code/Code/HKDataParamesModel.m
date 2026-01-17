//
//  HKDataParamesModel.m
//  Code
//
//  Created by eon Z on 2022/8/10.
//  Copyright © 2022 pg. All rights reserved.
//

#import "HKDataParamesModel.h"
#import "UIDeviceHardware.h"

@interface HKDataParamesModel ()

@end

@implementation HKDataParamesModel

-(instancetype)init{
    if ([super init]) {
        self.time = [DateChange getNowTimeTimestamp];
        self.lib = @"oc";
        self.lib_version = @"1.0";
        self.client_type = @"2";
        self.distinct_id = [CommonFunction getUUIDFromKeychain];
        self.app_version = [CommonFunction appCurVersion];
        self.platform = IS_IPAD ? @"21":@"20";
        self.uid = [CommonFunction getUserId];
        self.model = [[UIDeviceHardware new]platform];
        self.os_version = [[UIDevice currentDevice] systemVersion];
        self.os = @"iOS";
        self.referrer = @"AppStore";
        self.screen_width = SCREEN_WIDTH;
        self.screen_height = SCREEN_HEIGHT;
        self.carrier = [CommonFunction carrierInfo];
        self.vip = ([[HKAccountTool shareAccount].vip_class isEqualToString:@"0"] || [[HKAccountTool shareAccount].vip_class isEqualToString:@"-1"]) ? @"0" : @"1";
        self.regd = [HKAccountTool shareAccount].regd;
    }
    return self;
}

@end
