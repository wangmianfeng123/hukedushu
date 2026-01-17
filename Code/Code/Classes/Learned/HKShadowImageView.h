//
//  HKShadowImageView.h
//  Code
//
//  Created by Ivan li on 2018/1/23.
//  Copyright © 2018年 pg. All rights reserved.
//

//#import <FLAnimatedImage/FLAnimatedImage.h>

typedef NS_ENUM(NSUInteger, HKShadowImageViewType) {
    /** 居中 */
    HKShadowImageViewTypeCenter = 0,
    /** 偏左 */
    HKShadowImageViewTypeLeft = 1
};



@interface HKShadowImageView : UIView
/** 阴影 角度 */
@property (nonatomic,assign) float cornerRadius;
/** 阴影 偏移距离 */
@property (nonatomic,assign) float offSet;
/** 阴影 左偏移距离 */
@property (nonatomic,assign) float leftOffSet;

/** 第一层 阴影图片 名字 */
@property (nonatomic,copy) NSString *firstImageName;
/** 第二层 阴影图片 名字 */
@property (nonatomic,copy) NSString *secondImageName;
/** 第三层 阴影图片 名字 */
@property (nonatomic,copy) NSString *thirdImageName;

@property(nonatomic,assign)HKShadowImageViewType shadowType;

@end
