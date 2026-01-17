//
//  HKDownloadAgent.h
//  Code
//
//  Created by hanchuangkeji on 2017/12/18.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "HKDownloadAgent.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface HKDownloadAgent()



@end

@implementation HKDownloadAgent

+ (HKDownloadAgent *)initManager:(HKDownloadManager *)manager HKDownloadModel:(HKDownloadModel *)modelForDelegate delegate:(id<HKDownloadManagerDelegate>)delegate {
    HKDownloadAgent *agent = [[HKDownloadAgent alloc] init];
    agent.manager = manager;
    agent.modelForDelegate = modelForDelegate;
    agent.delegate = delegate;
    
    return agent;
}



- (void)excuteFunc:(SEL)action arguments:(NSArray *)array {
    
    // 从manager delegate array移除
    if (!self.delegate && self.manager) {
        
        // 防止多线程操作
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.manager removeAgent:self model:nil];
        });
        return;
    } else if ([self.delegate respondsToSelector:action]) {
        
        // 执行代理
        [((NSObject *)self.delegate) tb_performSelector:action withObjects:array];
    }
}


@end
