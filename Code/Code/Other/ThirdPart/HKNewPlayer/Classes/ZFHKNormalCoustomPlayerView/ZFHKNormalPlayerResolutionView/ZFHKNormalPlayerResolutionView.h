//
//  ZFHKNormalPlayerResolutionView.h
//  Code
//
//  Created by Ivan li on 2019/12/26.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@protocol ZFHKNormalPlayerResolutionViewDelegate <NSObject>

@optional
/** 切换速率 */
- (void)zFHKNormalPlayerResolutionView:(nullable UIView*)view resolutionBtn:(UIButton*)resolutionBtn;

@end



@interface ZFHKNormalPlayerResolutionView : UIView

@property (nonatomic,weak)id <ZFHKNormalPlayerResolutionViewDelegate>  delegate;

- (void)selectResolutionWithRateIndex:(NSInteger)index;

- (instancetype)initWithIsportrait:(BOOL)isportrait;

@end

NS_ASSUME_NONNULL_END
