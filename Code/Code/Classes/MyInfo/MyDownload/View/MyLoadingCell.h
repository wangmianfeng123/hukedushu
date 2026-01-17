//
//  MyLoadingCell.h
//  Code
//
//  Created by Ivan li on 2017/8/28.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKDownloadModel;


typedef void (^SelectedBlock)(BOOL value,HKDownloadModel *model); //选中


typedef void(^ZFNormalBtnClickBlock)(HKDownloadModel *model);

@interface MyLoadingCell : UITableViewCell

/// 封面
@property(nonatomic,strong)UIImageView *iconImageView;
/// 标题
@property(nonatomic,strong)UILabel *titleLabel;
/// 时长
@property(nonatomic,strong)UILabel *timeLabel;
/// 下载状态
@property(nonatomic,strong)UILabel *statusLabel;
/// 下载进度
@property(nonatomic,strong)UILabel *progressLabel;

@property(nonatomic,strong)UIButton *downloadBtn;

@property(strong, nonatomic)UIProgressView  *progress;

@property(nonatomic,copy)SelectedBlock    selectBlock;

@property(nonatomic,assign)NSInteger    edit;

@property(nonatomic,strong)UIButton *selectBtn;

@property(nonatomic,strong)UIView *cellBgView;

///** 下载按钮点击回调block */
@property (nonatomic, copy) ZFNormalBtnClickBlock  btnClickBlock;
///** 下载信息模型 */
@property(nonatomic, strong)HKDownloadModel   *downloadModel;

#pragma mark - 下载时刷新
- (void)updateDownloadModel:(HKDownloadModel *)downloadModel;

- (void)clickAllRow:(BOOL)selected;

- (void)setAllModel:(HKDownloadModel *)downloadModel isEdit:(BOOL)isEdit;


@end


