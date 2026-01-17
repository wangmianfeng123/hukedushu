//
//  HKTeacherDouYinVC.h
//  Code
//
//  Created by Ivan li on 2017/7/20.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKBaseVC.h"


@interface HKTeacherDouYinVC : HKBaseVC 

@property (nonatomic, strong)HKUserModel *teacher; // 讲师的抖音

@property (nonatomic, strong)HKUserModel *user; // 普通用户的点赞点视频

@property (nonatomic, assign)BOOL isFromMyStudy; // 我的学习，调整inset

@end

