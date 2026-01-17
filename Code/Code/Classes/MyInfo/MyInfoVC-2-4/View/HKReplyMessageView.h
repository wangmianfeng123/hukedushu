//
//  HKReplyMessageView.h
//  Code
//
//  Created by yxma on 2020/9/23.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKReplyMessageView : UIView

@property (weak, nonatomic) IBOutlet UILabel *messageCountLabel;

+ (HKReplyMessageView *)createView;//Frame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
