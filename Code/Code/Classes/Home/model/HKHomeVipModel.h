//
//  HKHomeVipModel.h
//  Code
//
//  Created by ivan on 2020/6/23.
//  Copyright © 2020 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKHomeVipModel : NSObject

@property (nonatomic,copy) NSString *name;

@property (nonatomic,strong) HKMapModel *redirect_package;

@end

NS_ASSUME_NONNULL_END
