//
//  HKBookTabMainBannerCell.h
//  Code
//
//  Created by Ivan li on 2019/10/31.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  HW3DBannerView;



@protocol HKBookTabMainBannerDelegate <NSObject>

@optional
- (void)homeBanner:(HW3DBannerView *_Nullable)bannerView didSelectItemAtIndex:(NSInteger)index;

@end



NS_ASSUME_NONNULL_BEGIN

@interface HKBookTabMainBannerCell : UICollectionViewCell

@property(nonatomic,weak)id <HKBookTabMainBannerDelegate>delegate;
/// 点击 回调
@property(nonatomic,copy) void (^didSelectItemblock)(HW3DBannerView *bannerView,NSInteger index);

- (void)setBannerWithUrlArray:(NSArray*)array;

@end

NS_ASSUME_NONNULL_END

