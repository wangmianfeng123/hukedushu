//
//  HKBookCommentListVC.h
//  Code
//
//  Created by Ivan li on 2019/8/21.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@class HKBookModel;

@interface HKBookCommentListVC : HKBaseVC

@property (nonatomic, copy)NSString *bookId;

@property (nonatomic,strong)HKBookModel *bookModel;

@end

NS_ASSUME_NONNULL_END


