//
//  CourseStarView.m
//  Code
//
//  Created by Ivan li on 2017/10/10.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "CourseStarView.h"

#define defalutImage  @"comment_gray"

@implementation CourseStarView


- (instancetype)initWithFrame:(CGRect)frame  courseCount:(NSInteger)courseCount {
    
    if (self = [super initWithFrame:frame]) {
        
        //[self createUI:courseCount];
        [self createUI];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame  {
    
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];
    }
    return self;
}


- (void)createUI {
    
    [self addSubview:self.oneImageView];
    [self addSubview:self.twoImageView];
    [self addSubview:self.threeImageView];
    [self addSubview:self.fourImageView];
    [self addSubview:self.fiveImageView];
    [self makeConstraints];
}



- (void)makeConstraints {
    
    /** @param axisType 布局方向 * @param fixedSpacing 两个item之间的间距(最左面的item和左边, 最右边item和右边都不是这个)
     * @param leadSpacing 第一个item到父视图边距 * @param tailSpacing 最后一个item到父视图边距*/
    [@[self.oneImageView, self.twoImageView, self.threeImageView, self.fourImageView, self.fiveImageView] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:PADDING_5 leadSpacing:0 tailSpacing:0];
    
    [@[self.oneImageView, self.twoImageView, self.threeImageView, self.fourImageView, self.fiveImageView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
    }];
}

- (UIImageView*)oneImageView {
    if (!_oneImageView) {
        _oneImageView = [UIImageView new];
        _oneImageView.image = imageName(defalutImage);
    }
    return _oneImageView;
}


- (UIImageView*)twoImageView {
    if (!_twoImageView) {
        _twoImageView = [UIImageView new];
        _twoImageView.image = imageName(defalutImage);
    }
    return _twoImageView;
}


- (UIImageView*)threeImageView {
    if (!_threeImageView) {
        _threeImageView = [UIImageView new];
        _threeImageView.image = imageName(defalutImage);
    }
    return _threeImageView;
}

- (UIImageView*)fourImageView {
    if (!_fourImageView) {
        _fourImageView = [UIImageView new];
        _fourImageView.image = imageName(@"comment_gray");
    }
    return _fourImageView;
}

- (UIImageView*)fiveImageView {
    if (!_fiveImageView) {
        _fiveImageView = [UIImageView new];
        _fiveImageView.image = imageName(defalutImage);
    }
    return _fiveImageView;
}


- (void)setAllImage:(NSInteger)count {

    UIImage *image = imageName(defalutImage);
    UIImage *selectImage = imageName(@"comment_yellow");
    //NSLog(@"count ---- %ld",count);
    
    if (0==count) {
        self.oneImageView.image = image;
        self.twoImageView.image = image;
        self.threeImageView.image = image;
        self.fourImageView.image = image;
        self.fiveImageView.image = image;
    }else if(1== count){
        self.oneImageView.image = selectImage;
        self.twoImageView.image = image;
        self.threeImageView.image = image;
        self.fourImageView.image = image;
        self.fiveImageView.image = image;
        
    }else if (2== count){
        self.oneImageView.image = selectImage;
        self.twoImageView.image = selectImage;
        self.threeImageView.image = image;
        self.fourImageView.image = image;
        self.fiveImageView.image = image;
    }else if (3== count){
        
        self.oneImageView.image = selectImage;
        self.twoImageView.image = selectImage;
        self.threeImageView.image = selectImage;
        self.fourImageView.image = image;
        self.fiveImageView.image = image;
    }else if (4== count){
        
        self.oneImageView.image = selectImage;
        self.twoImageView.image = selectImage;
        self.threeImageView.image = selectImage;
        self.fourImageView.image = selectImage;
        self.fiveImageView.image = image;
    }else {
        self.oneImageView.image = selectImage;
        self.twoImageView.image = selectImage;
        self.threeImageView.image = selectImage;
        self.fourImageView.image = selectImage;
        self.fiveImageView.image = selectImage;
    }
}



@end
