//
//  HtmlShowVC.h
//  Code
//
//  Created by Ivan li on 2017/10/19.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKBaseVC.h"

@class BannerModel;

@interface HtmlShowVC : HKBaseVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil model:(BannerModel*)model;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:(NSString *)url;

@property(nonatomic,copy) void (^backActionCallBlock)(BOOL fullScreen);

#pragma mark - 返回前一个 html
- (void)backPreviousAction;

@end
