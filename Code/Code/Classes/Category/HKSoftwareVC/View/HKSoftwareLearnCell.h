//
//  HKSoftwareLearnCell.h
//  Code
//
//  Created by Ivan li on 2018/4/1.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKSoftwareLearnCell : UICollectionViewCell

@property(nonatomic,strong)NSMutableArray<VideoModel *> *seriesArr;

@property(nonatomic, copy)void(^videoSelectedBlock)(NSIndexPath *indexPath, VideoModel *videoNodel);

@end
