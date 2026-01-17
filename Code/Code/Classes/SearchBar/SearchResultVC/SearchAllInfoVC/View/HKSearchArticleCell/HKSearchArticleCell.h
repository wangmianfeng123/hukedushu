//
//  HKSearchArticleCell.h
//  Code
//
//  Created by Ivan li on 2019/4/9.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class  HKArticleModel;

@interface HKSearchArticleCell : UICollectionViewCell

/** 标题 */
@property (strong, nonatomic)  UILabel *titleLB;
/** 封面 */
@property (strong, nonatomic)  UIImageView *avatorIV;
/** 独家标签 */
@property (strong, nonatomic)  UIImageView *exclusiveIV;
/** 头像 */
@property (strong, nonatomic)  UIImageView *userHeaderIV;
@property (strong, nonatomic)  UILabel *userNameLB;
/** 点赞 */
@property (strong, nonatomic)  UILabel *likeCountLB;
/** 浏览 */
@property (strong, nonatomic)  UILabel *readCountLB;

@property (nonatomic, strong)HKArticleModel *model;

- (void)createUI;

- (void)makeConstraints;

- (void)setModel:(HKArticleModel *)model;

@end






NS_ASSUME_NONNULL_END
