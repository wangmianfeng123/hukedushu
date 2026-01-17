//
//  HKVIPPriceView.h
//  Code
//
//  Created by eon Z on 2021/11/10.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKBuyVipModel;

@interface HKVIPPriceView : UIView
@property (nonatomic, strong)HKBuyVipModel * model;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgV;
@property (nonatomic, assign ) NSInteger   currentIndex;

@end

NS_ASSUME_NONNULL_END
