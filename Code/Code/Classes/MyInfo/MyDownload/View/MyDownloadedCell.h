//
//  MyDownloadedCell.h
//  Code
//
//  Created by Ivan li on 2017/8/23.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HKDownloadModel;

@class HKAlbumShadowImageView;





typedef void (^SelectedBlock)(BOOL value); //选中

@interface MyDownloadedCell : UITableViewCell


@property(nonatomic,strong)UIImageView *iconImageView;
/** 图片阴影 */
@property(nonatomic,strong)HKAlbumShadowImageView *bgImageView;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *categoryLabel;

@property(nonatomic,strong)UILabel *sizeLabel;

@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UIButton *selectBtn;

@property(nonatomic, strong)UIButton *isStudyBtn; // 是否已经观看

@property(nonatomic, copy)HKDownloadModel   *downloadModel;

@property (nonatomic,copy) SelectedBlock    selectBlock;

@property (nonatomic,assign) NSInteger    edit;

@property(nonatomic, strong)UIView *blackView;

@property (nonatomic, strong)UILabel *countLB;


- (void)clickAllRow:(BOOL)selected;

- (void)setAllModel:(HKDownloadModel *)downloadModel isEdit:(BOOL)isEdit;

@end
