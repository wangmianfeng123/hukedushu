//
//  HKNewUserSecondView.h
//  Code
//
//  Created by Ivan li on 2018/8/6.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKGiftBaseView.h"
#import <UMShare/UMShare.h>


@class HKNewUserSecondView,HKShareSucessView;

@protocol HKNewUserSecondViewDelegate <NSObject>

@optional
- (void)newUserShare:(HKNewUserSecondView*)view  btn:(UIButton*)btn platform:(UMSocialPlatformType)platform;

@end


@interface HKNewUserSecondView : HKGiftBaseView

@property (nonatomic,weak)id <HKNewUserSecondViewDelegate> delegate;

@property (nonatomic,strong) UILabel *timeLB;

@property (nonatomic,strong) UILabel *shareLB;

/** QQ 按钮 */
@property (nonatomic,strong) UIButton *qqLoginBtn;
/** 微信 按钮 */
@property (nonatomic,strong) UIButton *weChatLoginBtn;
/** 微博 按钮 */
@property (nonatomic,strong) UIButton *weiBoLoginBtn;
/** 朋友圈 按钮 */
@property (nonatomic,strong) UIButton *friendLoginBtn;

@property (nonatomic,strong) NSMutableArray<UIButton*> *array;

@property (nonatomic,strong)HKShareSucessView *shareSucessView;

@property (nonatomic,strong) HKHomeGiftModel *model;
/** 顶部图片 */
@property (nonatomic,strong) UIImageView *headIV;

- (void)setShareSucessView;

@end





