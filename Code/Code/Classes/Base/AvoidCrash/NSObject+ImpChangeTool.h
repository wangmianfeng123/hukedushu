//
//  NSObject+ImpChangeTool.h
//  Code
//
//  Created by hanchuangkeji on 2019/1/15.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ImpChangeTool)
/**
 *  交换两个函数实现指针  参数均为NSString类型
 *
 *  @param systemMethodString 系统方法名string
 *  @param systemClassString  系统实现方法类名string
 *  @param safeMethodString   自定义hook方法名string
 *  @param targetClassString  目标实现类名string
 */
+ (void)SwizzlingMethod:(NSString *)systemMethodString systemClassString:(NSString *)systemClassString toSafeMethodString:(NSString *)safeMethodString targetClassString:(NSString *)targetClassString;
@end
