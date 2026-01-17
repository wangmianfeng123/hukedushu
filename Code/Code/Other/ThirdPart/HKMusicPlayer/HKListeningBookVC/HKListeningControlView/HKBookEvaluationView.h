//
//  HKBookEvaluationView.h
//  Code
//
//  Created by Ivan li on 2019/8/26.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HKBookEvaluationViewType) {
    HKBookEvaluationViewType_listening = 0, // 读书详情
    HKBookEvaluationViewType_commentList, // 评论列表
};

NS_ASSUME_NONNULL_BEGIN

@class HKBookEvaluationView;

@protocol HKBookEvaluationViewDelegate <NSObject>
@optional
// 评价按钮点击
- (void)bookEvaluationView:(HKBookEvaluationView*)view commentBtn:(UIButton*)commentBtn;
// 收藏按钮点击
- (void)bookEvaluationView:(HKBookEvaluationView*)view collectBtn:(UIButton*)collectBtn;
// 评价LB点击
- (void)bookEvaluationView:(HKBookEvaluationView*)view commentLB:(UILabel*)commentLB;

@end

@interface HKBookEvaluationView : UIView

@property (nonatomic,weak)id <HKBookEvaluationViewDelegate> delegate;

@property (nonatomic,strong)HKBookModel   *bookModel;

@property (nonatomic,assign)HKBookEvaluationViewType evaluationViewType;

@end

NS_ASSUME_NONNULL_END
