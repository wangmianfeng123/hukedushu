//
//  HKBulidAlbumCell.h
//  Code
//
//  Created by Ivan li on 2018/7/30.
//  Copyright © 2018年 pg. All rights reserved.
//

@class HKAlbumModel;
@class HKAlbumShadowImageView;

@interface HKBulidAlbumCell : UITableViewCell

+ (instancetype)initCellWithTableView:(UITableView *)tableview;

@property(nonatomic,strong)HKAlbumModel *model;

/** 图片阴影 */
@property(nonatomic,strong)HKAlbumShadowImageView *bgImageView;

@end



