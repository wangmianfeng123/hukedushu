//
//  HKPushTimeCell.h
//  Code
//
//  Created by eon Z on 2022/2/10.
//  Copyright © 2022 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKPushTimeModel;

@interface HKPushTimeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightIcon;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic , strong) HKPushTimeModel * model;
@end

@interface HKPushTimeModel : NSObject
@property (nonatomic , assign ) int index;
@property (nonatomic , strong ) NSString * name;
@property (nonatomic , assign ) BOOL selected;

@end

NS_ASSUME_NONNULL_END
