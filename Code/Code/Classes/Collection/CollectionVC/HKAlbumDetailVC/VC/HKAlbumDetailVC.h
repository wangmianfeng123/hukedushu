//
//  HKAlbumDetailVC.h
//  Code
//
//  Created by Ivan li on 2017/12/3.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKBaseVC.h"

@class HKAlbumModel;
@class HKAlbumListModel;

typedef void(^OperationAlbumActionBlock)(HKAlbumListModel *model);// 收藏／取消 集合


@interface HKAlbumDetailVC : HKBaseVC

@property(nonatomic,copy)OperationAlbumActionBlock operationAlbumActionBlock;

- (instancetype)initWithAlbumModel:(HKAlbumModel*) model;

- (instancetype)initWithAlbumModel:(HKAlbumModel*) model isMyAblum:(BOOL)isMyAblum;

@end
