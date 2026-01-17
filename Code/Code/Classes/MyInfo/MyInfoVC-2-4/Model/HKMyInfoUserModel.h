//
//  HKMyInfoUserModel.h
//  Code
//
//  Created by Ivan li on 2018/9/27.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>


@class HomeAdvertModel;


@interface HKMyInfoUserModel : NSObject

@property(nonatomic,copy)NSString *avator;

@property(nonatomic,copy)NSString *username;

@property(nonatomic,copy)NSString *phone;
/** vip 类型 */
@property(nonatomic,copy)NSString *vip_class;
// 未读消息总数
@property(nonatomic,assign)int unread_msg_total;
//签到
@property(nonatomic,copy)NSString *sign_type;
//连续签到天数
@property(nonatomic,copy)NSString *sign_continue_num;
/** 优惠券 */
@property(nonatomic,strong)HKCouponModel *coupon_data;
// 续费
@property(nonatomic,copy)NSString *vip_tips_msg;

@end





@interface HKMyInfoVipModel : NSObject

/** vip 状态 */
@property(nonatomic,copy)NSString   *class_type;
/** vip 按钮标题 */
@property(nonatomic,copy)NSString   *vip_button;
/** vip 描述 */
@property(nonatomic,copy)NSString   *vip_desc;
/** vip 名称 */
@property(nonatomic,copy)NSString   *vip_full_name;
/** vip 种类 */
@property(nonatomic,copy)NSString   *vip_class;

@end


/** 映射模型 */
@interface HKMyInfoMapPushModel : NSObject

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *icon_message;

@property (nonatomic, copy) NSString *key;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL need_login;

@property (nonatomic,strong) HomeAdvertModel *redirect_package;

@end

@interface HKMyInfoGuideLearnModel : NSObject
@property (nonatomic, copy)NSString * ID;
@property (nonatomic, copy)NSString * title;
@property (nonatomic, copy)NSString * img_url;
@property (nonatomic , strong) HKMapModel * redirect_package;
@end

@interface UnreadMessageModel : NSObject
@property (nonatomic , assign) int comment_unread_msg_total; //评论未读
@property (nonatomic , assign) int like_unread_msg_total; //点赞未读
@property (nonatomic , assign) int short_video_unread_msg_total; //短视频消息数
@property (nonatomic , assign) int unread_book_reply; // 读书消息数

@property (nonatomic , assign) int unread_all_message; // 所有消息
@property (nonatomic , assign) int unread_allComment_message; // 所有消息

@end



