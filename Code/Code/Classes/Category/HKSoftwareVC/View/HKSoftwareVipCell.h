//
//  HKSoftwareVipCell.h
//  Code
//
//  Created by Ivan li on 2018/3/31.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HKSoftwareVipCell : UICollectionViewCell

@property (nonatomic, copy)void(^openVipBlock)(NSString *vipType);

@property(nonatomic,copy)NSString *vipDesc;

@end
