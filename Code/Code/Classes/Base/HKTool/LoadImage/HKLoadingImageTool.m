//
//  HKLoadingImageTool.m
//  Code
//
//  Created by eon Z on 2022/10/9.
//  Copyright © 2022 pg. All rights reserved.
//

#import "HKLoadingImageTool.h"

@implementation HKLoadingImageTool

+ (NSString *)transitionImageUrlString:(NSString *)str{
    if(@available(iOS 14.0, *)){
        return str;
    }else{
        if([str containsString:@"/format/webp"]){
            return [str stringByReplacingOccurrencesOfString:@"/format/webp" withString:@""];
        }else{
            return str;;
        }
    }
}

@end
