//
//  HKSearchAlbumCell.h
//  Code
//
//  Created by Ivan li on 2018/3/16.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKAlbumModel;

@interface HKSearchAlbumCell : UICollectionViewCell

@property(nonatomic,strong)HKAlbumModel *model;
/** 搜索页 赋值 使用 */
@property(nonatomic,strong)VideoModel *videoModel;

@end
