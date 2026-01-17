//
//  HkDesignTableVC.h
//  Code
//
//  Created by Ivan li on 2019/8/1.
//  Copyright © 2019 pg. All rights reserved.
//

#import "WMStickyPageControllerTool.h"

@class HKDesignTypeModel;

@interface DesignTableVC : WMStickyPageControllerTool

@property (nonatomic,copy)NSString *category;

@property (nonatomic,copy)NSString *name;

@property (nonatomic , strong) HKDesignTypeModel * typeModel;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
                       category:(NSString*)category
                           name:(NSString*)name;


/** 选中筛选tag */
@property(nonatomic,copy)NSString *defaultSelectedTag;

@end
