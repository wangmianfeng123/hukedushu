//
//  HKPlayerFullScreenSimilarVideoView.h
//  Code
//
//  Created by Ivan li on 2018/4/24.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HKPlayerFullScreenSimilarVideoDelegate <NSObject>

@optional

/** cell 点击 */
- (void)hkplayerFullScreenCellClick:(NSIndexPath*)index sender:(id)sender  collectionView:(UICollectionView*)collectionView;

/** 重播 */
- (void)hkplayerFullScreenRepeatBtnClick:(id)sender;

@end

@interface HKPlayerFullScreenSimilarVideoView : UIView

@property(nonatomic,weak)id <HKPlayerFullScreenSimilarVideoDelegate> delegate;

@property (nonatomic,strong) NSMutableArray *dataArray;

/** 销毁视图*/
- (void)removeView;

@end
