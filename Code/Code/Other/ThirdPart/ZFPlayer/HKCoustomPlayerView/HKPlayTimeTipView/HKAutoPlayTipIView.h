//
//  HKAutoPlayTipIView.h
//  Code
//
//  Created by Ivan li on 2018/9/10.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>



@class HKAutoPlayTipIView;


@protocol HKAutoPlayTipIViewDelegate <NSObject>
@optional

- (void)removeAutoPlayTipIView:(HKAutoPlayTipIView *)view;

@end


@interface HKAutoPlayTipIView : UIImageView

@property(nonatomic,weak)id <HKAutoPlayTipIViewDelegate>delegate;

@end
