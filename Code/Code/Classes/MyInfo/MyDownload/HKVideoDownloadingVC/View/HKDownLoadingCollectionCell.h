//
//  HKDownLoadingCollectionCell.h
//  Code
//
//  Created by Ivan li on 2019/11/11.
//  Copyright © 2019 pg. All rights reserved.
//


#import <UIKit/UIKit.h>


@class HKDownloadModel;

NS_ASSUME_NONNULL_BEGIN

typedef void (^SelectedBlock)(BOOL value,HKDownloadModel *model); //选中

typedef void(^ZFNormalBtnClickBlock)(HKDownloadModel *model);


@interface HKDownLoadingCollectionCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *iconImageView;

@property(nonatomic,strong)UILabel *titleLabel;
/// 时长
@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UIButton *downloadBtn;

@property(strong, nonatomic)UIProgressView  *progress;

@property (nonatomic,copy) SelectedBlock    selectBlock;

@property (nonatomic,assign) NSInteger    edit;

@property(nonatomic,strong)UIButton *selectBtn;

@property(nonatomic,strong)UIView *cellBgView;
/// 下载状态
@property(nonatomic,strong)UILabel *statusLB;


///** 下载按钮点击回调block */
@property (nonatomic, copy) ZFNormalBtnClickBlock  btnClickBlock;
///** 下载信息模型 */
@property(nonatomic, copy)HKDownloadModel   *downloadModel;

#pragma mark - 下载时刷新
- (void)updateDownloadModel:(HKDownloadModel *)downloadModel;

- (void)clickAllRow:(BOOL)selected;

- (void)setAllModel:(HKDownloadModel *)downloadModel isEdit:(BOOL)isEdit;

@end

NS_ASSUME_NONNULL_END

