//
//  HKLoginCell.h
//  Code
//
//  Created by Ivan li on 2021/2/3.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKLoginCell : UITableViewCell
@property (nonatomic , strong) void(^didLoginBlock)(void);

- (void)loadData;
@end

NS_ASSUME_NONNULL_END
