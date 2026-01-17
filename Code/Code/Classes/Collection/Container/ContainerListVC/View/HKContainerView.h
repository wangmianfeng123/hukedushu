//
//  HKContainerView.h
//  Code
//
//  Created by Ivan li on 2017/11/27.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKAlbumModel;
@class DetailModel;

@interface HKContainerView : UIView

@property (nonatomic,copy) void(^selectContainerBlock)(HKAlbumModel *model); //选择回调

@property (nonatomic,strong)DetailModel *detailModel;


@end
