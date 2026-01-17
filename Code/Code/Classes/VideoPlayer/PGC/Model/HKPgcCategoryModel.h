//
//  HKPgcCategoryModel.h
//  Code
//
//  Created by Ivan li on 2017/12/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>


// PGC  课程信息
@interface HKPgcCourseModel : NSObject

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *cover_url;

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *avator;

@property(nonatomic,copy)NSString *price;
/** 当前售卖价格*/
@property(nonatomic,copy)NSString *now_price;

@property(nonatomic,copy)NSString *discount_price;

@property(nonatomic,copy)NSString *video_id;

@property(nonatomic,copy)NSString *ID;
//PGC--- 订单
@property(nonatomic,copy)NSString *pgc_id;

@property(nonatomic,copy)NSString *order_number;
/** 1-已购买课程 0-未购买课程 */
@property (nonatomic, copy)NSString *is_buy;
/**特价，为空表示没有特价*/
@property (nonatomic, copy)NSString *tag_1;
/**VIP折扣价标识，为空表示没有折扣价*/
@property (nonatomic, copy)NSString *tag_2;

@end






//筛选标签
@interface PgcTagListModel : NSObject

@property(nonatomic,copy)NSString *tag_id;

@property(nonatomic,copy)NSString *tag;

@property(nonatomic)BOOL isSelect;

@end





@interface HKPgcCategoryModel : NSObject

@property(nonatomic,strong)NSMutableArray<HKPgcCourseModel *> *course_list;

@property(nonatomic,copy)NSString *page;

@property(nonatomic,copy)NSString *total_page;

@property(nonatomic,copy)NSString *course_count;

@property(nonatomic,copy)NSString *notice;

@property(nonatomic,strong)NSMutableArray<PgcTagListModel *> *tag_list;//选择 标签


@end


