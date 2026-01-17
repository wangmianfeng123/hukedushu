//
//  SeriesCourseTagCell.h
//  Code
//
//  Created by Ivan li on 2017/10/26.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SeriseTagModel;

@interface SeriesCourseTagCell : TBCollectionHighLightedCell

@property(nonatomic,copy)void(^tagSelectedBlock)(NSIndexPath *index);

@property(nonatomic,strong)SeriseTagModel *model;

//显示 选中 图标
- (void)showAngleImage:(BOOL)isShow;



@end
