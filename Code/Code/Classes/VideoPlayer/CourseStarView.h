//
//  CourseStarView.h
//  Code
//
//  Created by Ivan li on 2017/10/10.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseStarView : UIView

@property(nonatomic,strong)UIImageView *oneImageView;
@property(nonatomic,strong)UIImageView *twoImageView;
@property(nonatomic,strong)UIImageView *threeImageView;
@property(nonatomic,strong)UIImageView *fourImageView;
@property(nonatomic,strong)UIImageView *fiveImageView;

- (instancetype)initWithFrame:(CGRect)frame  courseCount:(NSInteger)courseCount;

- (void)setAllImage:(NSInteger)count;

@end
