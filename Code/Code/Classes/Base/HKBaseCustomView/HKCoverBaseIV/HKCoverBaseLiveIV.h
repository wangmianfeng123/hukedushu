//
//  HKCoverBaseIV.h
//  Code
//
//  Created by Ivan li on 2018/12/2.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKCustomMarginLabel;

/** UIImageView 基类 */
@interface HKCoverBaseLiveIV : UIImageView

@property (nonatomic,assign) CGFloat cornerRadius;
/** 课时 */
@property (nonatomic,assign) NSInteger courseCount;
/** 隐藏 课时 */
@property (nonatomic,assign, getter = isHiddenText) BOOL hiddenText;
/** 图文 */
@property (nonatomic,assign, getter = isHasPictext) BOOL hasPictext;

@property (nonatomic,strong) HKCustomMarginLabel *textLB;

@property (nonatomic,strong) UILabel *serLB; // 系列课

@property (nonatomic,strong) UIButton *imageTextBtn;
/** 课程text内边距 */
@property (nonatomic,assign) UIEdgeInsets textInsets;
/** 课程text 字体 */
@property (nonatomic,strong) UIFont *textFont;
/** 课程控件 高度  （默认 35） */
@property (nonatomic,assign) CGFloat textLBHeight;
 /// 背景view
@property (nonatomic,strong) UIView *bottomBgView;

- (void)createUI;

@end


