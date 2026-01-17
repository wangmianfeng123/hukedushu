//
//  HomeBanner2_6Cell.h
//  Code
//
//  Created by Ivan li on 2017/9/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HW3DBannerView.h"

@class ScrollButtonView;



@protocol HomeBannerDelegate <NSObject>

@optional
- (void)homeBannerDidSelectItemAtIndex:(NSInteger)index;

@end

@interface HomeBanner2_6Cell : UICollectionViewCell

@property(nonatomic,weak)id <HomeBannerDelegate>delegate;

- (void)setBannerWithUrlArray:(NSArray*)array;



@end
