//
//  HKGroupModel.h
//  Code
//
//  Created by Ivan li on 2018/11/8.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKGroupModel : NSObject

@property(nonatomic,copy)NSString *ID;
/** 群组名称 */
@property(nonatomic,copy)NSString *group_name;

@property(nonatomic,copy)NSString *avator;
/** 群成员数量 */
@property(nonatomic,assign)NSInteger num;
/** 群账号（网易云id）*/
@property(nonatomic,copy)NSString *group_account;
/**  状态 0-正常 ，1-满员 ，2-已解散（列表中的都为正常的） */
@property(nonatomic,assign)NSInteger status;
/** 群头像 */
@property(nonatomic,copy)NSString *avatar;
/** 是否 加入该群 */
@property(nonatomic,assign)BOOL is_in_group;
/** 群成员数量 */
@property(nonatomic,copy)NSString *num_str;

@property (nonatomic, copy)NSString *name;

@property (nonatomic, assign)BOOL silence;


@end



