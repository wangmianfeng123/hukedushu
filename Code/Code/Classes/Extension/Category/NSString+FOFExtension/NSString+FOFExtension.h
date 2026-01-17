//
//  NSString+FOFExtension.h
//  FOF
//
//  Created by hanchuangkeji on 2017/7/19.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FOFExtension)

+ (BOOL)isValidateName:(NSString *)name min:(int)min max:(int )max;


+(NSString *)dateToOld:(NSInteger )bornDate;

@end
