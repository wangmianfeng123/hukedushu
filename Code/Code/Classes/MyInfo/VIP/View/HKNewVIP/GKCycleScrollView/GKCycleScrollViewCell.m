//
//  GKCycleScrollViewCell.m
//  GKCycleScrollViewDemo
//
//  Created by QuintGao on 2019/9/15.
//  Copyright © 2019 QuintGao. All rights reserved.
//

#import "GKCycleScrollViewCell.h"
#import "HKVIPPriceView.h"

@interface GKCycleScrollViewCell ()
@property (nonatomic , strong) HKVIPPriceView * contentView;
@end

@implementation GKCycleScrollViewCell

-(HKVIPPriceView *)contentView{
    if (_contentView == nil) {
        _contentView = [HKVIPPriceView viewFromXib];//(210.0 * Ratio, 128.0)
        _contentView.hidden = YES;
    }
    return _contentView;
}

-(void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    self.contentView.currentIndex = currentIndex;
}

-(void)setModel:(HKBuyVipModel *)model{
    _model = model;
    self.contentView.model = model;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        
        [self addSubview:self.imageView];
        [self addSubview:self.contentView];
        [self addSubview:self.coverView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    // IS_IPHONE ? CGSizeMake(210.0 * Ratio, 150 * Ratio) : CGSizeMake((SCREEN_WIDTH * 150.0/375.0 - 60 - 35 - 40) * 210 / 150, (SCREEN_WIDTH * 150.0/375.0 - 60 - 35 - 40));
    _contentView.frame = IS_IPHONE ? CGRectMake(0,0,210.0 * Ratio, 150 * Ratio) : CGRectMake(0,0,(SCREEN_WIDTH * 150.0/375.0 - 60 - 35 - 40) * 210 / 150, (SCREEN_WIDTH * 150.0/375.0 - 60 - 35 - 40));
} 

- (void)handleTapGesture:(UITapGestureRecognizer *)tap {
    !self.didCellClick ? : self.didCellClick(self.tag);
}

- (void)setupCellFrame:(CGRect)frame {
    if (CGRectEqualToRect(self.imageView.frame, frame)) return;
    
    self.imageView.frame = frame;
    self.coverView.frame = frame;
    self.contentView.frame = frame;
}

-(void)setFromVip:(BOOL)fromVip{
    _fromVip = fromVip;
    self.contentView.hidden = !fromVip;
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
