//
//  HKBulidAlbumVCDialog.h
//  Code
//
//  Created by Ivan li on 2018/7/31.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKBaseVC.h"

@class DetailModel,HKAlbumModel;

@interface HKBulidAlbumVCDialog : HKBaseVC

@property (nonatomic,strong)DetailModel *detailModel;

/** 新建专辑回调 */
@property (nonatomic,copy) void(^hKBulidAlbumBlock)(HKAlbumModel *model);

@end
