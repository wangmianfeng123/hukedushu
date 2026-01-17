//
//  HKHomeVipVideoCell.h
//  Code
//
//  Created by ivan on 2020/6/23.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKHomeVipVideoCell : UICollectionViewCell

@property(nonatomic,strong)NSMutableArray<VideoModel *> *videoArr;

@property(nonatomic, copy)void(^videoSelectedBlock)(NSIndexPath *indexPath, VideoModel *videoModel);

@end



@interface HKHomeVipVideoChildCell : UICollectionViewCell

@property (nonatomic, strong)VideoModel *model;

@end

NS_ASSUME_NONNULL_END
