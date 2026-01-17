//
//  HKUMShare.m
//  Code
//
//  Created by Ivan li on 2018/5/15.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKUMShare.h"



static HKUMShare *_instance = nil;




@implementation HKUMShare

// 完整单例
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}


- (UMpopView*)popView {
    if (!_popView) {
        _popView = [[UMpopView alloc]init];
        [_popView createUIWithModel:nil];
    }
    return _popView;
}



@end
