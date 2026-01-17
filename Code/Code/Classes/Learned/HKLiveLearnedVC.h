//
//  LearnedVC.h
//  Code
//
//  Created by Ivan li on 2017/7/20.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKBaseVC.h"


@interface HKLiveLearnedVC : HKBaseVC

/** 编辑 （更新cell 约束） */
- (void)editLearnedCell;

//* 视频 数量
@property(nonatomic,assign)NSInteger dataCount;
@property (nonatomic, copy)NSString * payType;  //0.全部 1.免费 2.付费
@end
