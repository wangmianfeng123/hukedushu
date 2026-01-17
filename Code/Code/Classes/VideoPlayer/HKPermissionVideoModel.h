//
//  HKPermissionVideoModel.h
//  Code
//
//  Created by Ivan li on 2017/9/3.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>


@class PlayTimeModel;


@interface HKPermissionVideoModel : NSObject

//is_vip：0-非VIP（不可下载） 1-限5VIP（不可下载） 2-全站VIP或分类无限VIP（可下载）

//is_paly：0-不可观看 1-可观看

/** 0 - 限5分类VIP 显示受限开通VIP   1- 显示升级VIP */
@property(nonatomic,copy)NSString *is_buyvip;

@property(nonatomic,copy)NSString *is_vip;

@property (nonatomic, copy)NSString *tx_video_url;

@property (nonatomic, copy)NSString *qn_video_url;

@property(nonatomic,copy)NSString *is_paly;

@property(nonatomic,copy)NSString *video_url;
@property(nonatomic,copy)NSString *url;//直播回看url

@property(nonatomic,copy)NSString *class_name;

@property(nonatomic,strong)PlayTimeModel *play_time;
/** Yes - 分享次数用完  */
@property(nonatomic,assign)BOOL is_video_share_over_num;

//@property(nonatomic,copy)NSString *play_time;
/** vip 名称 */
@property(nonatomic,copy)NSString *vip_name;

@property(nonatomic,copy)NSString *video_type;
@property(nonatomic,copy)NSString *videoId;

@property(nonatomic,copy)NSString *obtain_gold;

/********************** PGC **********************/

/** 0-不可下载 1-可下载 */
@property(nonatomic,copy)NSString *is_download;

/** 0-不可通过分享获得观看机会 1-当天可通过分享获得观看机会（当天未分享过）*/
@property(nonatomic,copy)NSString *is_share;

/******** 音频 *******/
//is_paly：0-不可观看 1-可观看；class_type：播放受限时请求VIP列表接口要携带
@property(nonatomic,copy)NSString *class_type;

@property(nonatomic,strong)HKMapModel *vipRedirect;
/// 是否被静音, 显示提示
@property(nonatomic,assign)BOOL  is_mute;
/** yes - 可下载 */
@property(nonatomic,assign)BOOL  can_download;

@property(nonatomic,copy)NSString *business_message;
/// （200 成功） 否则是错误
@property(nonatomic,assign)NSInteger business_code;
//腾讯云filedID
@property (nonatomic,copy) NSString * tx_file_id;
@property (nonatomic,copy) NSString * tx_token;
@property (nonatomic,strong) HKMapModel *cannotPlayRedirect;
/** YES - 从下载完成视频进入到详情  NO-默认   */
@property(nonatomic,assign)BOOL isFromDownload;

@end









@interface PlayTimeModel : NSObject
/** 进度 */
@property(nonatomic,assign)NSInteger time;
/** 客户端类型 */
@property(nonatomic,assign)NSInteger client;
/** 是否观看完毕 0否 1是 */
@property(nonatomic,assign)NSInteger is_end;
/** 记录时间 */
//@property(nonatomic,assign)NSInteger updated_at;

@property(nonatomic,copy)NSString *updated_at;

@end











