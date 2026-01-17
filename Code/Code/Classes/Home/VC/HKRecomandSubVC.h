//
//  HKRecomandSubVC.h
//  Code
//
//  Created by eon Z on 2021/11/3.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@class TagModel;

@interface HKRecomandSubVC : HKBaseVC
@property (nonatomic, strong)TagModel * tagM;

- (instancetype)initWithNetDataRefresh:(BOOL)isNetDataRefresh;
@end

NS_ASSUME_NONNULL_END
