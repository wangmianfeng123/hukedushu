//
//  HKCategoryAlbumCell.h
//  Code
//
//  Created by Ivan li on 2017/12/4.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKAlbumModel;

@interface HKCategoryAlbumCell : UITableViewCell

@property(nonatomic,strong)HKAlbumModel *model;

+ (instancetype)initCellWithTableView:(UITableView *)tableView;
@end
