//
//  HKDropMenuFilterHeader.h
//  Code
//
//  Created by Ivan li on 2019/1/7.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKDropMenuFilterHeader ,HKDropMenuModel;

@protocol HKDropMenuFilterHeaderDelegate <NSObject>

- (void)dropMenuFilterHeader: (HKDropMenuFilterHeader *)header dropMenuModel: (HKDropMenuModel *)dropMenuModel;

@end

@interface HKDropMenuFilterHeader : UICollectionReusableView

@property (nonatomic , strong) HKDropMenuModel *dropMenuModel;

@property (nonatomic , weak) id <HKDropMenuFilterHeaderDelegate> delegate;

@property (nonatomic , strong) UILabel *title;

@property (nonatomic , strong) UILabel *details;

@end

NS_ASSUME_NONNULL_END
