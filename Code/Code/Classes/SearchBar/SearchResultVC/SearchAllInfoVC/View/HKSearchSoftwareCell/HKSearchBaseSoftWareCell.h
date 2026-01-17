//
//  HKSearchBaseSoftWareCell.h
//  Code
//
//  Created by Ivan li on 2019/4/9.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKCustomMarginLabel;

@interface HKSearchBaseSoftWareCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *iconImageView;

@property(nonatomic,strong)UILabel *titleLabel;
/** 学习次数 */
@property(nonatomic,strong)UILabel *studyCountLabel;
/** 教程数 */
@property(nonatomic,strong)UILabel *courseLabel;

@property(nonatomic,strong)UILabel *lineLabel;
/** 练习数 */
@property(nonatomic,strong)UILabel *exerciseLabel;
/** 更新状态 */
@property(nonatomic,strong)HKCustomMarginLabel *stateLabel;

@property(nonatomic,strong)VideoModel *model;

- (void)createUI;

- (void)makeConstraints;

- (void)setModel:(VideoModel *)model;

@end

NS_ASSUME_NONNULL_END
