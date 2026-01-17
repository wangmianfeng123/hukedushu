//
//  HKShortVideoHomeVC.h
//  Code
//
//  Created by Ivan li on 2018/3/2.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "WMPageControllerTool.h"

@protocol HKShortVideoHomeVCDelegate <NSObject>

@optional
- (void)superViewWillDisappear:(BOOL)animated;

- (void)superViewDidAppear:(BOOL)animated;

@end

@interface HKShortVideoHomeVC : WMPageControllerTool

@property (nonatomic, weak)id<HKShortVideoHomeVCDelegate> viewDelegate;

@end
