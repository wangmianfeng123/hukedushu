//
//  HKPageVisitParamesModel.h
//  Code
//
//  Created by eon Z on 2022/8/10.
//  Copyright © 2022 pg. All rights reserved.
//

#import "HKDataParamesModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKPageVisitParamesModel : HKDataParamesModel

@property (nonatomic , copy)NSString * route;
@property (nonatomic , copy)NSString * uuid;

- (instancetype)initWithPageTitle:(NSString *)pageTitle;

@end

NS_ASSUME_NONNULL_END
