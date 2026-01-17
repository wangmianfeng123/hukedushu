//
//  HKWindowBooKView.h
//  Code
//
//  Created by Ivan li on 2019/7/19.
//  Copyright © 2019 pg. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "HKDragView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKWindowBooKView : HKDragView <GKPlayerDelegate>

@property (nonatomic,strong) UIButton *coloseBtn;

@property (nonatomic,strong) UIButton *playOrPauseBtn;

@property (nonatomic,strong) UIImageView *bgIV;

@property (nonatomic,strong) UIImageView *coverIV;

@property (nonatomic,strong) UIImageView *coverBgIV;

@property (nonatomic,copy) NSString *imageUrl;

@property (nonatomic,strong)UIView *leftLineView;

@property (nonatomic,strong)UIView *rightLineView;

///coloseBtn 点击block
@property (nonatomic,copy)void (^hkWindowBooKViewCloseBtnClickCallBack)();
/// bgIV 点击block
@property (nonatomic,copy)void (^hkWindowBooKViewBgIVClickCallBack)();

@property (nonatomic,weak)GKPlayer *player;


@end

NS_ASSUME_NONNULL_END
