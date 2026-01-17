//
//  HKTakeGifView.h
//  Code
//
//  Created by Ivan li on 2021/5/19.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKTrainModel;
@interface HKTakeGifView : UIView

- (void)createWithVIPArray:(NSMutableArray *)vipArray liveArray:(NSMutableArray *)liveArray;

@property (nonatomic , strong) void(^didCourseBlock)(HKTrainModel * courseModel);
@property (nonatomic , strong) UIView * contentView;
@property (nonatomic , strong) UIImageView * upImg;
@property (nonatomic , strong) UIImageView * downImg;

- (void)showWithPoint:(CGPoint)point;
@end

NS_ASSUME_NONNULL_END
