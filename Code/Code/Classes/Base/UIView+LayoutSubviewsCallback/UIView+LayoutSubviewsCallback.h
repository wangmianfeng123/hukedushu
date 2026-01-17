//
//  UIView+LayoutSubviewsCallback.h
//  Code
//
//  Created by ivan on 2020/5/18.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LayoutSubviewsCallback)

@property (nonatomic, copy) void(^layoutSubviewsCallback)(UIView *view);

@end
