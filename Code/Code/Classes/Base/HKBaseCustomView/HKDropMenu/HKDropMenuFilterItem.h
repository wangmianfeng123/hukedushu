//
//  HKDropMenuFilterItem.h
//  Code
//
//  Created by Ivan li on 2019/1/7.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class HKDropMenuFilterItem,HKDropMenuModel ,HKCustomMarginLabel,HKClassListModel;

@protocol HKDropMenuFilterItemDelegate <NSObject>

- (void)dropMenuFilterItem: (HKDropMenuFilterItem *)item dropMenuModel:(HKDropMenuModel *)dropMenuModel;

@end


@interface HKDropMenuFilterItem : UICollectionViewCell <UIGestureRecognizerDelegate>

@property (nonatomic , strong) HKDropMenuModel *dropMenuModel;
@property (nonatomic , strong) HKClassListModel * model;

@property (nonatomic , strong) HKCustomMarginLabel *title;

@property (nonatomic , strong) UIImageView *iconIV;

@property (nonatomic , weak) id <HKDropMenuFilterItemDelegate>delegate;

@end


NS_ASSUME_NONNULL_END
