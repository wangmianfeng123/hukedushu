//
//  UMpopView.h
//  Code
//
//  Created by Ivan li on 2017/11/9.
//  Copyright © 2017年 pg. All rights reserved.
//／／／／

#import <UIKit/UIKit.h>
#import <UMShare/UMShare.h>


@protocol UMpopViewDelegate <NSObject>
@optional
- (void)uMShareWebSucess:(id)sender;

- (void)uMShareWebFail:(id)sender;

- (void)uMShareImageSucess:(id)sender;

- (void)uMShareImageFail:(id)sender;

@end


@interface UMpopView : UIView

@property(nonatomic,strong)NSMutableArray *imageArr;

@property(nonatomic,strong)NSMutableArray *textArr;

@property(nonatomic,strong)NSMutableArray *platformArr;

@property(nonatomic,strong)ShareModel   *shareModel;

/**选择回调*/
@property(nonatomic,copy)void(^selectBlock)(NSString *selectStr,UMSocialPlatformType platform);
/** 延迟时间 */
@property(nonatomic,assign)NSTimeInterval  second;

@property(nonatomic,weak)id<UMpopViewDelegate> delegate;


//- (instancetype)initWithTitle:(NSMutableArray *)titleAlrr AndWithImage:(NSMutableArray *)imageArr;


+ (instancetype)sharedInstance;

- (void)createUIWithModel:(ShareModel*)shareModel;

/**
 检查 是否 有能分享的平台 （有一个或更多->YES  没有-> NO）
 
 @return
 */
+ (BOOL)isHaveSharePlatform;

/**
 延迟隐藏 销毁视图
 */
- (void)hidePickView;


/**
 立刻 销毁视图
 */
- (void)immediateRemoveView;


/**
 分享图片

 @param platformType 平台
 @param image (id) 需要分享的图片
 */
- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType shareModel:(ShareModel*)shareModel;

/**
  分享 html
  1-先下载图片  2-分享html

 @param model
 @param platformType
 */
- (void)shareHtmlWithModel:(ShareModel*)model  platformType:(UMSocialPlatformType)platformType;

@end




@interface UMpopHeadView : UICollectionReusableView

@end







