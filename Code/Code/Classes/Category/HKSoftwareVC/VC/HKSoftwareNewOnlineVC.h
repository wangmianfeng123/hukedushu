//
//  HKSoftwareNewOnlineVC.h
//  Code
//
//  Created by Ivan li on 2018/4/2.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKBaseVC.h"

@class HKTagModel;

@interface HKSoftwareNewOnlineVC : HKBaseVC
/** 热门 */
@property (nonatomic,strong)NSMutableArray *hotArr;
/** 最新 */
//@property (nonatomic,strong)NSMutableArray *newestArr;
/** 0--热门  1--最新上线 */
@property (nonatomic,assign)NSInteger type;

@property (nonatomic,strong)HKTagModel *tagModel;

- (void)loadNewDataWithModel:(HKTagModel *)tagModel;

@end





@interface HKSoftwareTitleView :UIView

@property (nonatomic,strong) NSMutableArray <HKTagModel*>*titlesArr;

@property (nonatomic,strong) NSMutableArray <UIButton*>*btnArr;

@property(nonatomic,copy)void (^titleClickCallBack)(NSInteger index,HKTagModel *tagModel);

@property(nonatomic,assign)NSInteger row;


/// 重新 设置字体颜色 和背景
- (void)resetBtnNormalUI;

@end
