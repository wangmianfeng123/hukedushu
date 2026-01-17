//
//  HKAddWeChatView.h
//  Code
//
//  Created by Ivan li on 2021/3/31.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKAddWeChatView : UIView
@property (nonatomic, copy) void(^addWxBlock)(void);
@property (nonatomic, copy) void(^thumbsLikeBlock)(void);

@end

NS_ASSUME_NONNULL_END
