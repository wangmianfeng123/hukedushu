//
//  SearchResultVC.h
//  Code
//
//  Created by Ivan li on 2017/9/1.
//  Copyright © 2017年 pg. All rights reserved.
// 


#import "WMPageControllerTool.h"



@interface SearchResultVC : WMPageControllerTool

@property (nonatomic , strong) NSArray * redirectWordsArray;
@property(nonatomic, copy)NSArray<UIViewController *> *viewcontrollers;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil keyWord:(NSString *)keyWord;

@end
