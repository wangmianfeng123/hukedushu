//
//  VideoPlayEmptyView.h
//  Code
//
//  Created by Ivan li on 2019/3/20.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol VideoPlayEmptyViewDelegate <NSObject>

- (void)videoPlayEmptyView:(UIView*)view;

@end

@interface VideoPlayEmptyView : UIView


@property(nonatomic,weak)id <VideoPlayEmptyViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
