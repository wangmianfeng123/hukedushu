//
//  HKCategoryModel.h
//  Code
//
//  Created by yxma on 2020/9/8.
//  Copyright © 2020 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKCategoryModel : NSObject

@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * corner_word;
@property (nonatomic, assign) int type;

@end

NS_ASSUME_NONNULL_END
