//
//  HKMusicPlayLoadView.h
//  Code
//
//  Created by Ivan li on 2018/4/19.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKMusicPlayLoadView : UIView

/** 定时器 */
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) UIImageView *bgIV;

@property (nonatomic, strong) UIImageView *loadIV;

- (void)startLoading:(BOOL)animated;

- (void)pausedLoading:(BOOL)animated;

@end
