//
//  HKPlayerSimilarVideoCell.h
//  Code
//
//  Created by Ivan li on 2018/4/18.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HKPlayerSimilarVideoCellDelagate <NSObject>

@optional
- (void)hkplayerSimilarVideoCellClick:(id)sender;

- (void)hkplayerRepeatVideoClick:(id)sender;

@end


/** 相似 推荐 */
@interface HKPlayerSimilarVideoCell : UICollectionViewCell

@property (nonatomic,strong)VideoModel *model;

@property(nonatomic,weak)id <HKPlayerSimilarVideoCellDelagate> playerSimilarVideoDelagate;
/** 销毁视图 */
- (void)removeView;

@end
