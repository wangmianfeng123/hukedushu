//
//  ZFHKPlayerLandScapeSimilarVideoView.h
//  Code
//
//  Created by Ivan li on 2019/3/17.
//  Copyright © 2019年 pg. All rights reserved.
//



@protocol ZFHKPlayerLandScapeSimilarVideoViewDelegate <NSObject>

@optional

/** cell 点击 */
- (void)zfHKPlayerLandScapeSimilarVideoView:(UICollectionView*)collectionView videoModel:(VideoModel*)model;

/** 重播 */
- (void)zfHKPlayerLandScapeSimilarVideoView:(UIView*)view repeatBtnClick:(id)sender;

@end

@interface ZFHKPlayerLandScapeSimilarVideoView : UIView

@property(nonatomic,weak)id <ZFHKPlayerLandScapeSimilarVideoViewDelegate> delegate;

@property (nonatomic,strong) NSMutableArray *dataArray;

/** 销毁视图*/
- (void)removeView;

@end
