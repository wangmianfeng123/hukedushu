
//
//  HKMyInfoVipView.m
//  Code
//
//  Created by Ivan li on 2018/9/25.
//  Copyright © 2018年 pg. All rights reserved.222222
//

#import "HKMyInfoVipView.h"
#import "UIView+SNFoundation.h"
#import "HKMyInfoUserModel.h"


@implementation HKMyInfoVipView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    //self.layer.cornerRadius = PADDING_10;
    [self addSubview:self.bgIV];
    [self addSubview:self.vipIV];
    [self addSubview:self.vipLB];
    [self addSubview:self.vipInfoLB];
    [self addSubview:self.buyVipBtn];
    [self addSubview:self.lineView];
        
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
    [self addGestureRecognizer:tap];
    [self makeConstraints];
}




- (void)makeConstraints {
    
    [self.bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.buyVipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-18);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vipIV.mas_right).offset(18);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(24);
        make.centerY.equalTo(self);
    }];
}


- (void)remakeConstraints {
    
    if (HKVipType_No == [self.vipModel.vip_class intValue]) {
        self.lineView.hidden = NO;
        [self.vipInfoLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lineView.mas_right).offset(25/2);
            make.centerY.equalTo(self);
            make.right.lessThanOrEqualTo(self.buyVipBtn.mas_left).offset(-1);
            make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH/3+10);
        }];
    }else{
        self.lineView.hidden = YES;
        [self.vipInfoLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.vipIV.mas_right).offset(25/2);
            make.centerY.equalTo(self);
            make.right.lessThanOrEqualTo(self.buyVipBtn.mas_left).offset(-1);
            make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH/3+10);
        }];
    }
    
    if (self.vipLB.text) {
        
        [self.vipIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(PADDING_20);
            make.centerY.equalTo(self.mas_centerY).offset(-10);
            make.size.mas_lessThanOrEqualTo(CGSizeMake(45, 45));
        }];
        
        [self.vipLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.vipIV);
            make.top.equalTo(self.vipIV.mas_bottom).offset(4);
            make.width.mas_lessThanOrEqualTo(50);
        }];
    }else{
        [self.vipIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(PADDING_20);
            //make.centerY.equalTo(self.mas_centerY).offset(-3);
            make.centerY.equalTo(self);
            make.size.mas_lessThanOrEqualTo(CGSizeMake(45, 45));
        }];
    }
}



- (UIButton*)vipIconBtn {
    if (_vipIconBtn) {
        _vipIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _vipIconBtn.userInteractionEnabled = YES;
    }
    return _vipIconBtn;
}


- (UIImageView*)vipIV {
    if (!_vipIV) {
        _vipIV = [UIImageView new];
        _vipIV.contentMode = UIViewContentModeScaleAspectFit;
        _vipIV.userInteractionEnabled = YES;
    }
    return _vipIV;
}


- (UILabel*)vipLB {
    if (!_vipLB) {
        _vipLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_FB9700 titleFont:@"12" titleAligment:NSTextAlignmentCenter];
        _vipLB.userInteractionEnabled = YES;
        _vipLB.font = HK_FONT_SYSTEM_WEIGHT(12, UIFontWeightSemibold);
    }
    return _vipLB;
}


- (UILabel*)vipInfoLB {
    if (!_vipInfoLB) {
        _vipInfoLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_7B8196 titleFont:@"12" titleAligment:NSTextAlignmentLeft];
        _vipInfoLB.userInteractionEnabled = YES;
        _vipInfoLB.numberOfLines = 3;
    }
    return _vipInfoLB;
}


- (UIButton*)buyVipBtn {
    if (!_buyVipBtn) {
        _buyVipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyVipBtn.userInteractionEnabled = NO;
        _buyVipBtn.titleLabel.font = HK_FONT_SYSTEM(13);
    }
    return _buyVipBtn;
}

- (UIImageView *)bgIV {
    if (!_bgIV) {
        _bgIV = [UIImageView new];
        //UIImage *image1 = imageName(@"bg_myself_v2_4");
        //image1 = [image1 resizableImageWithCapInsets:UIEdgeInsetsMake(image1.size.height*0.5, image1.size.width*0.5, image1.size.height*0.5, image1.size.width*0.5)];
        //_bgIV.image = image1;
    }
    return _bgIV;
}

- (UIView*)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [COLOR_FF7820 colorWithAlphaComponent:0.2];
        _lineView.hidden = YES;
    }
    return _lineView;
}


- (void)tapGestureAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(myInfoVipViewClickAction:)]) {
        [self.delegate myInfoVipViewClickAction:sender];
    }
}



- (void)setVipModel:(HKMyInfoVipModel *)vipModel {
    _vipModel = vipModel;
    
    UIImage *image = [self vipImageWithType:vipModel.vip_class];
    self.vipIV.image = image;
    
    [self titleColorWithType:vipModel.vip_class];
    [self vipInfo:vipModel.vip_full_name vipInfo:vipModel.vip_desc vipClass:vipModel.vip_class];
    [self remakeConstraints];
}



- (void)setUserModel:(HKUserModel *)userModel {
    _userModel = userModel;
    
//    UIImage *image = [self vipImageWithType:userModel.vip_class];
//    self.vipIV.image = image;
//
//    [self titleColorWithType:userModel.vip_class];
//    [self vipInfo:userModel.vip_full_name vipInfo:userModel.vip_desc vipClass:userModel.vip_class];
//    [self remakeConstraints];
}



- (void)vipInfo:(NSString *)vipName vipInfo:(NSString *)vipInfo vipClass:(NSString *)vipClass {
    
    NSString *str = nil;
    NSMutableAttributedString *attrString = nil;
    if (isEmpty(vipName)) {
        if (!isEmpty(vipInfo)) {
            str = [NSString stringWithFormat:@"%@",vipInfo];
        }
    }else{
        if (isEmpty(vipInfo)) {
            str = [NSString stringWithFormat:@"%@",vipName];
        }else{
            str = [NSString stringWithFormat:@"%@\n%@",vipName,vipInfo];
        }
    }
            
    switch ([vipClass intValue]) {
        case HKVipType_Expire:
        {
            attrString = [NSMutableAttributedString mutableAttributedString:vipName endString:vipInfo LineSpace:2 color:COLOR_27323F_EFEFF6 endColor:COLOR_7B8196_A8ABBE font:HK_FONT_SYSTEM(13) endFont:HK_FONT_SYSTEM(11)];
        }
            break;
            
        case HKVipType_No:
        {
            attrString = [NSMutableAttributedString mutableAttributedString:str LineSpace:2 color:COLOR_FB9700 font:HK_FONT_SYSTEM(13)];
        }
            break;
            
        case HKVipType_Separator: case HKVipType_OneYear: case HKVipType_WholeLife:
        case HKVipType_Group: case HKVipType_Separator5Days:
        {
            attrString = [NSMutableAttributedString mutableAttributedString:str LineSpace:2 color:COLOR_ffffff font:HK_FONT_SYSTEM_WEIGHT(14, UIFontWeightSemibold)];
        }
            break;
    }
    self.vipInfoLB.attributedText = attrString;
}





/**
 * 购买按钮 文字 和 颜色
 */
- (void)titleColorWithType:(NSString *)type {
    
    NSString *title = self.vipModel.vip_button;
    NSString *vipTag = nil;
    UIColor *color = nil;
    UIImage *image = nil;
    NSMutableAttributedString *attrString = nil;
    
        switch ([type intValue]) {
            case HKVipType_Expire:
            {
                color = [UIColor whiteColor];
                image = imageName(@"bg_vip_renewal");
                attrString = [NSMutableAttributedString mutableAttributedString:[title stringByAppendingString:@"  "] font:HK_FONT_SYSTEM(13) titleColor:color image:nil bounds:CGRectZero];
            }
                break;
                
            case HKVipType_No:
            {
                vipTag = @"VIP中心";
                if (isLogin()) {
                    image = imageName(@"bg_vipopen_signin_v2_6");
                }else{
                    image = imageName(@"bg_vip_open");
                    //color = [UIColor colorWithHexString:@"#8D580C"];
                    //title = isEmpty(title) ?@"开通VIP" :title;
                    //attrString = [NSMutableAttributedString mutableAttributedString:[title stringByAppendingString:@"  "] font:(13) titleColor:color image:[UIImage imageNamed:@"ic_vip_go_yellow"] bounds:CGRectMake(0, 0, 5, 7)];
                }
            }
                break;
                
            case HKVipType_WholeLife:
            {
                color = [UIColor whiteColor];
                attrString = [NSMutableAttributedString mutableAttributedString:[title stringByAppendingString:@"  "] font:HK_FONT_SYSTEM(13) titleColor:color image:[UIImage imageNamed:@"ic_go_v2_7"] bounds:CGRectMake(0, 0, 5, 7)];
            }
                break;
                                
            case HKVipType_OneYear: {
                color = COLOR_FF7820;
                image = imageName(@"bg_btn_vip_v2.18");
                attrString = [NSMutableAttributedString mutableAttributedString:title font:HK_FONT_SYSTEM_WEIGHT(13, UIFontWeightMedium) titleColor:color image:nil bounds:CGRectMake(0, 0, 5, 7) index:0];
                break;
            }
            
            case HKVipType_Separator: case HKVipType_Group: case HKVipType_Separator5Days:
            {
                color = COLOR_3D8BFF;
                image = imageName(@"bg_btn_vip_v2.18");
                attrString = [NSMutableAttributedString mutableAttributedString:title font:HK_FONT_SYSTEM_WEIGHT(13, UIFontWeightMedium) titleColor:color image:nil bounds:CGRectMake(0, 0, 5, 7) index:0];
            }
                break;
        }
    
    self.vipLB.textColor = COLOR_FB9700;
    self.vipLB.text = vipTag;
    [self.buyVipBtn setBackgroundImage:image forState:UIControlStateNormal];
    [self.buyVipBtn setAttributedTitle:attrString forState:UIControlStateNormal];
}





/**
 用户VIP 图片
 
 @param type 5-分类限五vip 4-套餐vip  3-终身全站通  2-全站通VIP  1-分类无限VIP  0-非VIP
 @return
 */
- (UIImage*)vipImageWithType:(NSString *)type {
    UIImage *image = nil;
    switch ([type intValue]) {
            
        case HKVipType_Expire:
            image = imageName(@"ic_vipsmall");
            break;
            
        case HKVipType_No:
            image = imageName(@"ic_vipbig_login");
            break;
            
        case HKVipType_Separator:
            image = imageName(@"ic_vipsort");
            break;
            
        case HKVipType_OneYear:
            image = imageName(@"ic_vipyear");
            break;
            
        case HKVipType_WholeLife:
            image = imageName(@"ic_vipwholelife");
            break;
            
        case HKVipType_Group:
            image = imageName(@"ic_viptaocan");
            break;
            
        case HKVipType_Separator5Days:
            image = imageName(@"ic_vipsort");
            break;
    }
    return  image;
}




@end












