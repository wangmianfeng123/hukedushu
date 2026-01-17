
//
//  HKPhotoBrowser.m
//  Code
//
//  Created by Ivan li on 2018/8/27.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKPhotoBrowserTool.h"
#import "XLPhotoBrowser.h"

@implementation HKPhotoBrowserTool

+ (XLPhotoBrowser*)initPhotoBrowserWithUrl:(NSString *)url {
    
    if (isEmpty(url)) {
        return nil;
    }
    // 创建图片浏览器
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithImages:@[url] currentImageIndex:0];
    // 自定义一些属性
    browser.pageDotColor = [UIColor grayColor];
    browser.currentPageDotColor = [UIColor whiteColor];
    browser.browserStyle = XLPhotoBrowserStyleIndexLabel;
    //< 修改底部pagecontrol的样式为系统样式,默认是弹性动画的样式
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleAnimated;
    // 设置长按手势弹出的地步ActionSheet数据,不实现此方法则没有长按手势
    //[browser setActionSheetWithTitle:nil delegate:self cancelButtonTitle:nil deleteButtonTitle:nil otherButtonTitles:@"保存图片",nil];
    return browser;
}

+ (XLPhotoBrowser*)initPhotoBrowserWithUrlArray:(NSMutableArray *)urlArray withIndex:(NSInteger)currentImageIndex delegate:(UIViewController *)vc{
    if (!urlArray.count) {
        return nil;
    }
    // 创建图片浏览器
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithImages:urlArray currentImageIndex:currentImageIndex];
    // 自定义一些属性
    browser.pageDotColor = [UIColor grayColor];
    browser.currentPageDotColor = [UIColor whiteColor];
    browser.browserStyle = XLPhotoBrowserStyleIndexLabel;
    //< 修改底部pagecontrol的样式为系统样式,默认是弹性动画的样式
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleAnimated;
    // 设置长按手势弹出的地步ActionSheet数据,不实现此方法则没有长按手势
    [browser setActionSheetWithTitle:nil delegate:vc cancelButtonTitle:nil deleteButtonTitle:nil otherButtonTitles:@"保存图片",nil];
    return browser;
}


@end
