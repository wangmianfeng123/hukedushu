//
//  HKStoreOrderAddressCell.h
//  Code
//
//  Created by Ivan li on 2019/10/25.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKStoreOrderAddressCell : UITableViewCell

@property (nonatomic, copy)void(^changeAddressBlock)(NSString *address, UIButton *btn);

@end

NS_ASSUME_NONNULL_END
