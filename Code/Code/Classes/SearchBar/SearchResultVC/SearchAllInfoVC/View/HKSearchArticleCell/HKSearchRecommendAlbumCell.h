//
//  HKSearchRecommendAlbumCell.h
//  Code
//
//  Created by Ivan li on 2019/4/17.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKAlbumModel,  HKTeacherMatchModel;

@interface HKSearchRecommendAlbumCell : UICollectionViewCell

/** 搜索页 赋值 使用 */
@property(nonatomic,strong)VideoModel *videoModel;
/** 教师目录 */
@property(nonatomic,strong)UILabel *categoryLb;
/** 更多 按钮 */
@property(strong, nonatomic)UIButton *moreBtn;
/** 更多 按钮 点击回调 */
@property(nonatomic,copy)void (^moreBtnClickBackCall)();

@property(strong, nonatomic)HKTeacherMatchModel *matchModel;

@end


NS_ASSUME_NONNULL_END
