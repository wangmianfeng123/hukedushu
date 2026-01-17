//
//  HKFullScreenAdView.m
//  Code
//
//  Created by Ivan li on 2018/1/28.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKFullScreenAdView.h"
#import "SDWebImageManager.h"
#import "UIImage+Helper.h"


@interface HKFullScreenAdView ()

@property (nonatomic, strong) UIButton *skipButton;         //跳过按钮
@property (nonatomic, strong) dispatch_source_t timer;      //显示计时器
@property (nonatomic, strong) dispatch_source_t timerWait;  //等待计时器
@property (nonatomic, assign) BOOL flag;                    //是否将要消失
@property (nonatomic, strong) UIView *timerView;
@property (nonatomic, weak) CAShapeLayer *viewLayer;
@property (nonatomic, assign) NSInteger remain;             //剩余时间
@property (nonatomic, assign) NSInteger count;
@property (nonatomic , assign) BOOL isActivity ;//点击了广告
@property (nonatomic , strong) UILabel * adLabel;
@property (nonatomic , strong) UIButton * jumpBtn;

@end

@implementation HKFullScreenAdView

- (instancetype)init {
    if (self = [super init]) {
        [self configDefaultParameter];
    }
    return self;
}

- (UIButton *)skipButton {
    if (!_skipButton) {
        _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipButton.frame = CGRectMake(SCREEN_WIDTH - 80, 30, 70, 27);//CGRectMake(SCREEN_WIDTH - 70, 30, 60, 30);
        _skipButton.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.4];
        _skipButton.layer.cornerRadius = 27/2;
        _skipButton.layer.masksToBounds = YES;
        _skipButton.titleLabel.font = HK_FONT_SYSTEM(11);
        [_skipButton addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipButton;
}

- (UILabel*)adLabel {
    if (!_adLabel) {
        _adLabel  = [[UILabel alloc] init];
        [_adLabel setTextColor:[UIColor whiteColor]];
        _adLabel.textAlignment = NSTextAlignmentCenter;
        _adLabel.font = [UIFont systemFontOfSize:11];//[UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14: 13 weight:<#UIFontWeightMedium];
        _adLabel.text = @"广告";
        _adLabel.layer.cornerRadius = 4;
        _adLabel.layer.masksToBounds = YES;
        _adLabel.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.4];
    }
    return _adLabel;
}

- (UIButton*)jumpBtn {
    if (!_jumpBtn) {
        _jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _jumpBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _jumpBtn.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.4];
        [_jumpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_jumpBtn setTitle:@"点击跳转至活动详情页" forState:UIControlStateNormal];
        [_jumpBtn addTarget:self action:@selector(jumpClick) forControlEvents:UIControlEventTouchUpInside];
        [_jumpBtn setImage:[UIImage imageNamed:@"ic_go_ad_2_37"] forState:UIControlStateNormal];
        _jumpBtn.layer.cornerRadius = 25;
        _jumpBtn.layer.masksToBounds = YES;
        [_jumpBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleRight imageTitleSpace:10];
    }
    return _jumpBtn;
}

- (void)jumpClick{
    [self tapAction];
}

- (void)setDuration:(NSUInteger)duration {
    _duration = duration;
    if (duration < 3) {
        _duration = 3;
    }
}

- (void)setWaitTime:(NSUInteger)waitTime {
    _waitTime = waitTime;
//    if (waitTime < 1) {
//        _waitTime = 1;
//    }
    // 启动等待计时器
    [self scheduledWaitTimer];
}

- (UIView *)timerView {
    if (!_timerView) {
        self.timerView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 62, 32, 65, 23)]; //130 44
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.fillColor = [COLOR_000000 colorWithAlphaComponent:0.4].CGColor;    // 填充颜色
        layer.strokeColor = [UIColor redColor].CGColor;                                 // 绘制颜色
        layer.lineCap = kCALineCapRound;
        layer.lineJoin = kCALineJoinRound;
        layer.lineWidth = 2;
        layer.frame = self.bounds;
        layer.path = [self getCirclePath].CGPath;
        layer.strokeStart = 0;
        [_timerView.layer addSublayer:layer];
        self.viewLayer = layer;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 3, 34, 34)];
        titleLabel.text = @"跳过";
        titleLabel.textColor = [UIColor whiteColor];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        titleLabel.font = HK_FONT_SYSTEM(11);
        [_timerView addSubview:titleLabel];
        _remain = _duration * 20;
        _count = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skipAction)];
        [_timerView addGestureRecognizer:tap];
    }
    return _timerView;
}



/** 配置默认参数 */
- (void)configDefaultParameter {
    self.flag = NO;
    self.duration = 5;
    self.skipType = SkipButtonTypeNormalTimeAndText;
    
    self.frame = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.adIV];
    [self.adIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}



- (UIImageView*)adIV {
    if (!_adIV) {
        _adIV = [UIImageView new];
        _adIV.backgroundColor = [UIColor whiteColor];
        _adIV.userInteractionEnabled = YES;
        _adIV.contentMode = IS_IPAD ? UIViewContentModeScaleAspectFit : UIViewContentModeScaleAspectFill;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
//        tap.numberOfTapsRequired = 1;
//        tap.numberOfTouchesRequired  = 1;
//        tap.delaysTouchesBegan = YES;
//        tap.delaysTouchesEnded = YES;
//        [_adIV addGestureRecognizer:tap];
    }
    return _adIV;
}




/** 获取启动图片 */
+ (UIImage *)getLaunchImage {
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = nil;
    if (IS_IPAD) {
         viewOrientation = @"Landscape";// 横屏请设置成 @"Landscape"
        viewSize = CGSizeMake(viewSize.height, viewSize.width);
    }else{
        viewOrientation = @"Portrait";// 横屏请设置成 @"Landscape"
    }
    UIImage *lauchImage = nil;
    NSArray *imagesDictionary = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDictionary) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            lauchImage = [UIImage imageNamed:dict[@"UILaunchImageName"]];
        }
    }
    
    lauchImage = [UIImage imageNamed:@"deaunch"];
    
    return lauchImage;
}



/* 绘制路径
 * path这个属性必须需要设置，不然是没有效果的/
 */
- (UIBezierPath *)getCirclePath {
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(20, 20) radius:19 startAngle:-0.5*M_PI endAngle:1.5*M_PI clockwise:YES];
}





/** 获取广告图 */
- (void)reloadAdImageWithUrl:(NSString *)urlStr {
    if (urlStr.length <= 0) {
        if (_timerWait) dispatch_source_cancel(_timerWait);
        [self removeFromSuperview];
        return;
    }
    
    NSURL *imageUrl = [NSURL URLWithString:urlStr];
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlStr];
    if (cacheImage) {
        
        [self adImageShowWithImage:cacheImage];
    } else {
        
        [[SDWebImageManager sharedManager] loadImageWithURL:imageUrl options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            
            UIImage *temp = image;
            if (IS_IPHONE_X) {
                //CGFloat b = self.safeAreaInsets.bottom;
                temp = [UIImage thumbnailWithImageWithoutScale:image size:CGSizeMake(self.width*2, self.height*2)];
            }
            if (image && finished && error == nil) {
                [[SDImageCache sharedImageCache] storeImage:temp forKey:urlStr toDisk:YES completion:^{
                    
                }];
            }
            [self adImageShowWithImage:temp];
        }];
    }
}




/** 显示广告图 */
- (void)adImageShowWithImage:(UIImage *)image {
    
    if (nil == image) {
        [self stopTimerAndDismiss];
        return;
    }
    if (_flag) return;
    if (_timerWait) dispatch_source_cancel(_timerWait);
    self.adIV.image = image;
    self.userInteractionEnabled = YES;
    if (_skipType == SkipButtonTypeCircleAnimationTest) {
        [self addSubview:self.timerView];
        [self setCircleTimer];
    } else {
        [self addSubview:self.skipButton];
        [self addSubview:self.adLabel];
        [self addSubview:self.jumpBtn];
        [self scheduledTimer];
    }
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
//    [self addGestureRecognizer:tap];
    CATransition *animation = [CATransition animation];
    animation.duration = 0.2;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionFade;
    [self.layer addAnimation:animation forKey:@"animation"];
    [self.adLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.skipButton);
        make.left.equalTo(self.adIV).offset(15);
        make.size.mas_equalTo(CGSizeMake(36, 18));
    }];
    [self.jumpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(250, 50));
        CGFloat margin = IS_IPHONE_X ? -142 : -110;
        make.bottom.equalTo(self).offset(margin);
    }];
}

/** 广告图显示倒计时 */
- (void)setCircleTimer {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 0.05 * NSEC_PER_SEC, 0); // 每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_count >= _remain) {
                dispatch_source_cancel(_timer);
                self.viewLayer.strokeStart = 1;
                [self dismiss];
            } else {
                self.viewLayer.strokeStart += 0.01;
                _count++;                               //剩余时间进行自加
            }
        });
    });
    dispatch_resume(_timer);
}


/** 广告图显示倒计时 */
- (void)scheduledTimer {
    if (_timerWait) dispatch_source_cancel(_timerWait);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); // 每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_duration <= 0) {
                NSLog(@"_duration ==== %lu",(unsigned long)_duration);
                dispatch_source_cancel(_timer);
                [self dismiss];                         // 关闭界面
            } else {
                [self showSkipBtnTitleTime:_duration];
                _duration--;
            }
        });
    });
    dispatch_resume(_timer);
}




/** 广告图加载前等待计时器 */
- (void)scheduledWaitTimer {
    if (_timerWait) dispatch_source_cancel(_timerWait);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timerWait = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timerWait, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(_timerWait, ^{
        if (_waitTime <= 0) {
            _flag = YES;
            dispatch_source_cancel(_timerWait);
            dispatch_async(dispatch_get_main_queue(), ^{
                // 关闭界面
                [self dismiss];
            });
        } else {
            _waitTime--;
        }
    });
    dispatch_resume(_timerWait);
}


/** 停止定时器 并立即销毁 view */
- (void)stopTimerAndDismiss {
    if (_timerWait) dispatch_source_cancel(_timerWait);
    [self invalidateTimer];
    [self dismiss];
}


/** 消失广告图 */
- (void)dismiss {
    /* 反转动画
    [UIView transitionWithView:self.superview duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hkAdViewDismissBlock ? self.hkAdViewDismissBlock(nil) : nil;
        [self removeFromSuperview];
    }];
    */
    

    self.hkAdViewDismissBlock ? self.hkAdViewDismissBlock(self.isActivity) : nil;
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        //self.transform = CGAffineTransformMakeScale(0.8, 1.2);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}



/** 设置跳过按钮 */
- (void)showSkipBtnTitleTime:(NSInteger)timeLeave {
    switch (_skipType) {
        case SkipButtonTypeNormalTimeAndText:
            [self.skipButton setTitle:[NSString stringWithFormat:@"%lds | 跳过", (long)timeLeave] forState:UIControlStateNormal];
            break;
        case SkipButtonTypeNormalText:
            [self.skipButton setTitle:@"跳过" forState:UIControlStateNormal];
            break;
        case SkipButtonTypeNormalTime:
            [self.skipButton setTitle:[NSString stringWithFormat:@"%ld S", (long)timeLeave] forState:UIControlStateNormal];
            break;
        case SkipButtonTypeNone:
            self.skipButton.hidden = YES;
            break;
        default:
            break;
    }
}

#pragma mark - Action Method -

/** 广告图点击相应方法 */
- (void)tapAction {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.adIV.userInteractionEnabled = YES;
    });
    self.adIV.userInteractionEnabled = NO;
    
    [MobClick event:UM_RECORD_AD_OPENING_PAGE];
    [self invalidateTimer];
    self.adImageTapBlock ?self.adImageTapBlock(@"广告图点击事件") :nil;
    self.isActivity = YES;
    [self dismiss];
}


/** 跳过按钮响应方法 */
- (void)skipAction {
    [self invalidateTimer];
    [self dismiss];
}


/** 销毁定时器 */
- (void)invalidateTimer {
    if (_timer) dispatch_source_cancel(_timer);
}


- (void)dealloc {
    [self invalidateTimer];
}




@end
