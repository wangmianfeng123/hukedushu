//
//  HKAlbumShadowImageView.h
//  Code
//
//  Created by Ivan li on 2018/3/2.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKAlbumShadowImageView : UIView

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

@end




