//
//  HKUserTaskCell.h
//  Code
//
//  Created by Ivan li on 2018/7/5.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKTaskModel;

@interface HKUserTaskCell : UITableViewCell

/** 作品封面 */
@property(nonatomic,strong)UIImageView *picImageView;

@property(nonatomic,strong)UILabel *titleLB;
/** 观看人数 */
@property(nonatomic,strong)UILabel *scanCountLB;
/** 点赞人数 */
@property(nonatomic,strong)UILabel *praiseCountLB;
/** 评论人数 */
@property(nonatomic,strong)UILabel *commentCountLB;

@property(nonatomic,strong)HKTaskModel *model;

+ (instancetype)initCellWithTableView:(UITableView *)tableView;

@end
