//
//  HKLineLabel.h
//  Code
//
//  Created by Ivan li on 2017/12/26.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 横线 UILabel */
@interface HKLineLabel : UILabel
/** 是否画线 */
@property (assign, nonatomic) BOOL strikeThroughEnabled;
/** 画线颜色 */
@property (strong, nonatomic) UIColor *strikeThroughColor;

@property (nonatomic, assign) UIEdgeInsets edgeInsets;
/** yes - 居下  NO -居中 */
@property (assign, nonatomic) BOOL isBottom;

/** 0 ---默认0.8 */
@property (assign, nonatomic) float lineHeight;

/** YES - 划线 */
//@property (nonatomic, assign) BOOL isBottomLine;

@end
