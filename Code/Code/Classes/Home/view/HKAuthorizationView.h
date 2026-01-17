//
//  HKAuthorizationView.h
//  Code
//
//  Created by yxma on 2020/9/22.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKAuthorizationView : UIView
/** 关闭Block*/
@property (nonatomic , copy ) void (^closeBlock)(void);
/** 更新Block*/
@property (nonatomic , copy ) void (^sureBlock)(void);
@property (nonatomic , copy ) void (^delegateClickBlock)(NSInteger tag);
@property (weak, nonatomic) IBOutlet UIButton *noUseBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreementBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidth;
@property (weak, nonatomic) IBOutlet UILabel *contentTV;

+ (HKAuthorizationView *)createView;
@end

NS_ASSUME_NONNULL_END
