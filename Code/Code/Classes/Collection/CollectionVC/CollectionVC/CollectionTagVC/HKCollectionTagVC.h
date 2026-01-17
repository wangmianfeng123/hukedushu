//
//  HKCollectionTagVC.h
//  Code
//
//  Created by Ivan li on 2017/12/19.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKBaseVC.h"

@class SeriseTagModel;

@interface HKCollectionTagVC : HKBaseVC
@property(nonatomic,copy)void(^tagSelectBlock)( NSIndexPath *indexPath,SeriseTagModel *model);

- (instancetype)initWithModelArray: (NSMutableArray<SeriseTagModel*>*)modelArr;

@end

