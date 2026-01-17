//
//  HKVideoPlaylnstance.m
//  Code
//
//  Created by eon Z on 2021/12/3.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKVideoPlaylnstance.h"

@implementation HKVideoPlaylnstance


+ (instancetype)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

@end
