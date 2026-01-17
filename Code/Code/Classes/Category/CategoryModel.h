//
//  CategoryModel.h
//  Code
//
//  Created by Ivan li on 2017/8/22.
//  Copyright © 2017年 pg. All rights reserved.
//

//#import <Foundation/Foundation.h>

// #import <JSONModel/JSONModel.h>


//分类页
@interface CategoryModel : NSObject

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *img_url;

@property(nonatomic, copy) NSString *icon_url; //首页 分类按钮 图片

@property(nonatomic,copy)NSString *className;

@property(nonatomic,copy)NSString *color;
/** 小角标  */
@property(nonatomic,copy)NSString *corner_icon_url;

@property(nonatomic,copy)NSString *class_type; //1-普通分类 2-软件入门 3-系列课

@end



// 首页分类
@interface HomeCategoryModel : NSObject

@property(nonatomic,copy) NSString *name;

@property(nonatomic,copy) NSString *icon_url;

/** 小角标 （新手 小白） */
@property(nonatomic,copy)NSString *corner_word;

@property (nonatomic, strong) HomeAdvertModel * redirect_package;






//@property(nonatomic,copy)NSString *img_url;

//@property(nonatomic,copy)NSString *web_url;


//@property(nonatomic,copy)NSString *className;

//@property(nonatomic,copy)NSString *color;

//@property(nonatomic,copy)NSString *class_type;

@end


@interface PageCategoryModel : NSObject

@property (nonatomic, copy) NSString *page;

@property(nonatomic, strong)NSMutableArray<HomeCategoryModel *> *list;

@end


