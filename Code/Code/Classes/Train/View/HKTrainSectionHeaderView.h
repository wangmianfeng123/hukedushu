//
//  HKTrainSectionHeaderView.h
//  Code
//
//  Created by yxma on 2020/8/24.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HKTrainSectionHeaderViewDelegate <NSObject>

- (void)trainSectionHeaderViewClickBtn;

@end

@interface HKTrainSectionHeaderView : UIView
@property (nonatomic, weak) id <HKTrainSectionHeaderViewDelegate>delegate;
@property (nonatomic, copy) void(^btnClickBlock)(NSInteger tag);

- (void)clickBtnIndex:(NSInteger)tag;
+ (HKTrainSectionHeaderView *)createViewByFrame:(CGRect)frame byDelegate:(id)delegate;

@end

NS_ASSUME_NONNULL_END
