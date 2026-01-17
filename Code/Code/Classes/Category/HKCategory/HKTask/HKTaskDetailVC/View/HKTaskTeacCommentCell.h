//
//  HKTaskTeacCommentCell.h
//  Code
//
//  Created by Ivan li on 2018/7/16.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKTaskPraiseBtn.h"


@class HKTaskDetailModel;

@protocol HKTaskTeacCommentCellDelegate <NSObject>

- (void)reloadTaskTeacCommentCell:(HKTaskDetailModel*)model indexPath:(NSIndexPath *)indexPath;

@end


@interface HKTaskTeacCommentCell : UITableViewCell


@property(nonatomic,weak)id <HKTaskTeacCommentCellDelegate> delegate;

@property(nonatomic,strong)UILabel *commentLB;

@property(nonatomic,strong)UIImageView *teacCommentIV;
/** 作品图片 */
@property(nonatomic,strong)UILabel *scanImageLB;

@property(nonatomic,strong)HKTaskDetailModel *model;

@property(nonatomic,strong)UIView *bgView;

@property(nonatomic,strong)NSIndexPath *indexPath;

@property(nonatomic,strong)UIButton *praiseBtn;

@property(nonatomic,strong)HKTaskPraiseBtn *hkPraiseBtn;


+ (instancetype)initCellWithTableView:(UITableView *)tableview;

@end
