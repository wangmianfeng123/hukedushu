//
//  HKTabBarModel.h
//  Code
//
//  Created by yxma on 2020/9/30.
//  Copyright © 2020 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKTabBarModel : NSObject

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * icon_url;
@property (nonatomic, copy) NSString * click_icon_url;
@property (nonatomic, copy) NSString * corner_word;
@property (nonatomic,strong) HomeAdvertModel * redirect_package;

@end

NS_ASSUME_NONNULL_END
