//
//  LearnedCell.h
//  Code
//
//  Created by Ivan li on 2017/7/22.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@class  DownloadModel, VideoModel, HKAlbumShadowImageView,HKCustomMarginLabel;


@interface LearnedCell : UITableViewCell

@property(nonatomic,assign)BOOL isEdit;

@property(nonatomic,copy)void (^learnedCellBlock)(VideoModel  *model);
@property(nonatomic,strong)VideoModel  *model;

//- (void)updateEditAllConstraints;
//
//- (void)updateNoEditAllConstraints;

/**编辑状态下 点击 cell 选中 */
- (void)editSelectRow;

@end



