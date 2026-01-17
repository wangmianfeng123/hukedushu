//
//  SeriesCourseTagVC.h
//  Code
//
//  Created by Ivan li on 2017/10/26.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKBaseVC.h"

@class SeriseTagModel;

@interface SeriesCourseTagVC : HKBaseVC
@property(nonatomic,copy)void(^tagSelectBlock)( NSIndexPath *indexPath,SeriseTagModel *model);

- (instancetype)initWithModelArray: (NSMutableArray<SeriseTagModel*>*)modelArr;

@end
