//
//  HKAPPInfoCell.h
//  Code
//
//  Created by Ivan li on 2019/7/3.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKAPPInfoCell : UITableViewCell

@property (nonatomic,strong) UILabel *infoLB;

@property (nonatomic,strong) UILabel *titleLB;

- (void)setTitle:(NSString*)title  info:(NSString*)info;

@end

NS_ASSUME_NONNULL_END
