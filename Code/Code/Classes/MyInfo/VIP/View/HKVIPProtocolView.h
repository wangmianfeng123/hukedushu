//
//  HKVIPProtocolView.h
//  Code
//
//  Created by yxma on 2020/11/4.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKVIPProtocolView : UIView
@property (nonatomic, assign) BOOL isOpenAutoBuy;
@property (nonatomic, copy) void(^seletBtnBlock)(BOOL selected);
@property(nonatomic,copy)void(^agreementBtnBlock)();
@property(nonatomic,copy)void(^autoBuyBtnBlock)();

+ (HKVIPProtocolView *)createView;

@end

NS_ASSUME_NONNULL_END
