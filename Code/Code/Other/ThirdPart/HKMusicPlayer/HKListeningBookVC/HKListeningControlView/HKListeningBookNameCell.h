//
//  HKListeningBookNameCell.h
//  Code
//
//  Created by Ivan li on 2019/7/18.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class HKBookModel;


@interface HKListeningBookNameCell : UICollectionViewCell

/// 阴影背景
@property (strong, nonatomic)  UIImageView *shadowIV;
/// 描述
@property (strong, nonatomic)  UILabel *descrLB;
/// 书名
@property (strong, nonatomic)  UILabel *bookNameLB;
/// 作者
@property (strong, nonatomic)  UILabel *authorLB;
/// 更新时间
@property (strong, nonatomic)  UILabel *timeLB;
/// 学习人数
@property (strong, nonatomic)  UILabel *countLB;

@property (nonatomic, strong)HKBookModel *model;

@end

NS_ASSUME_NONNULL_END
