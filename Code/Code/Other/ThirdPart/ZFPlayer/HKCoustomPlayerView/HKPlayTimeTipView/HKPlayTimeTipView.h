//
//  HKPlayTimeTipView.h
//  Code
//
//  Created by Ivan li on 2018/4/2.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKLineLabel;

@class ZFNormalPlayerModel;


@protocol HKPlayTimeTipViewDelegate <NSObject>
@optional
/** 下一节视频 代理 */
- (void)hkPlayTimeTipAction:(ZFNormalPlayerModel *)model;

@end



@interface HKPlayTimeTipView : UIView

@property (nonatomic,strong) UIButton *closeBtn;

@property (nonatomic,strong) UILabel *tipLabel;

@property (nonatomic,strong) UILabel *lineLabel;

@property(nonatomic,weak)id <HKPlayTimeTipViewDelegate>delegate;

@property (nonatomic, strong) ZFNormalPlayerModel          *model;

@end
