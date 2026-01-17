//
//  HomeMyFollowVideoV3Cell.h
//  Code
//
//  Created by yxma on 2020/11/11.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKRecommendTxtModel;

@interface HomeMyFollowVideoV3Cell : UICollectionViewCell
//@property (nonatomic , strong) HKUserModel * model;
@property (nonatomic , strong) HKRecommendTxtModel * model;
@property (nonatomic, copy)void(^followTeacherSelectedBlock)(HKRecommendTxtModel * model);

@end

NS_ASSUME_NONNULL_END
