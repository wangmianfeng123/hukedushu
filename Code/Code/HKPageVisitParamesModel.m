//
//  HKPageVisitParamesModel.m
//  Code
//
//  Created by eon Z on 2022/8/10.
//  Copyright © 2022 pg. All rights reserved.
//

#import "HKPageVisitParamesModel.h"
#import "HKStatistDataTool.h"

@implementation HKPageVisitParamesModel


- (instancetype)initWithPageTitle:(NSString *)pageTitle{
    if ([super init]) {
        self.event_name = @"page_visit";
        self.uuid = [HKStatistDataTool sharedInstance].uuid;
        self.wifi = [HkNetworkManageCenter shareInstance].networkStatus == 2 ? @"1":@"0";
        self.route = pageTitle;
    }
    return self;
}
@end
