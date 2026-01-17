//
//  HKInteractionVC.h
//  Code
//
//  Created by eon Z on 2021/9/1.
//  Copyright © 2021 pg. All rights reserved.
//

#import "WMStickyPageControllerTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKInteractionVC : WMStickyPageControllerTool

@property (nonatomic,strong) void(^CommentCountChangeBlock)(NSString *count);
- (instancetype)initWithDetailModel:(DetailModel*)model;
- (void)setCommentWithModel:(DetailModel*)model;
@end

NS_ASSUME_NONNULL_END
