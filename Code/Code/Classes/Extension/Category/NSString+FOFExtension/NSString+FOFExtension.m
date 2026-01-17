//
//  NSString+FOFExtension.m
//  FOF
//
//  Created by hanchuangkeji on 2017/7/19.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "NSString+FOFExtension.h"

@implementation NSString (FOFExtension)

/**
 判断字符数量，汉字为2

 @param name 字符串
 @param min 最小个数
 @param max 最大个数
 @return 正确
 */
+ (BOOL)isValidateName:(NSString *)name min:(int)min max:(int )max{
    NSUInteger  character = 0;
    for(int i=0; i< [name length];i++){
        int a = [name characterAtIndex:i];
        if( a >= 0x4e00 && a <= 0x9fa5){ //判断是否为中文
            character +=2;
        }else{
            character +=1;
        }
    }
    
    if (min <= character && character <= max) {
        return YES;
    }else{
        return NO;
    }
    
}


/**
 根据出生日期返回年龄的方法
 
 @param bornDate 时间戳
 @return <#return value description#>
 */
+(NSString *)dateToOld:(NSInteger )bornDate{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:(int)bornDate];
    
    //获得当前系统时间
    NSDate *currentDate = [NSDate date];
    
    //获得当前系统时间与出生日期之间的时间间隔
    NSTimeInterval time = [currentDate timeIntervalSinceDate:confromTimesp];
    
    //时间间隔以秒作为单位,求年的话除以60*60*24*356
    int age = ((int)time) / (3600*24*365);
    return [NSString stringWithFormat:@"%d",age];
}


@end
