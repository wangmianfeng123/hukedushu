//
//  ZFHKNormalPlayerSeekTimeTipView.h
//  Code
//
//  Created by Ivan li on 2019/3/15.
//  Copyright © 2019年 pg. All rights reserved.
//


#import <UIKit/UIKit.h>

@class HKLineLabel;


@protocol ZFHKNormalPlayerSeekTimeTipViewDelegate <NSObject>
@optional
/** 下一节视频 代理 */
- (void)hkPlayTimeTipAction:(DetailModel *)model;

@end



@interface ZFHKNormalPlayerSeekTimeTipView : UIView

@property (nonatomic,strong) UIButton *closeBtn;

@property (nonatomic,strong) UILabel *tipLabel;

@property (nonatomic,strong) UILabel *lineLabel;

@property (nonatomic,weak)id <ZFHKNormalPlayerSeekTimeTipViewDelegate>delegate;

@property (nonatomic,strong) DetailModel          *model;

///@property (nonatomic,strong) HKPermissionVideoModel *permissionModel;
/** 播放进度 */
@property (nonatomic,assign) NSInteger playerSeekTime;

@end
