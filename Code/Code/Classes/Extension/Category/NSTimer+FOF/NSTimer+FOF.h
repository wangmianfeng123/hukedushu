//
//  NSTimer+FOF.h
//  com.pintu.aaaaaa
//
//  Created by hanchuangkeji on 2017/8/23.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (FOF)


/**
 防止NSTimer被runLoop强引用而无法释放vc
 */
+ (NSTimer *)tb_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block
                                       repeats:(BOOL)repeats;

@end
