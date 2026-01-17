//
//  GKWYDiskView.m
//  GKAudioPlayerDemo
//
//  Created by QuintGao on 2017/10/9.
//  Copyright © 2017年 高坤. All rights reserved.
//

#import "GKWYDiskView.h"


@interface GKWYDiskView()

//@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation GKWYDiskView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        CGFloat imgWH = SCREEN_WIDTH - 68.5*2;
        [self addSubview:self.diskImgView];
        
        [self.diskImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(66+6.5);
            make.width.height.mas_equalTo(imgWH);
        }];
        
        self.diskImgView.layer.cornerRadius = imgWH * 0.5;
        self.diskImgView.layer.masksToBounds = YES;
        
        
//        [self addSubview:self.diskImgView];
//        [self.diskImgView addSubview:self.imgView];
//
//        [self.diskImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self);
//            make.top.equalTo(self).offset(66);
//            make.width.height.mas_equalTo(SCREEN_WIDTH - 80);
//        }];
//
//        CGFloat imgWH = SCREEN_WIDTH - 80 - 100;
//
//        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self.diskImgView);
//            make.width.height.mas_equalTo(imgWH);
//        }];
//        self.imgView.layer.cornerRadius  = imgWH * 0.5;
//        self.imgView.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setImgurl:(NSString *)imgurl {
    _imgurl = imgurl;
    [self.diskImgView sd_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:imageName(HK_Placeholder)];
}

- (UIImageView *)diskImgView {
    if (!_diskImgView) {
        _diskImgView = [UIImageView new];
        //_diskImgView.image = [UIImage imageNamed:@"cm2_play_disc-ip6"];
    }
    return _diskImgView;
}

//- (UIImageView *)imgView {
//    if (!_imgView) {
//        _imgView = [UIImageView new];
//        //_imgView.contentMode = UIViewContentModeScaleAspectFill;
//    }
//    return _imgView;
//}


//- (void)setImgurl:(NSString *)imgurl {
//    _imgurl = imgurl;
//    if (imgurl) {
//        [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:imageName(HK_Placeholder)];
//    }else {
//        self.imgView.image = nil;
//    }
//}

@end
