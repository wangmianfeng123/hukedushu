//
//  HKLivingSpeedLoadingView.m
//  Pods-ZFPlayer_Example
//
//  Created by 紫枫 on 2018/6/27.
//

#import "HKLivingSpeedLoadingView.h"
#import "ZFHKNormalNetworkSpeedMonitor.h"
#import "UIView+ZFHKNormalFrame.h"


@interface HKLivingSpeedLoadingView ()

@property (nonatomic, strong) ZFHKNormalNetworkSpeedMonitor *speedMonitor;

// 正在加载
@property (nonatomic, strong)LOTAnimationView *animation;
@property (nonatomic, strong) UIView *loadingAnimationView;

@end

@implementation HKLivingSpeedLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (void)initialize {
    self.userInteractionEnabled = NO;
//    [self addSubview:self.loadingView];
    [self addSubview:self.speedTextLabel];
    [self addSubview:self.loadingAnimationView];
    [self.loadingAnimationView addSubview:self.animation];
    
    [self.speedMonitor startNetworkSpeedMonitor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkSpeedChanged:) name:ZFHKNormalDownloadNetworkSpeedNotificationKey object:nil];

}

- (void)dealloc {
    [self.speedMonitor stopNetworkSpeedMonitor];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZFHKNormalDownloadNetworkSpeedNotificationKey object:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.width;
    CGFloat min_view_h = self.height;
    
    min_w = min_view_w;
    min_h = min_view_h;
    
    min_w = 44;
    min_h = min_w;
    min_x = (min_view_w - min_w) / 2;
    min_y = (min_view_h - min_h) / 2 - 10;
    self.loadingView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 0;
    min_y = self.loadingView.zf_bottom+5;
    min_w = min_view_w;
    min_h = 20;
    self.speedTextLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    self.loadingAnimationView.frame = CGRectMake((min_view_w - 58)*0.5 , (min_view_h - 47) * 0.5, 58, 47);
    self.speedTextLabel.y = CGRectGetMaxY(self.loadingAnimationView.frame) + 5;
}

- (void)networkSpeedChanged:(NSNotification *)sender {
    NSString *downloadSpped = [sender.userInfo objectForKey:ZFHKNormalNetworkSpeedNotificationKey];
    //self.speedTextLabel.text = downloadSpped;
}

- (void)startAnimating {
    [self.loadingView startAnimating];
    self.hidden = NO;
    [self.animation play];
}

- (void)stopAnimating {
    [self.loadingView stopAnimating];
    self.hidden = YES;
    [self.animation pause];
}

- (UILabel *)speedTextLabel {
    if (!_speedTextLabel) {
        _speedTextLabel = [UILabel new];
        _speedTextLabel.textColor = [UIColor whiteColor];
        _speedTextLabel.font = [UIFont systemFontOfSize:12.0];
        _speedTextLabel.textAlignment = NSTextAlignmentCenter;
        _speedTextLabel.text = @"拼命加载中..";
    }
    return _speedTextLabel;
}

- (ZFHKNormalNetworkSpeedMonitor *)speedMonitor {
    if (!_speedMonitor) {
        _speedMonitor = [[ZFHKNormalNetworkSpeedMonitor alloc] init];
    }
    return _speedMonitor;
}

- (ZFLoadingView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[ZFLoadingView alloc] init];
        _loadingView.lineWidth = 0.8;
        _loadingView.duration = 1;
        _loadingView.hidesWhenStopped = YES;
    }
    return _loadingView;
}

- (LOTAnimationView *)animation {
    if (!_animation) {
        _animation = [LOTAnimationView animationNamed:@"playerWait.json"];
        _animation.loopAnimation = YES;
//        [_animation playWithCompletion:^(BOOL animationFinished) {
//
//        }];
        _animation.size = CGSizeMake(58, 47);
    }
    return _animation;
}

- (UIView *)loadingAnimationView {
    if (_loadingAnimationView == nil) {
        _loadingAnimationView = [[UIView alloc] init];
//        _loadingAnimationView.backgroundColor = [UIColor whiteColor];
    }
    return _loadingAnimationView;
}

@end

