//
//  HKPushToSearch.h
//  Code
//
//  Created by Ivan li on 2021/7/20.
//  Copyright © 2021 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKPushToSearch : NSObject
@property (nonatomic , assign) BOOL isPush ;//是push 直接进结果页

- (void)hkPushToSearchWithVC:(UIViewController *)vc withKeyWord:(NSString *)keyWord withIndex:(int)index;

@end

NS_ASSUME_NONNULL_END
