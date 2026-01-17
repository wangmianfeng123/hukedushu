//
//  ZFHKPlayerLandScapeSimilarVideoCollectionView.h
//  Code
//
//  Created by Ivan li on 2019/3/18.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZFHKPlayerLandScapeSimilarVideoCollectionViewDelagate <NSObject>

@optional
- (void)zfHKPlayerLandScapeSimilarVideoCollectionView:(UICollectionView*)collectionView videoModel:(VideoModel*)model;

@end



@interface ZFHKPlayerLandScapeSimilarVideoCollectionView : UICollectionView

@property (nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic,weak)id <ZFHKPlayerLandScapeSimilarVideoCollectionViewDelagate> playerCollectionViewDelagate;

@end




@protocol ZFHKPlayerLandScapeSimilarCollectionViewCellDelagate <NSObject>

@optional
- (void)zfHKPlayerLandScapeSimilarCollectionViewCell:(VideoModel*)model;

@end

@interface ZFHKPlayerLandScapeSimilarCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) VideoModel *model;

@property(nonatomic,weak)id <ZFHKPlayerLandScapeSimilarCollectionViewCellDelagate>delegate;

@end
