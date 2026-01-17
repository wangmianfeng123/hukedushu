//
//  TagModel.h
//  Code
//
//  Created by Ivan li on 2017/10/17.
//  Copyright © 2017年 pg. All rights reserved.
//

// #import <JSONModel/JSONModel.h>



@interface ChildrenModel : NSObject

/** 标签 ID */
@property(nonatomic,copy)NSString *ID;
/** tag 标题 */
@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *parent_id;

@property(nonatomic)BOOL isSelect;
/** 搜索页 标签 ID */
@property(nonatomic,copy)NSString *class_id;

@property(nonatomic,strong)NSMutableArray<ChildrenModel*>*children;

/** 数组 层级 */
@property(nonatomic,assign)NSInteger level;

//@property(nonatomic,copy)NSString *tag;

@end




@interface TagModel : NSObject

@property(nonatomic,copy)NSString *ID;
/** section 标题 */
@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString * keyWord;
@property (nonatomic, copy)NSString * classVal;  //

@property(nonatomic,copy)NSArray<ChildrenModel*>*children;

@property(nonatomic,copy)NSString *parent_id;

@property(nonatomic,copy)NSString *words; // 搜索 热门推荐词

/** 音频  */
@property(nonatomic,copy)NSString *class_id;

@property(nonatomic)BOOL isSelect;

/** 数组 层级 */
@property(nonatomic,assign)NSInteger level;

@property(nonatomic,assign)NSInteger key;

@property(nonatomic,copy)NSString  *value;

@end


@interface preciseWordsModel : NSObject

@property (nonatomic, copy)NSString * word;
@property (nonatomic , strong) HKMapModel * redirect_package;
@end




