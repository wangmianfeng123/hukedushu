//
//  HKNewUserFirstView.h
//  Code
//
//  Created by Ivan li on 2018/8/2.
//  Copyright © 2018年 pg. All rights reserved.
//


#import "HKGiftBaseView.h"


@protocol HKNewUserFirstViewDelegate <NSObject>

@end


@interface HKNewUserFirstView : HKGiftBaseView

@property (nonatomic,weak)id <HKNewUserFirstViewDelegate> delegate;

@property (nonatomic,strong) HKHomeGiftModel *model;

@end





