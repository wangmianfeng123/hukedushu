//
//  HKHomeSignModel.h
//  Code
//
//  Created by eon Z on 2021/9/7.
//  Copyright © 2021 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKHomeSignModel : NSObject

@property (nonatomic, copy)NSString * class_id;
@property (nonatomic, copy)NSString * name;
@property (nonatomic, assign)BOOL is_check;
@property (nonatomic, assign)BOOL isMore;
@end

NS_ASSUME_NONNULL_END
