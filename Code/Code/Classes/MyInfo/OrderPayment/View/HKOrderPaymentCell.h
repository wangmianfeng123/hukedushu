//
//  HKOrderPaymentCell.h
//  Code
//
//  Created by hanchuangkeji on 2017/12/13.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKOrderPaymentModel.h"



@protocol HKOrderPaymentCellDelegate <NSObject>
@optional
- (void)immediateStudy:(id)sender;
@end

@class HKPgcCourseModel;

@class HKAlbumShadowImageView;

@interface HKOrderPaymentCell : UITableViewCell

@property (nonatomic, weak)id <HKOrderPaymentCellDelegate> delegate;

@property (nonatomic, strong)HKPgcCourseModel *model;

/** 图片阴影 */
@property(nonatomic,strong)HKAlbumShadowImageView *bgImageView;

@end
