//
//  HKDropMenuCell.h
//  Code
//
//  Created by Ivan li on 2019/1/7.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKDropMenuModel;

NS_ASSUME_NONNULL_BEGIN

@interface  HKDropMenuCell : UITableViewCell

@property (nonatomic , strong) HKDropMenuModel *dropMenuModel;
@property (nonatomic , strong) UILabel *title;
@property (nonatomic , strong) UIView *line;
@property (nonatomic , strong) UIImageView *imgView;

@end


NS_ASSUME_NONNULL_END


