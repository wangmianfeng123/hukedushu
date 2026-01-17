//
//  HKArticleHeaderView.h
//  Code
//
//  Created by eon Z on 2022/3/11.
//  Copyright © 2022 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKArticleHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy)void(^likeBtnClickBlock)(UIButton *button);

- (void)setLikeBtn:(NSString *)count isLike:(BOOL)isLike;

@end




// 上下排布的点赞按钮
@interface HKArticleRelationHeaderViewButton : UIButton

@end

NS_ASSUME_NONNULL_END
