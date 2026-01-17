//
//  HKMyInfoSetCell.h
//  Code
//
//  Created by Ivan li on 2018/9/26.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKMyInfoMapPushModel;

@protocol HKMyInfoSetCellDelegate <NSObject>

- (void)myInfoSetCellClickAction:(HKMyInfoMapPushModel*)model indexPath:(NSIndexPath*)indexPath;

@end


@interface HKMyInfoSetCell : UICollectionViewCell<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TBSrollViewEmptyDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray <HKMyInfoMapPushModel*>*dataArr;

@property (nonatomic,weak) id <HKMyInfoSetCellDelegate> delegate;

@end
