//
//  HKBulidContainerVC.h
//  Code
//
//  Created by Ivan li on 2017/11/27.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKBaseVC.h"

@class DetailModel,HKAlbumModel;

@interface HKBulidContainerVC : HKBaseVC

@property (nonatomic,strong)DetailModel *detailModel;

/** 新建专辑回调 */
@property (nonatomic,copy) void(^hkBulidContainerVCBlock)(HKAlbumModel *model);

@end
