//
//  HKLiveCoverIV.m
//  Code
//
//  Created by Ivan li on 2018/12/6.22
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKLiveCoverIV.h"
#import "HKCustomMarginLabel.h"
#import "UIButton+ImageTitleSpace.h"
#import "HKImageTextIV.h"


@interface HKLiveCoverIV()


@end


@implementation HKLiveCoverIV


- (void)createUI {
    [super createUI];
    [self addSubview:self.animationIV];
    self.textLB.textAlignment = NSTextAlignmentRight;
    [self.imageTextBtn setContentEdgeInsets:UIEdgeInsetsMake(9/2, 12, 9/2, 12)];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.textLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        //make.left.right.bottom.equalTo(self);
        make.right.bottom.equalTo(self);
        make.height.mas_equalTo(35);
    }];
    
    [self.imageTextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self).mas_offset(-5);
    }];
    
    [self.animationIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self).mas_offset(-5);
    }];
    
    [self.serLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(35);
        make.right.lessThanOrEqualTo(self.textLB.mas_left);
    }];
}



- (HKImageTextIV*)animationIV {
    if (!_animationIV) {
        _animationIV = [[HKImageTextIV alloc]init];
        _animationIV.liveAnimationType = HKLiveAnimationType_liveList;
    }
    return _animationIV;
}


- (void)setStatus:(NSString *)status {
    _status = status;
    self.textLB.hidden = isEmpty(status)? YES : NO;
    self.textLB.text = status;
}



- (void)setLiveType:(HKLiveType)liveType {
    _liveType = liveType;
    [self titleWithType:self.liveType];
}



/** 直播标签---标题 */
- (NSString*)titleWithType:(HKLiveType)type {
    
    NSString *text = nil;
    switch (type) {
        case HKLiveTypeEnrolment:
        {
            text = @"火热报名中";
            [self.imageTextBtn setImage:imageName(@"ic_hot_v2_7") forState:UIControlStateNormal];
            [self.imageTextBtn setTitle:text forState:UIControlStateNormal];
            [self.imageTextBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
            self.animationIV.isAnimation = NO;
            self.hasPictext = NO;
        }
            break;
            
        case HKLiveTypeWaiting:
        {
            text = @"即将开始";
            [self.imageTextBtn setImage:nil forState:UIControlStateNormal];
            [self.imageTextBtn setTitle:text forState:UIControlStateNormal];
            [self.imageTextBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:0];
            self.animationIV.isAnimation = NO;
            self.hasPictext = NO;
        }
            break;
            
        case HKLiveTypePlaying:
            self.hasPictext = YES;
            self.animationIV.isAnimation = YES;
            break;
            
        default:
            self.animationIV.isAnimation = NO;
            self.hasPictext = YES;
            break;
    }
    return text;
}




@end
