//
//  HKPermissionVideoModel.m
//  Code
//
//  Created by Ivan li on 2017/9/3.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKPermissionVideoModel.h"

@implementation HKPermissionVideoModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"play_time" : [PlayTimeModel class],@"vipRedirect" : [HKMapModel class]};
}



- (NSString *)video_url {
    if (!isEmpty(_video_url)) {
        return _video_url;
    } else if (!isEmpty(_qn_video_url)) {
        return _qn_video_url;
    } else if (!isEmpty(_tx_video_url)) {
        return _tx_video_url;
    } else {
        return @"";
    }
}

- (NSString *)tx_video_url {
    if (!isEmpty(_tx_video_url)) {
        return _tx_video_url;
    } else if (!isEmpty(_qn_video_url)) {
        return _qn_video_url;
    } else if (!isEmpty(_video_url)) {
        return _video_url;
    } else {
        return @"";
    }
}


@end


@implementation PlayTimeModel

@end


