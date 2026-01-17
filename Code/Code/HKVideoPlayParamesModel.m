//
//  HKVideoPlayParamesModel.m
//  Code
//
//  Created by eon Z on 2022/8/10.
//  Copyright © 2022 pg. All rights reserved.
//

#import "HKVideoPlayParamesModel.h"

@implementation HKVideoPlayParamesModel

-(instancetype)init{
    if ([super init]) {
        self.event_name = @"play_video_progress";
    }
    return self;
}

@end
