//
//  HKMomentDetailModel.h
//  Code
//
//  Created by Ivan li on 2021/1/25.
//  Copyright © 2021 pg. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HKMonmentUserModel ,HKMonmentTopicModel,HKMonmentReplyModel,HKMonmentVideoModel,HKMonmentDynamicModel,HKMonmentTagModel,HKMonmentTagModel;

@interface HKMomentDetailModel : NSObject
@property (nonatomic , assign) BOOL isRecommandUser ;
@property (nonatomic , strong) HKMonmentUserModel * user;
@property (nonatomic , strong) HKMonmentTopicModel * topic;
@property (nonatomic , strong,nullable) NSArray <HKMonmentReplyModel *> * recentlyReplies;
//@property (nonatomic , strong) NSArray <HKMonmentSubjectModel *> * subjects;
@property (nonatomic , strong) NSArray <HKMonmentTagModel *> * subjects;



@property (nonatomic , strong, nullable) HKMonmentVideoModel * video;
@property (nonatomic , strong) HKMonmentDynamicModel * dynamic;
@property (nonatomic , strong) NSMutableArray <HKMonmentTagModel *>* tagsArray;//全部动态顶部的话题数组

@property (nonatomic, strong)ShareModel *share_data;//分享

@end


@interface HKMonmentUserModel : NSObject //社区动态作者
@property (nonatomic, copy)NSString * uid;  //
@property (nonatomic, copy)NSString * avatar;  //
@property (nonatomic, copy)NSString * username;  //
@property (nonatomic, assign)BOOL  subscribed;  //
@property (nonatomic, strong)NSNumber * userVipType;  //
@property (nonatomic, assign)BOOL  hideSubscribe;  //
@property (nonatomic , assign) BOOL isTeacher ;
@end


@interface HKMonmentTopicModel : NSObject //社区动态内容
@property (nonatomic, copy)NSString * ID;  //
@property (nonatomic, copy)NSString * content;  //
@property (nonatomic, copy)NSString * created_at;  //
@property (nonatomic, strong)NSNumber * reply_count;  //
@property (nonatomic, strong)NSNumber * likes_count;  //
@property (nonatomic, strong)NSNumber * connectType;  //
@property (nonatomic, assign)BOOL canDelete;  //
@property (nonatomic, assign)BOOL isLiked;  //
@property (nonatomic, copy)NSString * url;  //
@property (nonatomic , assign) BOOL is_top ;
@end

@interface HKMonmentReplyModel : NSObject //社区动态回复
@property (nonatomic, copy)NSString * topic_id;  //
@property (nonatomic, copy)NSString * uid;  //
@property (nonatomic, copy)NSString * avatar;  //
@property (nonatomic, copy)NSString * content;  //
@property (nonatomic, copy)NSString * created_at;  //
@property (nonatomic, copy)NSString * username;  //

@end

//@interface HKMonmentSubjectModel : NSObject //社区动态标签
//@property (nonatomic, copy)NSString * topic_id;  //
//@property (nonatomic, copy)NSString * ID;  //
//@property (nonatomic, copy)NSString * name;  //
//@end


@interface HKMonmentVideoModel : NSObject //社区动态来源视频
@property (nonatomic, copy)NSString * videoId;  //
@property (nonatomic, copy)NSString * title;  //
@property (nonatomic, copy)NSString * teacherName;  //
@property (nonatomic, copy)NSString * teacherAvatar;  //
@property (nonatomic, copy)NSString * teacherUid;  //
@property (nonatomic, copy)NSString * teacherId;  //
@property (nonatomic, copy)NSString * cover;  //

@end


@interface HKMonmentDynamicModel : NSObject  //社区动态 - 作品,作业，图片
@property (nonatomic, strong)NSMutableArray * images;  //
@property (nonatomic, copy)NSString * imageUrl;  //
@property (nonatomic, assign)BOOL isEmpty;  //
@property (nonatomic, strong)NSNumber * connectType;  //
@property (nonatomic, strong)NSNumber * contentType;  //
@property (nonatomic, copy)NSString * title;  //
@property (nonatomic, copy)NSString * cover;  //作品封面,为空表示没有封面
@property (nonatomic, copy)NSString * descriptions;  //
@property (nonatomic, copy)NSString * duration;  //

@property (nonatomic, strong)NSNumber * videoId;  //
@property (nonatomic, strong)NSNumber * hasContent;  //
@property (nonatomic, copy)NSString * software;  //
@property (nonatomic, copy)NSString * courseId    ;  //
@property (nonatomic, copy)NSString * smallId    ;  //
@property (nonatomic, copy)NSString * startAt    ;  //
@property (nonatomic, copy)NSString * difficulty    ;  //
@property (nonatomic, assign)BOOL isLiving    ;  //
@end

@interface HKSubjectInfoModel : NSObject
@property (nonatomic, strong)NSNumber * ID;  //
@property (nonatomic, copy)NSString * name;  //
@property (nonatomic, copy)NSString * icon_url;  //
@property (nonatomic, strong)NSString * used_count;  //
@property (nonatomic, strong)NSString * view_count;  //
@property (nonatomic, strong)NSString * reply_count;  //

@property (nonatomic, strong)ShareModel *share_data;

//@property (nonatomic , strong) NSMutableArray <HKMonmentTagModel *>* order; //排序



@end


@interface HKrecommendUserModel : NSObject
@property (nonatomic, strong)NSString * uid;  //
@property (nonatomic, copy)NSString * username;  //
@property (nonatomic, copy)NSString * avatar;  //
@property (nonatomic, strong)NSString * desc;  //
@property (nonatomic , copy) NSString * descPrefix;
@property (nonatomic , copy) NSString * descSuffix;

@property (nonatomic, assign)BOOL  subscribed;  //是否关注

@end


NS_ASSUME_NONNULL_END
