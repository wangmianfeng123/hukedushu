//
//  HKContainerTagVC.h
//  Code
//
//  Created by Ivan li on 2017/12/19.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKBaseVC.h"

@class AlbumSortTagListModel;

@class HKCategoryAlbumModel;

@interface HKContainerTagVC : HKBaseVC

//- (instancetype)initWithModelArray: (NSMutableArray<AlbumSortTagListModel*>*)modelArr;
- (instancetype)initWithModel:(HKCategoryAlbumModel *)albumModel;

@end
