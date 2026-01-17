//
//  NSObject+PerformAction.h
//  Code
//
//  Created by hanchuangkeji on 2017/12/22.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PerformAction)


- (id)tb_performSelector:(SEL)aSelector withObjects:(NSArray *)objects;

@end
