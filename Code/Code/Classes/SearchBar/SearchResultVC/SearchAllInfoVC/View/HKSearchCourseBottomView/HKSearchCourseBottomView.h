//
//  HKSearchCourseBottomView.h
//  Code
//
//  Created by Ivan li on 2019/4/10.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKSearchCourseBottomView : UIView


@property (nonatomic,strong) UIImageView *bgIV;

@property (nonatomic,strong) UILabel *tipLB;

@property (nonatomic,strong) UIButton *closeBtn;

@property (nonatomic,copy) void(^closeClickCallback)(void);

@property (nonatomic,assign)BOOL isShow;

@end

NS_ASSUME_NONNULL_END
