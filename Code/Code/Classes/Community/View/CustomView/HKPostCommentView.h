//
//  HKPostCommentView.h
//  Code
//
//  Created by Ivan li on 2021/1/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKPostCommentView : UIView
@property (nonatomic , strong) void(^didTapClickBlock)(void);
@property (weak, nonatomic) IBOutlet UILabel *txtLabel;

@end

NS_ASSUME_NONNULL_END
