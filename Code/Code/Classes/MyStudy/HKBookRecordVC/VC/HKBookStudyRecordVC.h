//
//  HKBookRecordVC.h
//  Code
//
//  Created by Ivan li on 2019/8/20.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKBookStudyRecordVC : HKBaseVC
@property (nonatomic,strong)NSMutableArray *dataArr;
/** 编辑 （更新cell 约束） */
- (void)editLearnedCell;
- (void)resetEditLearnedCell;
@end

NS_ASSUME_NONNULL_END
