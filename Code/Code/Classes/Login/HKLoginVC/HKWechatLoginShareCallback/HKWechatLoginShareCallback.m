//
//  HKLoginVCCallback.m
//  Code
//
//  Created by Ivan li on 2019/11/21.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKWechatLoginShareCallback.h"

@implementation HKWechatLoginShareCallback


+ (instancetype)sharedInstance {
    
    static HKWechatLoginShareCallback *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        
    });
    return sharedInstance;
}


@end
