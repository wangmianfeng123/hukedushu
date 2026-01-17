//
//  HomeVideoVC+Category.h
//  Code
//
//  Created by Ivan li on 2018/1/11.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HomeVideoVC.h"

@class BannerModel,HKMapModel,HKMyInfoMapPushModel;

@interface HomeVideoVC (Category)

/**
 设置 引导页
 
 @param imageArray 图片名称数组
 */
- (void)setGuideViewWithImageArray:(NSArray *)imageArray isLoadGif:(BOOL)isLoadGif;

/**
 设置 新手引导页
 */
- (void)setNewUserGuideView;


/**
 设置 新用户 免费观看视频次数 提示
 */
- (void)setNewUserPointView;


/**
 获得 极光推送 RegistrationID
 */
- (void)getJpushRegistrationID;

/**
 删除 极光推送 别名
 */
- (void)deleteJpushAlias;


/**
 设置 极光推送 设备别名
 */
- (void)setJpushAlias;

/** 首页音频 引导 */
- (void)setHomeAudioGuideView :(CGRect)rect;

/** 首页文章 引导 */
//- (void)setHomeArticleGuideView :(CGRect)rect;

/**
 设置当前学习
 */
- (void)setCurrentVideoModelTip:(VideoModel *)video;

/**
 统计banner 点击次数
 
 @param bannerId
 */
- (void)recordBannerClickCount:(NSString*)bannerId;


/** banner 点击 跳转
 * type  1-H5页面 2-视频详情页 3-列表页 4-VIP页  5-浏览器 appstore
 *
 */
- (void)homeBannerClick:(HKMapModel*)model;


/** html 弹窗 */
- (void)setHtmlDialogVC;

/**
 * 发送红点 通知
 **/
- (void)postRedPointNoti:(NSMutableArray<HKMyInfoMapPushModel*> *)mapArr;

/**
 * 设置 IM 引导
 **/
- (void)setIMGuideView;
/**
 * 移除 IM 引导
 **/
- (void)removeIMGuideView;


/**
 设置 短视频 引导
 */
- (void)setReadBookGuideView;

/**
 删除 短视频 引导
 */
- (void)removeReadBookGuideView;

/**
 极验登录 配置
 */
- (void)loginConfigData;

/// 浏览器跳转来 获取data并跳转
- (void)webBrowserPushTargetVCWithWebUrl:(NSString*)url;

/**
 设置登录view
 */
- (void)setHomeLoginView;


/// 判断token是否过期
/// @param resultBlock 判断结束的回调
- (void)calculateTimeDifference:(void(^)(void))resultBlock;

- (void)videoCountTip:(NSString*)count;
@end






//视频搜索 讲师搜索 用户优惠券  系列课视频列表 评论列表 用户关注列表  分类视频列表   分类首页
//@Ivan-coo 可以看一下这些地方   有没有total_page返回
