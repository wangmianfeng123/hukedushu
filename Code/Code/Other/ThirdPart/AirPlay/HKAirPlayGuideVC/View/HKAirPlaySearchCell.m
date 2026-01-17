//
//  HKAirPlaySearchCell.m
//  Code
//
//  Created by Ivan li on 2019/5/7.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKAirPlaySearchCell.h"
#import "UIButton+ImageTitleSpace.h"


@interface HKAirPlaySearchCell()


@property (nonatomic,strong) UIImageView* iconIV;

@property (nonatomic,strong) UIButton *repeatBtn;

@property (nonatomic,strong)CABasicAnimation *animation;

@property (nonatomic,strong) UIView *line;


@end



@implementation HKAirPlaySearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.repeatBtn];
        [self.contentView addSubview:self.line];
        
        [self.contentView addSubview:self.titleLb];
        
        [self.repeatBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:6];
        
        [self.repeatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
        
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.contentView);
            make.height.mas_equalTo(0.8);
        }];
    }
    return self;
}


- (UILabel*)titleLb {
    if (!_titleLb) {
        _titleLb = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F_EFEFF6 titleFont:@"14" titleAligment:NSTextAlignmentLeft];
        _titleLb.font = HK_FONT_SYSTEM_WEIGHT(14, UIFontWeightMedium);
        _titleLb.hidden = YES;
    }
    return _titleLb;
}


- (UIImageView*)iconIV {
    if (!_iconIV) {
        _iconIV = [UIImageView new];
        _iconIV.image = imageName(@"ic_refresh_small_v2_12");
    }
    return _iconIV;
}

- (CABasicAnimation*) animation {
    if (!_animation) {
        _animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
        _animation.fromValue = [NSNumber numberWithFloat:0.f];
        _animation.toValue = [NSNumber numberWithFloat: M_PI *2];
        _animation.duration = 1;
        _animation.fillMode = kCAFillModeForwards;
        _animation.repeatCount = MAXFLOAT;
    }
    return _animation;
}

//- (void)startAnimation {
//     CGAffineTransform endAngle = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
//
//     [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//            self.scanImage.transform = endAngle;
//        } completion:^(BOOL finished) {
//                angle += 2; [self startAnimation];
//        }];
// }



- (void)startAnimations {
    [self.repeatBtn.imageView.layer addAnimation:self.animation forKey:@"rotationAnimation"];
}


- (void)removeAnimations {
    [self.iconIV.layer removeAllAnimations];
}



- (UIButton *)repeatBtn {
    if (!_repeatBtn) {
        _repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_repeatBtn setImage:imageName(@"ic_refresh_small_v2_12") forState:UIControlStateNormal];
        [_repeatBtn setImage:imageName(@"ic_refresh_small_v2_12") forState:UIControlStateHighlighted];
        [_repeatBtn setTitle:@"正在搜索设备" forState:UIControlStateNormal];
        _repeatBtn.titleLabel.font = HK_FONT_SYSTEM(14);
        [_repeatBtn setTitleColor:COLOR_7B8196_A8ABBE forState:UIControlStateNormal];
        [_repeatBtn setTitleColor:COLOR_7B8196_A8ABBE forState:UIControlStateHighlighted];
    }
    return _repeatBtn;
}

- (UIView*)line {
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = COLOR_F8F9FA_333D48;
    }
    return _line;
}



@end
