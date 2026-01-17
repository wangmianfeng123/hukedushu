//
//  HKLearnToolbarView.h
//  Code
//
//  Created by Ivan li on 2018/9/4.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKLearnToolbarView : UIView

@property (nonatomic,strong) UIImageView *toolView;

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UILabel *textLB;

@property (nonatomic,strong) UIButton *vipBtn;

@property(nonatomic,copy)void(^hKLearnToolbarViewBlock) (id sender);

@end
