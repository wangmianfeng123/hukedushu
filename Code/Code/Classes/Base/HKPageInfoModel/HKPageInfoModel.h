//
//  HKPageInfoModel.h
//  Code
//
//  Created by Ivan li on 2019/9/26.
//  Copyright © 2019 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 分页 Model
@interface HKPageInfoModel : NSObject

@property(nonatomic,assign)NSInteger current_page;

@property(nonatomic,assign)NSInteger page_size;

@property(nonatomic,assign)NSInteger page_total;

@property(nonatomic,assign)NSInteger total_count;

@end

NS_ASSUME_NONNULL_END
