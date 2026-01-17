//
//  HKTakeGifView.m
//  Code
//
//  Created by Ivan li on 2021/5/19.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKTakeGifView.h"
#import "HKTrainModel.h"
#import "UIView+HKLayer.h"

@interface HKTakeGifView ()<UIGestureRecognizerDelegate>
@property (nonatomic , strong) NSMutableArray * liveArray;
@end

@implementation HKTakeGifView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    [self addSubview:self.contentView];
    
    UIImageView * upImg =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_toast_gift_2_34"]];
    upImg.size = CGSizeMake(7, 7);
    upImg.hidden = NO;
    [self addSubview:upImg];
    self.upImg = upImg;
    
    
    
    UIImageView * downImg =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_toast_giftdown_2_34"]];
    downImg.size = CGSizeMake(7, 7);
    downImg.hidden = NO;
    [self addSubview:downImg];
    self.downImg = downImg;
    
    
    UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
    tapGes.delegate = self;
    [self addGestureRecognizer:tapGes];
}

- (void)closeView{
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        [_contentView addCornerRadius:5];
    }
    return _contentView;
}


- (void)createWithVIPArray:(NSMutableArray *)vipArray liveArray:(NSMutableArray *)liveArray{
    _liveArray = liveArray;
    self.contentView.size = CGSizeMake(220, (vipArray.count + liveArray.count) * 30 + 16);

    UIView * vipView = nil ;
    if (vipArray.count) {
        vipView = [self createSubViewHKTrainModel:vipArray[0] withIndex:0 isVIP:YES];
        vipView.frame = CGRectMake(0, 8, self.contentView.width, 30);
        [self.contentView addSubview:vipView];
    }
    
    
    if (liveArray.count) {
        CGFloat y = vipArray.count ? CGRectGetMaxY(vipView.frame) : 8;

        for (int i= 0 ; i < liveArray.count; i++) {
            UIView * liveView = [self createSubViewHKTrainModel:liveArray[i] withIndex:i isVIP:NO];
            
            liveView.frame = CGRectMake(0, y + i * 30, self.contentView.width, 30);
            //liveView.backgroundColor = [UIColor brownColor];
            [self.contentView addSubview:liveView];
        }
    }
    
    self.contentView.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT *0.5);
}

- (UIView *)createSubViewHKTrainModel:(HKTrainModel *)model withIndex:(int)index isVIP:(BOOL)vip{
    UIView * subView = [UIView new];
    UILabel * signLabel = [UILabel labelWithTitle:CGRectMake(10, 5, 50, 20) title:vip?@"会员":@"课程" titleColor:COLOR_A8ABBE_7B8196 titleFont:@"13" titleAligment:NSTextAlignmentCenter];
    signLabel.backgroundColor = COLOR_EFEFF6;
//    signLabel.font = [UIFont systemFontOfSize:12];
    [signLabel addCornerRadius:10];
    [subView addSubview:signLabel];
    signLabel.hidden  = index ? YES :NO;
    
    UILabel * rightLabel = [UILabel labelWithTitle:CGRectMake(70, 5, self.contentView.width-60-20, 20) title:model.name titleColor:COLOR_3D8BFF titleFont:@"13" titleAligment:NSTextAlignmentLeft];
    rightLabel.textColor = vip ? COLOR_7B8196 : COLOR_3D8BFF;
    rightLabel.userInteractionEnabled = YES;
//    rightLabel.font = [UIFont systemFontOfSize:12];
    rightLabel.tag = index;
    [subView addSubview:rightLabel];
    if (!vip) {
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [rightLabel addGestureRecognizer:tap];
    }
    
    return subView;
}

- (void)tapClick:(UITapGestureRecognizer *)tap{
    [self closeView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.didCourseBlock) {
            int index = (int)tap.view.tag;
            self.didCourseBlock(self.liveArray[index]);
        }
    });
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.upImg.centerX = self.contentView.centerX;
    self.upImg.centerY =  self.contentView.centerY - self.contentView.height * 0.5 - 3.5;
    
    self.downImg.centerX = self.contentView.centerX;
    self.downImg.centerY =  self.contentView.centerY + self.contentView.height * 0.5 + 3.5;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.contentView]) {
        return NO;
    }else{
        return YES;
    }
}

- (void)showWithPoint:(CGPoint)point{
    CGFloat h = SCREEN_HEIGHT- point.y;
    if (h > self.contentView.height + 5) {
        self.upImg.hidden = NO;
        self.downImg.hidden = YES;
        self.contentView.y = point.y + 20;

    }else{
        self.upImg.hidden = YES;
        self.downImg.hidden = NO;
        self.contentView.y = point.y - 20 - self.contentView.height;
    }
    
    self.contentView.centerX = point.x;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

@end
