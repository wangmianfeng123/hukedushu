//
//  HKTagBtn.h
//  Code
//
//  Created by Ivan li on 2018/8/2.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HKCustomMarginLabel;

@interface HKTagBtnTool : UIView

@property (nonatomic,strong) UIButton *tagBtn;

@property (nonatomic,strong) HKCustomMarginLabel *tagLB;

@property (nonatomic,copy) void(^tabBtnBlock)(NSString *title);

@property (nonatomic,copy)NSString *imageName;

//@property (nonatomic,copy)NSString *tagTitle;

/**
 * 设置标题 及 字体大小
 */
- (void)setTagTitle:(NSString *)tagTitle  fontSize:(CGFloat)fontSize;

@end
