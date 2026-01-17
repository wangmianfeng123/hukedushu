//
//  HKSearchPgcCell.h
//  Code
//
//  Created by Ivan li on 2018/3/16.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@class VideoModel;
@class HKLineLabel;
@class HKShadowImageView;

@interface HKSearchPgcCell : UICollectionViewCell

/** 图片阴影 */
@property(nonatomic,strong)HKShadowImageView *bgImageView;

/** 无 PGC 收藏 使用model*/
@property(nonatomic,strong)VideoModel  *model;

/** 含有 PGC 收藏 使用model*/
@property(nonatomic,strong)CollectionListModel *listModel;

/** 阴影显示(YES) 默认显示  */
@property(nonatomic,assign)BOOL isShowShadow;

/** 搜索页 名师机构 使用*/
@property(nonatomic,strong)VideoModel *searchVideoModel;

@end


