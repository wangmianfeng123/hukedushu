//
//  HKShortVideoModel.h
//  Code
//
//  Created by Ivan li on 2019/3/29.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HKUserModel,ShareModel,HKShortVideoTagModel;

NS_ASSUME_NONNULL_BEGIN

@interface HKShortVideoModel : NSObject
/** */
@property(nonatomic,copy)NSString *cover_url;
/** 视频ID */
@property(nonatomic,copy)NSString *video_id;
/** like 是否点赞 0:未点赞 1:已点赞**/
@property(nonatomic,assign)BOOL like;
/** 点赞总数 */
@property(nonatomic,assign)NSInteger likeCount;

@property(nonatomic,copy)NSString *tid;  //tid 讲师ID

@property(nonatomic,copy)NSString *video_url;
/** 视频备注 */
@property(nonatomic,copy)NSString *desc;

/**  flower 是否关注 0:未关注 1:已关注   avator 讲师头像**/
@property(nonatomic,strong)HKUserModel *teacher;
/** 短视频 tab 1:展示，0:不展示 */
@property(nonatomic,assign)NSInteger status;

//superscript #限免角标1:展示，0:不展示
@property(nonatomic,assign)NSInteger superscript;

@property(nonatomic,assign)BOOL isStartPlay;

@property(nonatomic,assign)BOOL isHiddenBottomView;

@property (nonatomic, strong)ShareModel *share_data; // 分享数据

@property (nonatomic, copy)NSString *commentCount; // 评论数量

@property (nonatomic, copy)NSString *tag_id; // 分类id

@property (nonatomic, copy)NSString *playCount; // 分类id

/// 0：没有开启关联视频 关联视频ID
@property (nonatomic, copy)NSString *relation_video_id;
/// 0:不关联 1:来源视频 2:推荐视频
@property (nonatomic, copy)NSString *relation_type;

/** 所属标签 */
@property (nonatomic,strong) HKShortVideoTagModel *video_tag;

@end




@interface HKShortVideoTagModel : NSObject

@property (nonatomic, copy)NSString *tag_id;

@property (nonatomic, copy)NSString *tag;

@end



NS_ASSUME_NONNULL_END
