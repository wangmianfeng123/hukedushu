//
//  iCommentView.h
//  Code
//
//  Created by Ivan li on 2020/12/11.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface iCommentView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *tipImgV;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (nonatomic , strong) void(^didTapBlock)(void);
- (void)setShowCommentIcon;
@end

NS_ASSUME_NONNULL_END
