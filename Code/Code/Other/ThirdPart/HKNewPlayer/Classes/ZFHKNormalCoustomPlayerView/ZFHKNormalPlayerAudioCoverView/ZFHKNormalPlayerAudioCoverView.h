//
//  ZFHKNormalPlayerAudioCoverView.h
//  Code
//
//  Created by Ivan li on 2019/8/4.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFHKNormalPlayerMediaControl.h"

NS_ASSUME_NONNULL_BEGIN

@class ZFHKNormalPlayerAudioCoverView;

@protocol ZFHKNormalPlayerAudioCoverViewDelegate <NSObject>

- (void)hKNormalPlayerAudioCoverView:(ZFHKNormalPlayerAudioCoverView*)view audioBtn:(UIButton*)audioBtn;

@end


@interface ZFHKNormalPlayerAudioCoverView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIButton *audioBtn;

@property (nonatomic,strong) UIImageView *audioIV;

@property (nonatomic,strong) UILabel *descrLB;

@property(nonatomic,weak)id <ZFHKNormalPlayerAudioCoverViewDelegate> delegate;

@property(nonatomic,copy)void (^hKNormalPlayerAudioCoverViewCallback)(ZFHKNormalPlayerAudioCoverView *view ,UIButton *audioBtn);

@end

NS_ASSUME_NONNULL_END
