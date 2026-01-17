//
//  HKCatalogueListVC.h
//  Code
//
//  Created by eon Z on 2022/4/27.
//  Copyright © 2022 pg. All rights reserved.
//

#import "HKBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKCatalogueListVC : HKBaseVC

@property (nonatomic , strong) void(^closeBtnBlock)(void);
@property (nonatomic,strong)DetailModel *detaiModel;

@property (nonatomic,assign)int videoCount;

@property (nonatomic , strong) void(^didItemBlock)(HKCourseModel * model);

@end

NS_ASSUME_NONNULL_END
