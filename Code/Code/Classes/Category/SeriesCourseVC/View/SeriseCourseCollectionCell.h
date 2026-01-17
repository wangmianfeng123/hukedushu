//
//  SeriseCourseCollectionCell.h
//  Code
//
//  Created by Ivan li on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeriseCourseModel;

@interface SeriseCourseCollectionCell : TBCollectionHighLightedCell

@property(nonatomic,strong)SeriseCourseModel *model;

//@property (nonatomic, strong)NSIndexPath *indexPath;

/** 搜素页 赋值使用 */
@property(nonatomic,strong)VideoModel *videoModel;

//- (void)setModel:(SeriseCourseModel *)model hideLine1:(BOOL)hideLine1 hideLine2:(BOOL)hideLine2;




@end


