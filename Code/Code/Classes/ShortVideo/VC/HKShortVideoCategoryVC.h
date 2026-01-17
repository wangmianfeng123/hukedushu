//
//  HKAudioListVC.h
//  Code
//
//  Created by Ivan li on 2018/3/20.
//  Copyright © 2018年 pg. All rights reserved.
//



//#import <WMPageController/WMPageController.h>
#import "WMPageControllerTool.h"

@class CategoryModel;

@interface HKShortVideoCategoryVC : WMPageControllerTool

/**
 滚动到需要选中的 tab

 @param tagId 分类ID
 */
- (void)scorllSelectTabWithTagId:(NSString*)tagId;

@end
