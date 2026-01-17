//
//  HKEditTagCell.h
//  Code
//
//  Created by Ivan li on 2017/12/20.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKCategoryAlbumModel;

@class HKCustomMarginLabel;

@interface HKEditTagCell : UITableViewCell {
    UILabel *tagLabel[5];
}

@property(nonatomic,strong)UIImageView *coverImageView;

@property(nonatomic,strong)HKCustomMarginLabel *firstLabel;

@property(nonatomic,strong)HKCustomMarginLabel *secondLabel;

@property(nonatomic,strong)HKCustomMarginLabel *thirdLabel;

@property(nonatomic,strong)HKCategoryAlbumModel *model;

+ (instancetype)initCellWithTableView:(UITableView *)tableView;




@end
