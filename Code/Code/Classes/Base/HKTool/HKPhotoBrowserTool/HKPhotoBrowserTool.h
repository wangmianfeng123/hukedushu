//
//  HKPhotoBrowser.h
//  Code
//
//  Created by Ivan li on 2018/8/27.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XLPhotoBrowser;

@interface HKPhotoBrowserTool : NSObject

+ (XLPhotoBrowser*)initPhotoBrowserWithUrl:(NSString *)url;

+ (XLPhotoBrowser*)initPhotoBrowserWithUrlArray:(NSMutableArray *)urlArray withIndex:(NSInteger)currentImageIndex delegate:(UIViewController *)vc;

//showPhotoBrowserWithImages:(NSArray *)images currentImageIndex:(NSInteger)currentImageIndex

@end
