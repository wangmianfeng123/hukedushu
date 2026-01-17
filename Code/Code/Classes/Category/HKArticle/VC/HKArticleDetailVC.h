//
//  HKAudioHotVC.h
//  Code
//
//  Created by Ivan li on 2018/4/18.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKBaseVC.h"
#import "HKArticleCategoryModel.h"
#import "HKArticleModel.h"

@interface HKArticleDetailVC : HKBaseVC

@property (nonatomic, strong)HKArticleModel *model;

@property (nonatomic,copy)NSString *articleId;

@end
