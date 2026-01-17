//
//  HKFeedbackView.h
//  Code
//
//  Created by Ivan li on 2019/3/11.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HKFeedbackViewDelegate <NSObject>

@optional

- (void)submitComment:(NSInteger)selectIndex  comment:(NSString*)comment;
- (void)textlength:(NSInteger)lenth;
@end

@interface HKFeedbackView : UIView<UITextViewDelegate>

@property(nonatomic,strong)UITextView *feedbackView;

@property(nonatomic,strong)UILabel  *pointLabel;

@property(nonatomic,weak)id <HKFeedbackViewDelegate> deletate;

@property(nonatomic,assign)HKCommentType commentType;
@property (nonatomic , assign) NSInteger longestLenth ;

@end

NS_ASSUME_NONNULL_END
