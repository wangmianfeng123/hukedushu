//
//  HKAlbumDetailCell.h
//  Code
//
//  Created by Ivan li on 2018/8/29.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoModel;
@class HKLineLabel;
@class HKAlbumShadowImageView;

@interface HKAlbumDetailCell : UITableViewCell

/** 图片阴影 */
@property(nonatomic,strong)HKAlbumShadowImageView *bgImageView;

/** 无 PGC 收藏 使用model*/
@property(nonatomic,strong)VideoModel  *model;

/** 含有 PGC 收藏 使用model*/
@property(nonatomic,strong)CollectionListModel *listModel;

/** 阴影显示(YES) 默认显示  */
@property(nonatomic,assign)BOOL isShowShadow;

/** 观看次数 */
//@property(nonatomic,strong,readwrite)UILabel *watchLabel;

@end


