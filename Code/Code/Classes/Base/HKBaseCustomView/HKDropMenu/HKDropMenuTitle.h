//
//  HKDropMenuTitle.h
//  Code
//
//  Created by Ivan li on 2019/1/7.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKDropMenuModel;

@interface HKDropMenuTitle : UIView

@property (nonatomic , strong) HKDropMenuModel *dropMenuModel;

@property (nonatomic , strong) UILabel *label;

@property (nonatomic , strong) UIView *topLine;

@property (nonatomic , strong) UIView *bottomLine;

@property (nonatomic , strong) UIImageView *imageView;

@end


NS_ASSUME_NONNULL_END
