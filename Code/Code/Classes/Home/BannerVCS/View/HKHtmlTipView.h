//
//  HKHtmlTipView.h
//  Code
//
//  Created by Ivan li on 2020/11/18.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKHtmlTipView : UIView

@property (nonatomic,copy) void(^clickBlock) ();

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
+ (HKHtmlTipView *)createViewFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
