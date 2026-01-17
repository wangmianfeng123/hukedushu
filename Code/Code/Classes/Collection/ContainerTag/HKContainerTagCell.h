//
//  HKContainerTagCell.h
//  Code
//
//  Created by Ivan li on 2017/12/19.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "TBCollectionHighLightedCell.h"

//@class SeriseTagModel;

@class AlbumSortTagModel;

@interface HKContainerTagCell : TBCollectionHighLightedCell

@property(nonatomic,copy)void(^tagSelectedBlock)(NSIndexPath *index);

@property(nonatomic,strong)AlbumSortTagModel *model;

//显示 选中 图标
- (void)showAngleImage:(BOOL)isShow;



@end
