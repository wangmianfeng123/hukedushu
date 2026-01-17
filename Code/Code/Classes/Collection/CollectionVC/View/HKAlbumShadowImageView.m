//
//  HKAlbumShadowImageView.m
//  Code
//
//  Created by Ivan li on 2018/3/2.
//  Copyright © 2018年 pg. All rights reserved.


#import "HKAlbumShadowImageView.h"

@interface HKAlbumShadowImageView()

@property(nonatomic,strong)UIImageView *blackBgView;

@property(nonatomic,strong)UIImageView *grayBgView;

@property(nonatomic,strong)UIImageView *firstBgView;

@end


@implementation HKAlbumShadowImageView

- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    
    self.backgroundColor = [UIColor clearColor];
    self.cornerRadius = (self.cornerRadius==0.0) ?3 :self.cornerRadius;
    self.offSet = (self.offSet==0.0) ?3 :self.offSet;
    
    self.leftOffSet = 6;
    
//    [self addSubview:self.firstBgView];
//    [self insertSubview:self.blackBgView belowSubview:self.firstBgView];
//    [self insertSubview:self.grayBgView belowSubview:self.blackBgView];
    [self addSubview:self.blackBgView];
    [self insertSubview:self.grayBgView belowSubview:self.blackBgView];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeconst];
}



- (void)makeconst {
    
    [_blackBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(self.offSet);
        make.bottom.equalTo(self).offset(-self.offSet);
        make.left.equalTo(self).offset(self.leftOffSet);
        make.right.equalTo(self).offset(-self.leftOffSet);
    }];
    
    [_grayBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.blackBgView).offset(self.leftOffSet);
        make.right.equalTo(self.blackBgView).offset(-self.leftOffSet);
        make.top.equalTo(self.blackBgView).offset(-self.offSet);
        make.bottom.equalTo(self.blackBgView).offset(-self.offSet);
    }];
}


- (void)makeconst_1 {
    
    [_firstBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(2*self.offSet);
        make.bottom.right.equalTo(self);
    }];
    
    [_blackBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(self.offSet-1);
        make.bottom.right.equalTo(self).offset(-self.offSet);
    }];
    
    [_grayBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.blackBgView).offset(-self.offSet);
        make.top.equalTo(self.blackBgView).offset(-self.offSet);
        make.size.mas_equalTo(self.blackBgView);
    }];
}



- (UIImageView*)firstBgView {
    if (!_firstBgView) {
        _firstBgView = [UIImageView new];
        _firstBgView.image = imageName(isEmpty(_firstImageName) ?@"222copy" :_firstImageName);
    }
    return _firstBgView;
}



- (UIImageView*)blackBgView {
    if (!_blackBgView) {
        _blackBgView = [UIImageView new];
        _blackBgView.image = imageName(isEmpty(_secondImageName) ?(@"222copy") :_secondImageName);
    }
    return _blackBgView;
}


- (UIImageView*)grayBgView {
    if (!_grayBgView) {
        _grayBgView = [UIImageView new];
        _grayBgView.image = imageName(isEmpty(_secondImageName) ?(@"333copy") :_secondImageName);
    }
    return _grayBgView;
}

@end



