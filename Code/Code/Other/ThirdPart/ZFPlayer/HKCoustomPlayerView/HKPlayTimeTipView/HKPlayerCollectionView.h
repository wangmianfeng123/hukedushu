//
//  HKPlayerCollectionView.h
//  Code
//
//  Created by Ivan li on 2018/4/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HKPlayerCollectionViewDelagate <NSObject>

@optional
- (void)hkplayerCollectionCellClick:(NSIndexPath*)index sender:(id)sender  collectionView:(UICollectionView*)collectionView;

@end



@interface HKPlayerCollectionView : UICollectionView

@property (nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic,weak)id <HKPlayerCollectionViewDelagate>playerCollectionViewDelagate;

@end




@interface HKPlayerCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) VideoModel *model;

@end
