//
//  ZFHKNormalPlayerErrorView.h
//  Code
//
//  Created by Ivan li on 2019/12/24.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZFHKNormalPlayerErrorViewDelegate <NSObject>

@optional
/** 重试 */
- (void)zFHKNormalPlayerErrorView:(nullable UIView*)view retryBtn:(UIButton*)retryBtn;
/** 切换线路 */
- (void)zFHKNormalPlayerErrorView:(nullable UIView*)view switchLineBtn:(UIButton*)switchLineBtn;

@end


@interface ZFHKNormalPlayerErrorView : UIView

@property (nonatomic,weak)id <ZFHKNormalPlayerErrorViewDelegate>  delegate;

@end

NS_ASSUME_NONNULL_END

