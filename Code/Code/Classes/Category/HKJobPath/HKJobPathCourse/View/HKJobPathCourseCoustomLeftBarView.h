//
//  HKJobPathCourseCoustomLeftBar.h
//  Code
//
//  Created by Ivan li on 2019/6/10.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKJobPathCourseCoustomLeftBarView : UIView

@property (nonatomic,strong) UIButton *backBtn;

@property (nonatomic,strong) UILabel *titleLB;

@property (nonatomic,copy) void(^backBtnClickCallBack) ();


- (void)setTitleColor:(UIColor*)color;

@end

NS_ASSUME_NONNULL_END
