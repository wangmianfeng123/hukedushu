//
//  ZFHKPlayerPortraitSimilarVideoView.h
//  Code
//
//  Created by Ivan li on 2019/3/17.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZFHKPlayerPortraitSimilarVideoViewDelagate <NSObject>

@optional
- (void)ZFHKPlayerPortraitSimilarVideoView:(UIView*)view similarVideo:(VideoModel*)model;

- (void)ZFHKPlayerPortraitSimilarVideoView:(UIView*)view repeatVideo:(VideoModel*)model;

@end


/** 相似 推荐 */
@interface ZFHKPlayerPortraitSimilarVideoView : UIView

@property (nonatomic,strong)VideoModel *model;

@property(nonatomic,weak)id <ZFHKPlayerPortraitSimilarVideoViewDelagate> playerSimilarVideoDelagate;
/** 销毁视图 */
- (void)removeView;

@end
