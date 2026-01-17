//
//  HKUserEditPicCell.h
//  Code
//
//  Created by Ivan li on 2018/3/15.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface HKUserEditPicCell : UITableViewCell

/** 头像 */
@property(nonatomic,strong)UIImageView *coverImageView;
/** 图片 data */
@property(nonatomic,strong)NSData *imageData;

@property(nonatomic,strong)UILabel *setLabel;


+ (instancetype)initCellWithTableView:(UITableView *)tableView;

@end
