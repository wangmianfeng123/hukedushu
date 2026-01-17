//
//  HKCommentContentView.h
//  Code
//
//  Created by Ivan li on 2020/12/23.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKFeedbackView;

@protocol HKCommentContentViewDelegate <NSObject>

- (void)commentContentViewChooseImg;

@end

@interface HKCommentContentView : UIView

@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic,weak) id <HKCommentContentViewDelegate> delegate;
@property (nonatomic , strong) HKFeedbackView * feedBackView;
@end

NS_ASSUME_NONNULL_END
