//
//  UMpopView.h
//  Code
//
//  Created by Ivan li on 2017/11/9.
//  Copyright © 2017年 pg. All rights reserved.
//／／／／

#import <UIKit/UIKit.h>
#import <UMShare/UMShare.h>


@protocol HKUMpopViewDelegate <NSObject>

- (void)removeUMpopView:(id)sender;

@end

@interface HKUMpopView : UIView

@property(nonatomic,strong)NSMutableArray *imageArr;

@property(nonatomic,strong)NSMutableArray *textArr;

@property(nonatomic,strong)NSMutableArray *platformArr;

@property(nonatomic,copy)void(^selectBlock)(NSString *selectStr,UMSocialPlatformType platform); //选择回调

@property(nonatomic,weak)id <HKUMpopViewDelegate> delegate;



//- (instancetype)initWithTitle:(NSMutableArray *)titleAlrr AndWithImage:(NSMutableArray *)imageArr;

/**
 检查 是否 有能分享的平台 （有一个或更多->YES  没有-> NO）
 
 @return
 */
+ (BOOL)isHaveSharePlatform;
@end


@interface HKUMpopHeadView : UICollectionReusableView

@end







