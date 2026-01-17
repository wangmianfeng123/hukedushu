//
//  SeriseCourseiPadCell.h
//  Code
//
//  Created by eon Z on 2022/3/14.
//  Copyright © 2022 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SeriseCourseiPadCell : UICollectionViewCell

/** 搜素页 赋值使用 */
@property(nonatomic,strong)VideoModel *videoModel;

@property(nonatomic,strong)VideoModel  *model;
@property (nonatomic , strong)NSIndexPath * index;
@end

NS_ASSUME_NONNULL_END
