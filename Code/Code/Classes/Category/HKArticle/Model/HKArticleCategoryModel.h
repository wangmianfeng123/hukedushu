//
//  HKArticleModel.h
//  Code
//
//  Created by hanchuangkeji on 2018/8/3.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKArticleCategoryModel : NSObject

@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *url;

@property (nonatomic, assign)BOOL isSelected;

/**********************************************/
@property (nonatomic, copy)NSString *tagId;//id

@property (nonatomic, copy)NSString *name;

@property (nonatomic, copy)NSString *pid;

@end
