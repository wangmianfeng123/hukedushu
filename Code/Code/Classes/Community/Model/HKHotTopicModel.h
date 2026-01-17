//
//  HKHotTopicModel.h
//  Code
//
//  Created by Ivan li on 2021/1/29.
//  Copyright © 2021 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKHotTopicModel : NSObject

@property (nonatomic, copy)NSString * name;  //
@property (nonatomic , strong) NSMutableArray * list;

@end

NS_ASSUME_NONNULL_END
