//
//  HKHomeRecomandVC.h
//  Code
//
//  Created by eon Z on 2021/11/1.
//  Copyright © 2021 pg. All rights reserved.
//

#import "WMPageControllerTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKHomeRecomandVC : WMPageControllerTool

@property (nonatomic , strong) NSMutableArray * dataArray;

@property (nonatomic , assign) BOOL isNetDataRefresh;

@end

NS_ASSUME_NONNULL_END
