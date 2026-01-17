//
//  HKVIPadsCell.h
//  Code
//
//  Created by eon Z on 2021/11/10.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKVIPadsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *adImgV;
@property (nonatomic, strong) void(^tapClickBlock)(void);
@end

NS_ASSUME_NONNULL_END
