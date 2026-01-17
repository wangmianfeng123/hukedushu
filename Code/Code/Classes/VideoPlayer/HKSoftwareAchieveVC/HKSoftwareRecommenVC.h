//
//  HKSoftwareRecommenVC.h
//  Code
//
//  Created by Ivan li on 2018/4/20.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKBaseVC.h"

typedef void(^RemoveVCBlcok)(VideoModel *model);

@interface HKSoftwareRecommenVC : HKBaseVC

@property(nonatomic,copy)RemoveVCBlcok removeVCBlcok;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,copy)NSString *softwareName;

@end
