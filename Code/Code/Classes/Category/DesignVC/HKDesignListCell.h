//
//  HKDesignListCell.h
//  Code
//
//  Created by Ivan li on 2020/12/14.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKDesignListCell : UICollectionViewCell
@property (nonatomic, strong)NSIndexPath *indexPath;
@property(nonatomic,copy)VideoModel  *model;
@property (nonatomic, copy)void(^collectionBlock)(NSIndexPath *indexPath, VideoModel *model);

@end

NS_ASSUME_NONNULL_END
