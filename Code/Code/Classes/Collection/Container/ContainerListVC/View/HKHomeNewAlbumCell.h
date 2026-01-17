//
//  HKHomeNewAlbumCell.h
//  Code
//
//  Created by yxma on 2020/11/11.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKAlbumModel;

@interface HKHomeNewAlbumCell : UICollectionViewCell

@property (nonatomic , strong) NSArray * dataArray;

@property (nonatomic , strong) HKAlbumModel * model;

@property (nonatomic , strong) void(^moreClickBlock)(BOOL isAllAlbum);

@property (nonatomic , strong) void(^cellClickBlock)(NSObject * obj);

@end

NS_ASSUME_NONNULL_END
