//
//  HKStudyrRecommendCell.h
//  Code
//
//  Created by Ivan li on 2019/3/24.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class VideoModel;

@interface HKStudyrRecommendCell : UITableViewCell

+ (instancetype)initCellWithTableView:(UITableView *)tableview;

@property(nonatomic,strong)VideoModel *model;
/** 收藏按钮回调 */
@property(nonatomic,copy)void (^collectBtnClickCallBack)(UIButton *btn, VideoModel *model);

@end

NS_ASSUME_NONNULL_END



