//
//  HKWindowBooKView.m
//  Code
//
//  Created by Ivan li on 2019/7/19.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKWindowBooKView.h"

@implementation HKWindowBooKView

- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    
    [self addSubview:self.bgIV];
    [self addSubview:self.coverBgIV];
    [self addSubview:self.coverIV];
    [self addSubview:self.coloseBtn];
    [self addSubview:self.playOrPauseBtn];
    
    [self addSubview:self.rightLineView];
    [self addSubview:self.leftLineView];
    
    [self.bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(8);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    [self.coverBgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.coverIV);
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.top.equalTo(self.coverIV).offset(7);
    }];
    
    [self.playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.coverIV);
        make.left.equalTo(self.coverIV.mas_right).offset(16);
    }];
    
    [self.coloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playOrPauseBtn.mas_right).offset(16);
        make.centerY.equalTo(self.coverIV);
    }];
    
    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.coverIV);
        make.left.equalTo(self.coverIV.mas_right).offset(8);
        make.size.mas_equalTo(CGSizeMake(1, 16));
    }];
    
    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.coverIV);
        make.left.equalTo(self.playOrPauseBtn.mas_right).offset(8);
        make.size.mas_equalTo(CGSizeMake(1, 16));
    }];
}



- (UIImageView*)bgIV {
    if (!_bgIV) {
        _bgIV = [UIImageView new];
        UIImage *image = [UIImage hkdm_imageWithNameLight:@"bg_big_floating_v2_16" darkImageName:@"bg_big_floating_v2_16_dark"];
        _bgIV.image = image;
    }
    return _bgIV;
}


- (UIImageView*)coverBgIV {
    if (!_coverBgIV) {
        _coverBgIV = [UIImageView new];
        _coverBgIV.image = imageName(@"bg_cover_shadow_v2_14");
        _coverBgIV.contentMode = UIViewContentModeScaleAspectFill;
        //_coverBgIV.userInteractionEnabled = YES;
        _coverBgIV.hidden = YES;
    }
    return _coverBgIV;
}


- (UIImageView*)coverIV {
    if (!_coverIV) {
        _coverIV = [UIImageView new];
        _coverIV.clipsToBounds = YES;
        _coverIV.layer.cornerRadius = 5;
        _coverIV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coverIVClick)];
        [_coverIV addGestureRecognizer:tap];
    }
    return _coverIV;
}



- (UIButton*)coloseBtn {
    if (!_coloseBtn) {
        _coloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage hkdm_imageWithNameLight:@"ic_delect_v2_16" darkImageName:@"ic_delect_v2_16_dark"];
        [_coloseBtn setImage:image forState:UIControlStateNormal];
        [_coloseBtn setImage:image forState:UIControlStateHighlighted];
        [_coloseBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_coloseBtn setHKEnlargeEdge:10];
        _coloseBtn.hidden = YES;
    }
    return _coloseBtn;
}


- (UIButton *)playOrPauseBtn {
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *normalImage = [UIImage hkdm_imageWithNameLight:@"ic_start_v2_16" darkImageName:@"ic_start_v2_16_dark"];
        UIImage *selectImage = [UIImage hkdm_imageWithNameLight:@"ic_stop_v2_16" darkImageName:@"ic_stop_v2_16_dark"];
        
        [_playOrPauseBtn setImage:normalImage forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:selectImage forState:UIControlStateSelected];
        [_playOrPauseBtn addTarget:self action:@selector(playOrPauseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_playOrPauseBtn setHKEnlargeEdge:10];
    }
    return _playOrPauseBtn;
}



- (UIView*)leftLineView {
    if (!_leftLineView) {
        _leftLineView = [UIView new];
        _leftLineView.backgroundColor = COLOR_F8F9FA_333D48;
    }
    return _leftLineView;
}


- (UIView*)rightLineView {
    if (!_rightLineView) {
        _rightLineView = [UIView new];
        _rightLineView.backgroundColor = COLOR_F8F9FA_333D48;
        //_rightLineView.hidden = YES;
    }
    return _rightLineView;
}


- (void)playOrPauseBtnClick:(UIButton*)btn {
    btn.selected = !btn.selected;
    if (self.player.isPlaying) {
        [self.player pause];
    }else{
        [self.player play];
    }
    [MobClick event:UM_RECORD_AUDIO_FLOATINGWINDOW_PAUSE];
}

- (void)closeBtnClick {
    [HKBookPlayer pauseReadBooK];
    if (self.hkWindowBooKViewCloseBtnClickCallBack) {
        self.hkWindowBooKViewCloseBtnClickCallBack();
        [self removeFromSuperview];        
    }
}



- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [self.coverIV sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:imageUrl]) placeholderImage:HK_PlaceholderImage];
}



- (void)setPlayer:(GKPlayer *)player {
    if (!_player) {
        _player = player;
        
        [self chageViewWidth:player.isPlaying];
        [self.player addObserver:self forKeyPath:@"isPlaying" options:NSKeyValueObservingOptionNew context:nil];
    }
}


/** 回调方法    */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    // 在这个方法里面监听属性变化
    if ([keyPath isEqualToString:@"isPlaying"]) {
        id newValue = [change valueForKey:NSKeyValueChangeNewKey];
        
        [self chageViewWidth:[newValue boolValue]];
    }
}



- (void)coverIVClick {
    if (self.hkWindowBooKViewBgIVClickCallBack) {
        self.hkWindowBooKViewBgIVClickCallBack();
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

}


- (void)chageViewWidth:(BOOL)isPlaying {
    
    if (isPlaying) {
        self.width = 95; // 190 148
        self.rightLineView.hidden = YES;
        self.coloseBtn.hidden = YES;
    }else{
        self.width = 133; // 254 148
        self.rightLineView.hidden = NO;
        self.coloseBtn.hidden = NO;
    }
    
    self.playOrPauseBtn.selected = isPlaying;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}



- (void)dealloc {
    
    if ([self.player observationInfo]) {
        [self.player removeObserver:self forKeyPath:@"isPlaying" context:nil];
    }
}


@end
