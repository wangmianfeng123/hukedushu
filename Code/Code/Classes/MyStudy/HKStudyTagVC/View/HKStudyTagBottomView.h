//
//  HKStudyTagBottomView.h
//  Code
//
//  Created by Ivan li on 2018/5/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HKStudyTagBottomView : UIView

@property(nonatomic,copy)void(^okbtnClickBlock)();

/** 设置新的背景 */
- (void)setOkBtnNewBgImage:(UIImage*)image isSelect:(BOOL)isSelect;

@end
