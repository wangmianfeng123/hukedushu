//
//  HKHtmlDialogVC.h
//  Code
//
//  Created by Ivan li on 2018/8/22.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKBaseVC.h"

@class BannerModel;

@interface HKHtmlDialogVC : HKBaseVC

@property(nonatomic,copy)void(^htmlLoadFinishBlock)(BOOL finish ,HKHtmlDialogVC *dialogVC);

@property(nonatomic,strong)void(^htmlCloseBlock)(void);

- (instancetype)initWithUrl:(NSString*)url;

@property(nonatomic,assign)BOOL hiddenNavigationBar;

@end
