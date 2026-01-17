//
//  HKRookieContainerCell.h
//  Code
//
//  Created by hanchuangkeji on 2017/11/14.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoftwareModel.h"

@interface HKRookieContainerCell : TBCollectionHighLightedCell

@property (nonatomic, copy)void(^rookieBlock)(NSIndexPath *indexPaht, SoftwareModel *model);

@property (nonatomic, strong)NSMutableArray<SoftwareModel *> *rookieArray;// 新手入门

@end
