//
//  UMpopScreenshotView.h
//  Code
//
//  Created by Ivan li on 2018/5/22.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <UMShare/UMShare.h>


@protocol UMpopScreenshotViewDelegate <NSObject>
@optional
- (void)uMScreenshotShareSucess:(id)sender;

- (void)uMScreenshotShareFail:(id)sender;

@end


@interface UMpopScreenshotView : UIView

@property(nonatomic,strong)NSMutableArray *imageArr;

@property(nonatomic,strong)NSMutableArray *textArr;

@property(nonatomic,strong)NSMutableArray *platformArr;

@property(nonatomic,copy)void(^selectBlock)(NSString *selectStr,UMSocialPlatformType platform); //选择回调

//@property(nonatomic,copy)void(^selectPlatformBlock)(NSString *selectStr,UMSocialPlatformType platform,UMpopView *sender); //选择回调
/** 延迟时间 */
@property(nonatomic,assign)NSTimeInterval  second;

@property(nonatomic,weak)id<UMpopScreenshotViewDelegate> delegate;

@property(nonatomic,strong)UIImage *shotScreenImage;


//- (instancetype)initWithTitle:(NSMutableArray *)titleAlrr AndWithImage:(NSMutableArray *)imageArr;


+ (instancetype)sharedInstance;

- (void)createUI;

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
 @param image 需要分享的图片
 */
- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType  image:(UIImage*)image;

/**
 分享 html
 1-先下载图片  2-分享html
 
 @param model
 @param platformType
 */
- (void)shareHtmlWithModel:(ShareModel*)model  platformType:(UMSocialPlatformType)platformType;


@end



@interface UMpopScreenshotHeadView : UICollectionReusableView

@property(nonatomic,strong)UIImage *shotImage;

@end







