//
//  NSArray+Bounds.m
//  Code
//
//  Created by Ivan li on 2019/1/7.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "NSArray+Bounds.h"

@implementation NSArray (Bounds)

- (id)by_ObjectAtIndex:(NSUInteger)index {
    if (self.count > index) {
        return [self objectAtIndex:index];
    } else {
        return nil;
    }
}
@end
