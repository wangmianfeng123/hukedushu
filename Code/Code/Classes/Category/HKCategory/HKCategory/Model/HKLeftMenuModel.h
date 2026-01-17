//
//  HKLeftMenuModel.h
//  Code
//
//  Created by yxma on 2020/9/9.
//  Copyright © 2020 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKLeftMenuModel : NSObject

@property (nonatomic, assign) int ID;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * corner_word;
@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSNumber * has_free_living ; //当type=6时才有值，是否有正在直播的免费直播课1：有   0：没有    
@end

NS_ASSUME_NONNULL_END
