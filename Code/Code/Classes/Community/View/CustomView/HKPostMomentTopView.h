//
//  HKPostMomentTopView.h
//  Code
//
//  Created by Ivan li on 2021/1/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKPostMomentTopView : UIView
@property (nonatomic , strong) void(^didTapBlock)(void);
@property (weak, nonatomic) IBOutlet UIButton *topicBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightLabel;

@end

NS_ASSUME_NONNULL_END
