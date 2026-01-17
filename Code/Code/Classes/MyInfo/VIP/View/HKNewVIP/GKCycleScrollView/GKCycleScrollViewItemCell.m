//
//  GKCycleScrollViewItemCell.m
//  Code
//
//  Created by eon Z on 2022/3/4.
//  Copyright © 2022 pg. All rights reserved.
//

#import "GKCycleScrollViewItemCell.h"

@interface GKCycleScrollViewItemCell ()

@end

@implementation GKCycleScrollViewItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        
        [self addSubview:self.imageView];
        [self addSubview:self.coverView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tap {
    !self.didCellClick ? : self.didCellClick(self.tag);
}

- (void)setupCellFrame:(CGRect)frame {
    if (CGRectEqualToRect(self.imageView.frame, frame)) return;
    
    self.imageView.frame = frame;
    self.coverView.frame = frame;
}

#pragma mark - 懒加载
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    return _imageView;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [UIView new];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.userInteractionEnabled = NO;
    }
    return _coverView;
}


@end
