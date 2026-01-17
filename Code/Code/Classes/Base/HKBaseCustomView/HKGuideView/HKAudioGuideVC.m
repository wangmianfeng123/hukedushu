//
//  HKAudioGuideVC.m
//  Code
//
//  Created by Ivan li on 2018/3/27.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKAudioGuideVC.h"
#import "AppDelegate.h"
//#import "UIImage+FOFExtension.h"
#import "UIImage+Helper.h"


@interface HKAudioGuideVC ()
/** 背景 */
@property(nonatomic,strong)UIImageView  *ic;

@end

@implementation HKAudioGuideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.rect = frame;
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (instancetype)initWithRect:(CGRect)frame {
    if (self = [super init]) {
    }
    return self;
}


- (void)createUI {
    
    self.view.frame = [UIApplication sharedApplication].keyWindow.bounds;
    self.view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeViewClick)];
    [self.view addGestureRecognizer:tap];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.view.frame];
    // 圆
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(self.rect.origin.x+self.rect.size.width/2, self.rect.origin.y+self.rect.size.height/2-5) radius:35 startAngle:0 endAngle:2*M_PI clockwise:NO]];
    // 矩形    [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.frame.size.width/2.0-1, 234, self.frame.size.width/2.0+1, 55) cornerRadius:5] bezierPathByReversingPath]];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    [self.view.layer setMask:shapeLayer];
    
    
    [self.view addSubview:self.ic];
    [_ic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.rect.origin.y+self.rect.size.height);
        make.left.equalTo(self.view).offset(self.rect.origin.x- (IS_IPHONE5S ?23 :PADDING_15));
    }];
}



- (void)closeViewClick {
    
    [UIView animateWithDuration:1 animations:^{
        self.view.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self performSelector:@selector(removeGuidePage) withObject:nil afterDelay:0.5];
        });
    }];
}


- (void)removeGuidePage {
    //移除手势
    for (UIGestureRecognizer *ges in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:ges];
    }
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}




- (UIImageView*)ic {
    if (!_ic) {
        _ic = [UIImageView new];
        _ic.image = imageName(@"home_audio_tip");
        _ic.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _ic;
}


- (void)dealloc {
    NSLog(@"UIViewContentModeScaleAspectFit");
}




@end








