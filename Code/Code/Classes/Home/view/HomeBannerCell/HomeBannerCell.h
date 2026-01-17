//
//  HomeBannerCell.h
//  Code
//
//  Created by Ivan li on 2017/9/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class   SDCycleScrollView,ScrollButtonView;



@protocol HomeBannerDelegate <NSObject>

@optional
- (void)homeBanner:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;

- (void)homeBanner:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index;

- (void)homeBannerSelectBtnToIndex:(NSInteger)index;

@end

@interface HomeBannerCell : UICollectionViewCell

@property(nonatomic,weak)id <HomeBannerDelegate>delegate;

@property(nonatomic,strong)NSMutableArray *classArr;

- (void)setBannerWithUrlArray:(NSArray*)array;



@end
