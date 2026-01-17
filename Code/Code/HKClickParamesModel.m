//
//  HKClickParamesModel.m
//  Code
//
//  Created by eon Z on 2022/8/10.
//  Copyright © 2022 pg. All rights reserved.
//

#import "HKClickParamesModel.h"
#import "HKStatistDataTool.h"

@implementation HKClickParamesModel
-(instancetype)init{
    if ([super init]) {
        self.event_name = @"click_event";
        self.uuid = [HKStatistDataTool sharedInstance].uuid;
        self.wifi = [HkNetworkManageCenter shareInstance].networkStatus == 2 ? @"1":@"0";
    }
    return self;
}


- (instancetype)initWithRoute:(NSString *)route module:(NSString *)module position:(NSString *)position{
    if ([super init]) {
        self.event_name = @"click_event";
        self.uuid = [HKStatistDataTool sharedInstance].uuid;
        self.wifi = [HkNetworkManageCenter shareInstance].networkStatus == 2 ? @"1":@"0";
        self.route = route;
        self.module = module;
        self.position = position;
    }
    return self;
}


@end
