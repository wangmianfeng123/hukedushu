//
//  HKProtoclView.h
//  Code
//
//  Created by eon Z on 2024/4/26.
//  Copyright © 2024 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKProtoclView : UIView
/** 关闭Block*/
@property (nonatomic , copy ) void (^closeBlock)(void);
/** 更新Block*/
@property (nonatomic , copy ) void (^sureBlock)(void);
@property (nonatomic , copy ) void (^delegateClickBlock)(NSInteger tag);

+ (HKProtoclView *)createView;

@end

NS_ASSUME_NONNULL_END
