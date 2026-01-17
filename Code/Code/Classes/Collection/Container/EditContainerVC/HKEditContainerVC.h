//
//  HKEditContainerVC.h
//  Code
//
//  Created by Ivan li on 2017/12/20.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKBaseVC.h"

@class HKAlbumListModel;

@interface HKEditContainerVC : HKBaseVC

/** 专辑 ID */
@property(nonatomic,copy)NSString *albumId;

@property(nonatomic,strong)HKAlbumListModel *model;

/** 编辑成功 回调 */
@property(nonatomic,copy)void (^hKEditContainerVCBlock)(HKAlbumListModel *albumM);

@end
