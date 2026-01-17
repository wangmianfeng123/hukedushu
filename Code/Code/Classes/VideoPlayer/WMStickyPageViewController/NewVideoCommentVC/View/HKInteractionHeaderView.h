//
//  HKInteractionHeaderView.h
//  Code
//
//  Created by eon Z on 2021/9/1.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKInteractionHeaderView : UIView

@property(nonatomic,strong)void(^tipBlock)(void);

@property (nonatomic , strong) NSMutableArray * urlArray;
@property(nonatomic,strong)void(^didImgBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
