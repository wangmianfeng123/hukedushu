//
//  HKStudyTagBottomView.m
//  Code
//
//  Created by Ivan li on 2018/5/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKStudyTagBottomView.h"
#import "UIImage+Helper.h"


@interface HKStudyTagBottomView ()
/** 第一行提示文案 */
@property (strong , nonatomic)UILabel *firstTipLB;
@property (nonatomic,strong) UIButton *okBtn;

@end

@implementation HKStudyTagBottomView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.okBtn];
        [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-20);
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
            make.height.mas_equalTo(50);
        }];
        
        self.backgroundColor = COLOR_FFFFFF_3D4752;
    }
    return self;
}


//- (UILabel*)firstTipLB {
//    if (!_firstTipLB) {
//        _firstTipLB = [UILabel labelWithTitle:CGRectZero title:@"确认后将跳转首页为您开启个性化推荐" titleColor:COLOR_A8ABBE titleFont:nil titleAligment:NSTextAlignmentCenter];
//        _firstTipLB.font = HK_FONT_SYSTEM(12);
//        _firstTipLB.numberOfLines = 2;
//    }
//    return _firstTipLB;
//}



- (UIButton*)okBtn {
    
    if(!_okBtn){
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _okBtn.enabled = NO;
        _okBtn.titleLabel.font = HK_FONT_SYSTEM_WEIGHT(17, UIFontWeightMedium);
        [_okBtn setTitle:@"开启个性化推荐" forState:UIControlStateNormal];
        [_okBtn setTitleColor:COLOR_A8ABBE forState:UIControlStateNormal];
        
        //UIImage  *image = imageName(@"study_tag_start");
        //[_okBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_okBtn setTitleColor:[COLOR_ffffff colorWithAlphaComponent:0.8] forState:UIControlStateSelected];
        [_okBtn addTarget:self action:@selector(oKBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _okBtn.clipsToBounds = YES;
        _okBtn.layer.cornerRadius = 25;
        
        // 按钮渐变背景
        UIColor *color = [UIColor colorWithHexString:@"#EFEFF6"];
        UIColor *color1 = [UIColor colorWithHexString:@"#EFEFF6"];
        UIColor *color2 = [UIColor colorWithHexString:@"#EFEFF6"];
        UIImage *imageTemp = [[UIImage alloc]createImageWithSize:CGSizeMake(SCREEN_WIDTH - 30, 50) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
        [_okBtn setBackgroundImage:imageTemp forState:UIControlStateNormal];
        
    }
    return _okBtn;
}


- (void)oKBtnClick:(id)sender {
    self.okbtnClickBlock ?self.okbtnClickBlock(): nil;
}


- (void)setOkBtnNewBgImage:(UIImage*)image isSelect:(BOOL)isSelect {
    _okBtn.enabled = isSelect;
    [_okBtn setBackgroundImage:image forState:UIControlStateNormal];

    [_okBtn setTitleColor:isSelect ?COLOR_ffffff :COLOR_A8ABBE forState:UIControlStateNormal];
}


@end







