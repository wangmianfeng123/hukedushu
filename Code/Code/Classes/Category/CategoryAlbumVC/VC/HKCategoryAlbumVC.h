//
//  HKCategoryAlbumVC.h
//  Code
//
//  Created by Ivan li on 2017/12/4.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKBaseVC.h"

@class CategoryModel;

@interface HKCategoryAlbumVC : HKBaseVC
@property(nonatomic,copy)NSString *category;


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil category:(NSString*)category;

- (instancetype)initWithModel:(CategoryModel*)model;

@end
