//
//  HKtestview.h
//  Code
//
//  Created by Ivan li on 2018/9/7.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HKPlayerAutoPlayBaseViewDelegate <NSObject>

@optional
- (void)hkPlayerRateBaseView:(NSInteger)state;

- (void)hkPlayerRateBaseView:(UIView*)view feedBack:(NSString*)feedBack;

@end



@interface HKPlayerAutoPlayBaseView : UIView

@property(nonatomic,weak)id <HKPlayerAutoPlayBaseViewDelegate> delegate;

@end
