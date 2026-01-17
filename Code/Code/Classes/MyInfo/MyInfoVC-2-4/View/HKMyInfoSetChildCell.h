//
//  HKMyInfoSetChildCell.h
//  Code
//
//  Created by Ivan li on 2018/9/26.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCustomMarginLabel.h"

@class HKMyInfoMapPushModel;

@interface HKMyInfoSetChildCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *iconIV;

@property (nonatomic,strong) UILabel *nameLB;

@property (nonatomic,strong) HKCustomMarginLabel *bridgeLB;

@property (nonatomic,strong) HKMyInfoMapPushModel *mapModel;

@end
