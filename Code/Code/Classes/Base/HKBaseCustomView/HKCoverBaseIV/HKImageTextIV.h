//
//  HKImageTextIV.h
//  Code
//
//  Created by Ivan li on 2018/10/21.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HKLiveAnimationType) {
    /** 直播列表 */
    HKLiveAnimationType_liveList,
    /** 详情目录 */
    HKLiveAnimationType_videoDetail,
    /** 分类直播列表 */
    HKCategaryAnimationType_liveList,
};

@interface HKImageTextIV : UIImageView

@property (nonatomic,copy) NSString *text;
/** 字体颜色 */
@property (nonatomic,strong) UIColor *textColor;

@property (nonatomic,strong)UIFont *font;
/** 动画  */
@property (nonatomic,copy) NSString *animationName;

@property (nonatomic,assign) BOOL isAnimation;

@property (nonatomic,assign)HKLiveAnimationType liveAnimationType;
/** 背景图片 */
@property (nonatomic,strong)UIImage *backGroundImage;
@property (nonatomic,strong)UIImage *otherGroundImage;

@property (nonatomic,assign) BOOL isRemoveRoundedCorner;
@property (nonatomic,assign) BOOL isCategoryLeftCell;

/** 是否文字为空就隐藏 */
- (void)text:(NSString *)text hiddenIfTextEmpty:(BOOL)hidden;
- (void)hideText:(BOOL )hideText hideAnimation:(BOOL)hideAnimation;


@end

