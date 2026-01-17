//
//  HKNotesListVC.h
//  Code
//
//  Created by Ivan li on 2020/12/29.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKBaseVC.h"

NS_ASSUME_NONNULL_BEGIN
@class HKNotesVideoModel;

@interface HKNotesListVC : HKBaseVC
@property (nonatomic , strong) HKNotesVideoModel * videoModel;
//@property (nonatomic , assign) BOOL isFold ;
@end

NS_ASSUME_NONNULL_END
