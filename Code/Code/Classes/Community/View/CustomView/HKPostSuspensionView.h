//
//  HKPostSuspensionView.h
//  Code
//
//  Created by Ivan li on 2021/1/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKPostSuspensionView : UIView
@property (nonatomic , strong) void(^didMonmentBlock)(void);
@property (nonatomic , strong) void(^didQuestionBlock)(void);
@property (nonatomic , strong) void(^didCloseBlock)(void);
@property (nonatomic , strong) UIImage *shootImage;

@end

NS_ASSUME_NONNULL_END
