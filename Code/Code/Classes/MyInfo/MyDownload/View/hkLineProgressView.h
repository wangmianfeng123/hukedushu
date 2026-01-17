//
//  hkLineProgressView.h
//  Code
//
//  Created by Ivan li on 2020/1/7.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface hkLineProgressView : UIView

/** 默认滑杆的颜色 */
@property (nonatomic, strong) UIColor *maximumTrackTintColor;
/** 滑杆进度颜色 */
@property (nonatomic, strong) UIColor *minimumTrackTintColor;
/** 默认滑杆的图片 */
@property (nonatomic, strong) UIImage *maximumTrackImage;
/** 滑杆进度的图片 */
@property (nonatomic, strong) UIImage *minimumTrackImage;
/** 滑杆进度 */
@property (nonatomic, assign) float value;
/** 设置滑杆的高度 */
@property (nonatomic, assign) CGFloat sliderHeight;


- (void)setMaximumTrackBorderColor:(UIColor *)borderColor  backgroundColor:(UIColor *)backgroundColor;

- (void)resetMaximumTrackBorderColor;

@end
