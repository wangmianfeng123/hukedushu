//
//  HKAudioListVC.h
//  Code
//
//  Created by Ivan li on 2018/3/20.
//  Copyright © 2018年 pg. All rights reserved.
//



#import "WMPageControllerTool.h"

@class CategoryModel;

@interface HKAudioListVC : WMPageControllerTool

- (instancetype)initWithTitle:(NSString *)title;

@property (nonatomic,copy) NSString * title;

@end
