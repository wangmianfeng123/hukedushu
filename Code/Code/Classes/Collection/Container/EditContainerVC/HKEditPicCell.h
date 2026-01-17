//
//  HKEditPicCell.h
//  Code
//
//  Created by Ivan li on 2017/12/20.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKCategoryAlbumModel;



@interface HKEditPicCell : UITableViewCell

@property(nonatomic,strong)UIImageView *coverImageView;

@property(nonatomic,strong)UIImage *image;

@property(nonatomic,strong)HKCategoryAlbumModel *model;

@property(strong, nonatomic)UIImageView *rightIV;


+ (instancetype)initCellWithTableView:(UITableView *)tableView;

@end
