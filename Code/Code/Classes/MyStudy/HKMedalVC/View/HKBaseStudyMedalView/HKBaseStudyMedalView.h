//
//  HKBaseStudyMedalView.h
//  Code
//
//  Created by Ivan li on 2018/12/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKTextImageView;

@interface HKBaseStudyMedalView : UIView

@property(nonatomic,strong)UIButton   *closeViewBtn;
/** 顶部 title */
@property(nonatomic,strong)UILabel    *headLB;
/** 荣誉 图片 */
@property(nonatomic,strong)UIImageView *honorIV;

@property(nonatomic,strong)UILabel *introductionLB;

@property(nonatomic,strong)UIButton   *pushBtn;
/** 删除 block */
@property(nonatomic,copy)void(^studyMedalCloseBlock)(UIButton *sender);
/** 跳转 block */
@property(nonatomic,copy)void(^studyMedalPushBlock)(UIButton *sender);

@property (nonatomic,strong)HKTextImageView  *textImageView;

- (void)createUI;

@end
