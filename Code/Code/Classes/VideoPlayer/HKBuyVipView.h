//
//  HKBuyVipView.h
//  Code
//
//  Created by Ivan li on 2021/7/12.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKBuyVipView : UIView
@property (nonatomic , strong) void(^didSureBtnBlock)(HKBuyVipModel * vipModel);
@property (nonatomic , strong) NSArray * vip_list;
@property (nonatomic , strong) void(^didAgreeBlock)(void);

- (void)showView;
@end

NS_ASSUME_NONNULL_END
