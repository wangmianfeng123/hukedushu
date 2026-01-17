

//
//  HKStudyCertificateView.m
//  Code
//
//  Created by Ivan li on 2018/12/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKStudyCertificateView.h"
#import "HKTextImageView.h"
#import "HKCertificateModel.h"


@implementation HKStudyCertificateView


- (void)createUI {
    [super createUI];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    [self.closeViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(PADDING_10);
        make.right.equalTo(self).offset(-PADDING_10);
    }];
    
    [self.headLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(PADDING_20*2);
        make.left.right.equalTo(self);
    }];
    
    [self.honorIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headLB.mas_bottom).offset(45);
        make.centerX.equalTo(self);
        //make.width.lessThanOrEqualTo(self);
        make.size.mas_lessThanOrEqualTo(CGSizeMake(100, 100));
    }];
    
    [self.textImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.honorIV.mas_bottom).offset(PADDING_20);
        make.centerX.equalTo(self);
    }];
    
    [self.introductionLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textImageView.mas_bottom).offset(4);
        make.width.lessThanOrEqualTo(self);
        make.centerX.equalTo(self);
    }];
    
    [self.pushBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-40);
        make.size.mas_equalTo(CGSizeMake(430/2, 75/2));
        make.centerX.equalTo(self);
    }];
    
    // 处理圆角
    dispatch_async(dispatch_get_main_queue(), ^{
        self.pushBtn.clipsToBounds = YES;
        self.pushBtn.layer.cornerRadius = self.pushBtn.height * 0.5;
    });
}




- (void)setModel:(HKCertificateModel *)model {
    
    [self.introductionLB setTextColor:COLOR_27323F];
    [self.introductionLB setFont:HK_FONT_SYSTEM(17)];
    
    self.headLB.text = isEmpty(model.title) ?@""  :model.title;
    self.introductionLB.text = model.achieve_info.condition_description;
    [self.honorIV sd_setImageWithURL:HKURL(model.achieve_info.completed_icon)];
    [self.textImageView setText:model.achieve_info.name url:model.achieve_info.level_icon];
    
    [self.pushBtn setTitle:model.button_info.content forState:UIControlStateNormal];
}



- (void)testVaule {
    
    [self.introductionLB setTextColor:COLOR_27323F];
    [self.introductionLB setFont:HK_FONT_SYSTEM(17)];
    
    self.headLB.text = @"恭喜获得勋章";
    self.introductionLB.text = @"恭喜获得勋章-2";
    self.honorIV.image = imageName(@"ic_study_medall");
    
    self.textImageView.text = @"说到放假啊叟";
}



- (void)injected {
    
}



@end
