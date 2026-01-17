//
//  NSTimer+FOF.m
//  com.pintu.aaaaaa
//
//  Created by hanchuangkeji on 2017/8/23.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "NSTimer+FOF.h"

@implementation NSTimer (FOF)


+ (NSTimer *)tb_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block
                                       repeats:(BOOL)repeats
{
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(tb_blockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (void)tb_blockInvoke:(NSTimer *)timer {
    void (^block)() = timer.userInfo;
    if(block) {
        block();
    }
}


@end
