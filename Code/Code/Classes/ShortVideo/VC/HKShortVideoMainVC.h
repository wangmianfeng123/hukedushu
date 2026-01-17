//
//  HKShortVideoMainVC.h
//  Code
//
//  Created by Ivan li on 2019/3/25.
//  Copyright © 2019年 pg. All rights reserved.111
//

#import "HKBaseVC.h"
#import "HKShortVideoModel.h"
#import "HKShortVideoHomeVC.h"
#import <ZFPlayer.h>

NS_ASSUME_NONNULL_BEGIN
@class ZFPlayerController;//ZFHKNormalPlayerController;

@interface HKShortVideoMainVC : HKBaseVC <HKShortVideoHomeVCDelegate>

//@property (nonatomic, strong,readonly) ZFHKNormalPlayerController *player;
@property (nonatomic, strong,readonly) ZFPlayerController *player;

/** 默认 NO */
@property (nonatomic,assign) BOOL showBackBtn;

@property (nonatomic,assign,getter=isHiddenFooter) BOOL hiddenFooter;

@property (nonatomic,strong)LOTAnimationView  *praiseAnimationView;

@property (nonatomic,strong)LOTAnimationView  *scrollAnimationView;

@property (nonatomic,copy)NSString *videoId;

@property (nonatomic, strong) NSMutableArray <HKShortVideoModel*> *dataSource;

/**********  分类点击进入  **********/
@property (nonatomic, strong)HKShortVideoModel *tag_model; // 分类旗下的某个实例model
@property (nonatomic, strong) NSMutableArray <HKShortVideoModel*> *dataSourceTemp;
@property (nonatomic, copy)void(^deallocBlock)();
/**********  分类点击进入  **********/

/** 分类标签点击回调 */
@property (nonatomic, copy) void(^shortVideoTagClickCallBack)(HKShortVideoModel *model);
/** 完整视频点击回调 */
@property (nonatomic, copy) void(^shortVideoWholeVideoClickCallBack)(HKShortVideoModel *model);
/** 短视频 类型 */
@property (nonatomic,assign) HKShortVideoType shortVideoType;

@property (nonatomic, strong)HKUserModel *teacher; // 讲师的抖音

@property (nonatomic, strong)HKUserModel *user; // 普通用户的点赞点视频

/** 当前请求数据的页码 */
@property (nonatomic, assign)NSInteger page;

@end

NS_ASSUME_NONNULL_END

