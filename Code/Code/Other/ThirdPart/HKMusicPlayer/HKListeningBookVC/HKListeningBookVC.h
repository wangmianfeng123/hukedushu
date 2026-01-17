//
//  HKListeningBookVC.h
//  Code
//
//  Created by Ivan li on 2019/7/16.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKListeningBookVC : HKBaseVC

@property(nonatomic,copy)NSString *bookId;

@property(nonatomic,copy)NSString *courseId;
/** Yes - 通过小悬浮窗口 初始化 */
@property(nonatomic,assign)BOOL isFromBookPlayer;
@property (nonatomic, strong)HKBookModel *bookModel;

@end

NS_ASSUME_NONNULL_END
