//
//  HKDropMenuItem.h
//  Code
//
//  Created by Ivan li on 2019/1/7.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class HKDropMenuItem,HKDropMenuModel,HKDropMenuTitle;

@protocol HKDropMenuItemDelegate <NSObject>

- (void)dropMenuItem: (HKDropMenuItem *)item dropMenuModel: (HKDropMenuModel *)dropMenuModel;

@end


@interface HKDropMenuItem : UICollectionViewCell <UIGestureRecognizerDelegate>

@property (nonatomic , strong) HKDropMenuModel *dropMenuModel;

@property (nonatomic , weak) id <HKDropMenuItemDelegate> delegate;

@property (nonatomic , strong) HKDropMenuTitle *dropMenuTitle;

@end


NS_ASSUME_NONNULL_END
