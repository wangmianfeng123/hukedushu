//
//  HKBaseTaskCell.h
//  Code
//
//  Created by Ivan li on 2018/7/15.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface HKBaseTaskCell : UITableViewCell

@property(nonatomic,strong)UIImageView *vipImageView;

@property(nonatomic,strong)NSIndexPath *indexPath;
/**头像*/
@property(nonatomic,strong)UIButton *iconImageView;
/**昵称*/
@property(nonatomic,strong)UILabel *nameLabel;
/**详细文本*/
@property(nonatomic,strong)UILabel *detailINfoLabel;
/**时间*/
@property(nonatomic,strong)UILabel *timeLabel;
/** 封面 */
@property(nonatomic,strong)UIImageView *coverImageView;

@end


