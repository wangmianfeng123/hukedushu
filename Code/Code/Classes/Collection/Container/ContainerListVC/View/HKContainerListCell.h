//
//  HKContainerListCell.h
//  Code
//
//  Created by Ivan li on 2017/11/26.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKAlbumModel;
@class HKAlbumShadowImageView;

@interface HKContainerListCell : UITableViewCell

+ (instancetype)initCellWithTableView:(UITableView *)tableview;

@property(nonatomic,strong)HKAlbumModel *model;

/** 图片阴影 */
@property(nonatomic,strong)HKAlbumShadowImageView *bgImageView;

@end



