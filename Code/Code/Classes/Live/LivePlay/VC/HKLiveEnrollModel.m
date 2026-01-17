//
//  HKLiveEnrollModel.m
//  Code
//
//  Created by ivan on 2020/9/1.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKLiveEnrollModel.h"

@implementation HKLiveEnrollModel



//免费直播的报名或取消报名
+ (RACSignal *)signalLiveEnrollWithDict:(NSDictionary *)dict {
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    //@{@"op_type" : enRollString, @"live_course_id" : self.model.content.live_course_id}
    [HKHttpTool POST:@"live/enroll-or-un-enroll" parameters:dict success:^(id responseObject) {
        [subject sendNext:responseObject];
        [subject sendCompleted];
    } failure:^(NSError *error) {
        [subject sendError:error];
    }];
    return subject;
}


@end
