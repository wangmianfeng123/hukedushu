//
//  BannerModel.h
//  Code
//
//  Created by Ivan li on 2017/10/12.
//  Copyright © 2017年 pg. All rights reserved.
//

// #import <JSONModel/JSONModel.h>

@interface fieldModel : NSObject
/** H5页面--URL      视频详情页--视频ID    列表页--分类ID     VIP页 */
@property(nonatomic,copy)NSString *msg;

@property(nonatomic,copy)NSString *img_cover_url;

@property(nonatomic,copy)NSString *video_titel;

@property(nonatomic,copy)NSString *video_url;


@end


@interface HKHtmlModel : NSObject

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *img_url;

@property(nonatomic,strong)fieldModel *field;
/** type：banner类型，1-H5页面 2-视频详情页 3-列表页 4-VIP页*/
@property(nonatomic,copy)NSString *type;

@property(nonatomic,copy)NSString *ID;

@end





@interface BannerModel : NSObject

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *img_url;

@property(nonatomic,strong)fieldModel *field;
/** type：banner类型，1-H5页面 2-视频详情页 3-列表页 4-VIP页  5 - (跳转 浏览器或者appstroe) */
@property(nonatomic,copy)NSString *type;

@property(nonatomic,copy)NSString *ID;
/** 首页 动画icon yes -显示动画 */
@property(nonatomic,assign)BOOL newcomer_activity_icon;

@end





/** 首页广告  跳转页面 参数 数据模型 */
@interface AdvertParameterModel :NSObject

@property (nonatomic, copy) NSString *parameter_name;

@property (nonatomic, copy) NSString *value;

@end





/** 首页 广告 数据模型 */
@interface HomeAdvertModel :NSObject

@property (nonatomic, copy) NSString *img_url;
/** H5 类型 类名 */
@property (nonatomic, copy) NSString *className;
/** 广告位 类型 类名 */
@property (nonatomic, copy) NSString *class_name;
/** 参数列表 */
@property (nonatomic, strong) NSMutableArray<AdvertParameterModel*> *list;
/** 极光推送 ID */
@property (nonatomic, copy) NSString *record_id;

/********************* H5 弹窗 ************************/
@property (nonatomic, copy) NSString *h5_url;
/**暴弹广告 是否显示 */
@property (nonatomic, assign) BOOL is_show;

/********************* 文章关注讲师 ************************/
/** yes -已登陆  */
@property (nonatomic, assign) BOOL isLogin;
/** yes -关注  */
@property (nonatomic, assign) BOOL isSubscription;

@property (nonatomic, assign) BOOL newcomer_activity_icon;

/// 标识推送类型, 用于阿里云推送点击统计
@property (nonatomic, copy) NSString *push_type;

@end








/** 映射模型 */
@interface HKMapModel :NSObject

@property (nonatomic,strong) HomeAdvertModel *redirect_package;
/** 参数列表 */
@property (nonatomic, strong) NSMutableArray<AdvertParameterModel*> *list;

@property(nonatomic,strong)fieldModel *field;

@property (nonatomic, copy) NSString *img_url;
/** H5 类型 类名 */
@property (nonatomic, copy) NSString *className;
/** 广告位 类型 类名 */
@property (nonatomic, copy) NSString *class_name;
/** 极光推送 ID */
@property (nonatomic, copy) NSString *record_id;

/********************* H5 弹窗 ************************/
@property (nonatomic, copy) NSString *h5_url;
/**暴弹广告 是否显示 */
@property (nonatomic, assign) BOOL is_show;

/********************* 文章关注讲师 ************************/
/** yes -已登陆  */
@property (nonatomic, assign) BOOL isLogin;
/** yes -关注  */
@property (nonatomic, assign) BOOL isSubscription;

@property (nonatomic, assign) BOOL newcomer_activity_icon;

/********************* banner  ************************/
@property (nonatomic, copy) NSString *img_url_new;

@property (nonatomic, copy) NSString *title;
/** banner id  */
@property (nonatomic, copy) NSString *bannerId;

/********************* 勋章  ************************/
/** 已完成的成就数量 */
@property (nonatomic, assign) NSInteger completedAchieveCount;
/** 未领取奖励的成就数量 */
@property (nonatomic, assign) NSInteger unclaimedAchieveCount;
/** 按钮文案 */
@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *ad_id;

/********************* 分类读书banner图  ************************/
@property (nonatomic, copy)NSString *image_url;

/** 右bar item 按钮名 */
@property (nonatomic, copy) NSString *button_name;

// 1 显示 0隐藏 分享按钮
@property(nonatomic,assign)BOOL status;

@end









