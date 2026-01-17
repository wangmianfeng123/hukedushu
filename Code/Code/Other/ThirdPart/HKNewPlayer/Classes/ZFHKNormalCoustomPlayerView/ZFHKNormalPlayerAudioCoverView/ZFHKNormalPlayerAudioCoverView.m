

//
//  ZFHKNormalPlayerAudioCoverView.m
//  Code
//
//  Created by Ivan li on 2019/8/4.
//  Copyright © 2019 pg. All rights reserved.
//

#import "ZFHKNormalPlayerAudioCoverView.h"
#import "UIButton+ImageTitleSpace.h"

@implementation ZFHKNormalPlayerAudioCoverView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    self.backgroundColor = [UIColor blackColor];
    
    [self addSubview:self.audioBtn];
    [self addSubview:self.audioIV];
    [self addSubview:self.descrLB];

    self.hidden = YES;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    [self.descrLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(15);
        make.left.right.equalTo(self);
    }];
    
    [self.audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.descrLB.mas_bottom).offset(8);
        make.size.mas_equalTo(CGSizeMake(90, 27));
    }];
    
    [self.audioIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.descrLB.mas_top).offset(-12);
    }];
}



- (UIButton*)audioBtn {
    if (!_audioBtn) {
        _audioBtn = [UIButton buttonWithTitle:@"返回视频" titleColor:[UIColor whiteColor] titleFont:@"14" imageName:nil];
        [_audioBtn addTarget:self action:@selector(audioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_audioBtn setBackgroundColor:[UIColor colorWithHexString:@"#32333D"] forState:UIControlStateNormal];
        [_audioBtn setBackgroundColor:[UIColor colorWithHexString:@"#32333D"] forState:UIControlStateHighlighted];
        _audioBtn.clipsToBounds = YES;
        _audioBtn.layer.cornerRadius = 13.5;
    }
    return _audioBtn;
}


- (UIImageView*)audioIV {
    if (!_audioIV) {
        _audioIV = [UIImageView new];
        _audioIV.image = imageName(@"hkplayer_headset_big_v2_15");
    }
    return _audioIV;
}


- (UILabel *)descrLB {
    if (!_descrLB) {
        _descrLB = [UILabel labelWithTitle:CGRectZero title:@"在锁屏和切到后台时也能继续播放声音" titleColor:[UIColor whiteColor] titleFont:@"13" titleAligment:1];
    }
    return _descrLB;
}



- (void)audioBtnClick:(UIButton*)btn {
    self.hidden = YES;
    if (self.hKNormalPlayerAudioCoverViewCallback) {
        self.hKNormalPlayerAudioCoverViewCallback(self, btn);
    }
}



@end
