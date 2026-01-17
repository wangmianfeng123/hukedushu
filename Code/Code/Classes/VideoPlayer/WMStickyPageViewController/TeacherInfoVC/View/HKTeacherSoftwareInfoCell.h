//
//  HKTeacherSoftwareInfoCell.h
//  Code
//
//  Created by Ivan li on 2018/4/23.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"
//#import "HKCourseModel.h"
#import "VideoModel.h"

//@interface HKTeacherSoftwareInfoCell : UICollectionViewCell

@interface HKTeacherSoftwareInfoCell : UITableViewCell

@property (nonatomic, strong)DetailModel *videoDetailModel;


+ (instancetype)initCellWithTableView:(UITableView *)tableView;

@end



