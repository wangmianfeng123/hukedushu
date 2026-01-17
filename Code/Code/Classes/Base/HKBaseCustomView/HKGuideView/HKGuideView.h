//
//  HKGuideView.h
//  Code
//
//  Created by Ivan li on 2018/1/11.
//  Copyright © 2018年 pg. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HKGuideViewType) {
    HKGuideViewType_none = 0,// 普通
    HKGuideViewType_gif,// 加载GIF引导页
};



@interface HKGuideView : UIView
/**
 *  是否支持滑动进入APP(默认为NO-不支持 只有在buttonIsHidden为YES-隐藏状态下可用; buttonIsHidden为NO-显示状态下直接点击按钮进入)
 */
@property (nonatomic, assign) BOOL slideInto;

/**
 图片引导页  (动态图片和静态图片)

 @param frame
 @param imageNameArray
 @param isHidden  开始按钮是否隐藏(YES:隐藏-引导页完成自动进入APP; NO:不隐藏-引导页完成点击开始体验按钮进入APP)
 @return
 */
- (instancetype)initWithFrame:(CGRect)frame imageNameArray:(NSArray<NSString *> *)imageNameArray buttonIsHidden:(BOOL)isHidden  isLoadGif:(BOOL)isLoadGif;

/**
 (视频引导页)

 @param frame
 @param videoURL
 @return
 */
- (instancetype)initWithFrame:(CGRect)frame videoURL:(NSURL *)videoURL;
@end




@interface HKGuideCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *imageView;

@end

