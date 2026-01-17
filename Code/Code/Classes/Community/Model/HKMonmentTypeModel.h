//
//  HKMonmentTypeModel.h
//  Code
//
//  Created by Ivan li on 2021/1/22.
//  Copyright © 2021 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HKMonmentTabModel,HKMonmentTagModel,HKADdataModel,HKCarouselModel,HKParameterModel;

@interface HKMonmentTypeModel : NSObject

//@property (nonatomic , strong) NSNumber * ID;
@property (nonatomic , strong) NSNumber * type;

@property (nonatomic , assign) int canOrder ;
@property (nonatomic , assign) int categoryFilter ;
@property (nonatomic, copy)NSString * name;  //
@property (nonatomic , strong) NSMutableArray <HKMonmentTagModel *>* order; //排序
//@property (nonatomic , copy) NSNumber * replies;
@property (nonatomic , strong) NSMutableArray <HKParameterModel *>* page_filter;
@property (nonatomic , assign) BOOL hasCarouselMessage ;//是否显示轮播
@end

@interface HKMonmentTabModel : NSObject
@property (nonatomic , strong) NSMutableArray <HKMonmentTypeModel *>* tabs;//tabModel
@property (nonatomic , strong) NSMutableArray <HKMonmentTagModel *>* subjects; //热门话题
@property (nonatomic , strong) NSMutableArray <HKMonmentTagModel *>* categories;//筛选分类标签
@property (nonatomic, copy) NSString * answered_question_count;  //
@property (nonatomic, copy) NSString * message_count;  //


@property (nonatomic , strong) NSMutableArray <HKADdataModel *>* ad_data;
@property (nonatomic , strong) NSMutableArray <HKCarouselModel *>* carousel_message;

@end




@interface HKMonmentTagModel : NSObject
//@property (nonatomic , assign) int ID ;
@property (nonatomic , strong) NSNumber * ID;
@property (nonatomic, assign)BOOL isquestion;  //
@property (nonatomic, copy)NSString * name;  //
/** 标签选中状态 */
@property (nonatomic , assign) BOOL tagSeleted;
@property (nonatomic , strong) NSNumber * classVal;
@property (nonatomic, copy)NSString * key;  //
@end


@interface HKADdataModel : NSObject
@property (nonatomic, copy)NSString * ID;  //
@property (nonatomic, copy)NSString * title;  //
@property (nonatomic, copy)NSString * img_url;  //
@property (nonatomic,strong) HomeAdvertModel *redirect_package;
@end

@interface HKCarouselModel : NSObject
@property (nonatomic, copy)NSString * topic_id;  //
@property (nonatomic, copy)NSString * connectType;  //
@property (nonatomic, copy)NSString * message;  //
@property (nonatomic, copy)NSString * username;  //

@end

@interface HKParameterModel : NSObject
@property (nonatomic, strong)NSNumber * ParameterValue;  //
@property (nonatomic, copy)NSString * ParameterName;  //
@end

NS_ASSUME_NONNULL_END
