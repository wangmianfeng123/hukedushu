

//
//  MyInfoHeadCell.m
//  Code
//
//  Created by Ivan li on 2018/9/23.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "MyInfoHeadCell.h"
#import "UIButton+WebCache.h"
#import "HKLeftRightBtn.h"
#import "MyInfoViewController.h"
#import "HKMyInfoVipView.h"
#import "UIButton+ImageTitleSpace.h"
#import "HKMyInfoUserModel.h"
#import "UIImage+Extension.h"


#define HUKE_ICON  @"huke_login_bg"


@interface MyInfoHeadCell()<HKMyInfoVipViewDelegate>

@property (nonatomic, strong)UIImageView *editIV;

@property (nonatomic, copy)NSString *iconUrl;

@property (nonatomic, strong)UIImageView *vipViewBgShadowView;
/** vip 图标 */
@property(nonatomic,strong)UIImageView  *nickNameVipIV;

@end




@implementation MyInfoHeadCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
        [self makeConstraints];
        [self userInfoObserver];
    }
    return self;
}


#pragma mark - 观察用户VIP 登录状态变化
- (void)userInfoObserver {
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signStatusChange:) name:@"HKSignStatusChange" object:nil];
}



- (void)createUI {
    
    [self.contentView addSubview:self.bgIV];
    [self.contentView addSubview:self.iconIV];
    [self.contentView addSubview:self.nickNameLabel];
    [self.contentView addSubview:self.carIdLabel];
    
    [self.contentView addSubview:self.presentBtn];
    
    [self.contentView addSubview:self.vipViewBgShadowView];
    
    [self.contentView addSubview:self.vipView];
    [self.contentView addSubview:self.editIV];
    
    [self.contentView addSubview:self.nickNameVipIV];
    [self hkDarkModel];
}

- (void)hkDarkModel {
    self.nickNameLabel.textColor = COLOR_27323F_EFEFF6;
}

- (void)makeConstraints {
    
    [self.bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo((IS_IPHONE_X ?24 :0) +230);
    }];
    
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgIV).offset(PADDING_15);
        //make.top.equalTo(self.bgIV).offset(60 + (IS_IPHONE_X ?24 :0));
        make.top.equalTo(self.bgIV).offset(70 + (IS_IPHONE_X ?24 :0));
        //make.size.mas_equalTo((IS_IPHONE6PLUS ||IS_IPHONE_X) ?CGSizeMake(75, 75): CGSizeMake(70, 70));
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];
    
    [self.contentView bringSubviewToFront:self.editIV];
    [self.editIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.right.mas_equalTo(self.iconIV).offset(-5);
        make.bottom.mas_equalTo(self.iconIV);
    }];
    
    // 签到按钮
    [self.presentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgIV);
        make.centerY.equalTo(self.iconIV);
    }];
    
    [self.vipView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(self.iconIV.mas_bottom).offset(22);
        make.top.equalTo(self.iconIV.mas_bottom).offset(30);
        make.right.equalTo(self.bgIV).offset(-PADDING_15);
        make.left.equalTo(self.bgIV).offset(PADDING_15);
        //make.bottom.equalTo(self.contentView).offset(-24);
        make.height.mas_equalTo(65);
    }];
    
    [self.vipViewBgShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vipView).offset(-16);
        make.right.equalTo(self.vipView).offset(15);
        make.left.equalTo(self.vipView).offset(-15);
        make.bottom.equalTo(self.vipView).offset(16);
    }];
}


/** 更新 昵称 和 ID 约束 22*/
- (void)remakeNickNameConstraint {
    
    if (isEmpty(self.carIdLabel.text)) {
        [self.nickNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).offset(PADDING_15);
            make.right.lessThanOrEqualTo(self.presentBtn.mas_left).offset(-20);
            make.centerY.equalTo(self.iconIV);
        }];
    }else{
        [self.nickNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).offset(PADDING_15);
            make.right.lessThanOrEqualTo(self.presentBtn.mas_left).offset(-20);
            make.bottom.equalTo(self.carIdLabel.mas_top).offset(-4);
        }];
        
        [self.carIdLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.iconIV.mas_bottom).offset(-8);
            make.left.equalTo(self.iconIV.mas_right).offset(PADDING_15);
        }];
    }
    
    [self.nickNameVipIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nickNameLabel);
        make.left.equalTo(self.nickNameLabel.mas_right).offset(2);
        make.right.lessThanOrEqualTo(self.presentBtn.mas_left).offset(-1);
    }];
}


//编辑 图片
- (UIImageView*)editIV {
    if (!_editIV) {
        _editIV = [[UIImageView alloc]initWithImage:imageName(@"icon_edit")];
        _editIV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _editIV;
}


- (UIImageView*)bgIV {
    if (!_bgIV) {
        _bgIV = [UIImageView new];
        //_bgIV = [[UIImageView alloc]initWithImage:imageName(@"my_info_head_bg")];
    }
    return _bgIV;
}


- (UIImageView*)nickNameVipIV {
    if (!_nickNameVipIV) {
        _nickNameVipIV = [[UIImageView alloc]initWithImage:imageName(@"icon_edit")];
        _nickNameVipIV.contentMode = UIViewContentModeScaleAspectFit;
        //_nickNameVipIV.image = imageName(@"ic_bestvip_v2_18");
        _nickNameVipIV.hidden = YES;
    }
    return _nickNameVipIV;
}


- (UIImageView*)iconIV {
    
    if (!_iconIV) {
        _iconIV = [UIImageView new];
        _iconIV.tag = 10;
        _iconIV.contentMode = UIViewContentModeScaleAspectFill;
        _iconIV.layer.masksToBounds = YES;
        _iconIV.userInteractionEnabled = YES;
        //[_iconIV.layer setCornerRadius:IS_IPHONE6PLUS ? 40: 35];
        [_iconIV.layer setCornerRadius:55/2.0];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconClickAction:)];
        [_iconIV addGestureRecognizer:tapGesture];
    }
    return _iconIV;
}



- (void)iconClickAction:(id)sender {
    [MobClick event:UM_RECORD_PERSONALCENTER_PORTRAIT];
    [self.delegate userIconCellAction:sender image:self.iconImage model:self.userInfoModel];
}


- (UIButton *)presentBtn {
    if (!_presentBtn) {
        _presentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _presentBtn.contentMode = UIViewContentModeScaleToFill;
        [_presentBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:PADDING_10];
        [_presentBtn addTarget:self action:@selector(presentEntranceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _presentBtn;
}


- (void)presentEntranceBtnClick {
    [MobClick event:UM_RECORD_PERSON_CENTER_SIGNIN];
    !self.presentEntranceBlock? nil : self.presentEntranceBlock();
}



- (UILabel*)nickNameLabel {
    
    if (!_nickNameLabel) {
        _nickNameLabel = [UILabel labelWithTitle:CGRectZero title:nil  titleColor:COLOR_27323F
                                       titleFont:nil titleAligment:NSTextAlignmentLeft];
        _nickNameLabel.userInteractionEnabled = YES;
        _nickNameLabel.font = HK_FONT_SYSTEM_WEIGHT(15, UIFontWeightMedium);
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nickNameLabelClick:)];
        [_nickNameLabel addGestureRecognizer:tapGesture];
    }
    return _nickNameLabel;
}



- (void)nickNameLabelClick:(id)sender {
    
    if([self.delegate respondsToSelector:@selector(nameLabelAction:)]) {
        [self.delegate nameLabelAction:sender];
    }
}



- (UILabel*)carIdLabel {
    
    if (!_carIdLabel) {
        _carIdLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE
                                    titleFont:nil titleAligment:NSTextAlignmentLeft];
        _carIdLabel.font = HK_FONT_SYSTEM(12);
    }
    return _carIdLabel;
}



- (HKMyInfoVipView*)vipView {
    if (!_vipView) {
        _vipView = [[HKMyInfoVipView alloc]init];
        _vipView.delegate = self;
    }
    return _vipView;
}

- (UIImageView *)vipViewBgShadowView {
    if (!_vipViewBgShadowView) {
        _vipViewBgShadowView = [[UIImageView alloc] init];
        //UIImage *image1 = imageName(@"bg_myself_v2_4");
        //image1 = [image1 resizableImageWithCapInsets:UIEdgeInsetsMake(image1.size.height*0.5, image1.size.width*0.5, image1.size.height*0.5, image1.size.width*0.5)];
        //_vipViewBgShadowView.image = image1;
//        _vipViewBgShadowView.contentMode = UIViewContentModeScaleAspectFill;
//        _vipViewBgShadowView.clipsToBounds = YES;
    }
    return _vipViewBgShadowView;
}


#pragma mark HKMyInfoVipView delegate
- (void)myInfoVipViewClickAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(vipPushAction:)]) {
        [self.delegate vipPushAction:sender];
    }
}




- (void)setVipModel:(HKMyInfoVipModel *)vipModel {
    _vipModel = vipModel;
    self.vipView.vipModel = vipModel;
    self.vipViewBgShadowView.image = [self vipViewBgImageWithType:vipModel.vip_class];
}



- (void)setUserInfoModel:(HKUserModel *)userInfoModel {
    
    _userInfoModel = userInfoModel;
    
    self.editIV.hidden = isEmpty(userInfoModel.avator) ?YES :NO;
    
    if (isLogin()) {
        _nickNameLabel.text = userInfoModel.username;
        _carIdLabel.text = [NSString stringWithFormat:@"学号：%@",userInfoModel.ID];
    }else{
        _nickNameLabel.text = @"一键登录，免费学习";
        _carIdLabel.text = nil;
        self.sign_type = @"0";
        self.iconUrl = nil;
    }
    
    [self setIconImageByUrl:userInfoModel.avator];
    
    // 签到的状态
    self.sign_type = userInfoModel.sign_type;
    self.sign_continue_num = userInfoModel.sign_continue_num;
    
    [self setPresentTitle:self.sign_type signNum:self.sign_continue_num];
    
    self.vipView.userModel = userInfoModel;
    [self remakeNickNameConstraint];
    
    [self showOrHiddenNickNameImageWithVip:userInfoModel.vip_class];
}




- (void)setPresentTitle:(NSString*)signType signNum:(NSString*)signNum {
    
    NSString *bgImageName = nil;
    NSString *imageName = nil;
    NSString *title = nil;
    UIColor *titleColor = nil;
    UIFont *font = nil;
    if (isLogin()) {
        if ([signType isEqualToString:@"1"] && signNum){
            title = @"赚虎课币";
            imageName = @"ic_hukemoney_v2_18";
            bgImageName = @"bg_signin_clicked_v2_18";
            titleColor = COLOR_FF9400;
        }else{
            title = @"签到有奖";
            imageName = @"ic_sign_in_v2_18";
            bgImageName = @"bg_signin_normal_v2_18";
            titleColor = COLOR_ffffff;
        }
        font = HK_FONT_SYSTEM_WEIGHT(14, UIFontWeightMedium);
    }else{
        title = @"去登录";
        bgImageName = @"bg_signup_normal_v2_18";
        titleColor = [UIColor whiteColor];
        font = HK_FONT_SYSTEM_WEIGHT(14, UIFontWeightSemibold);
    }
    
    self.presentBtn.titleLabel.font = font;
    [self.presentBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [self.presentBtn setTitle:title forState:UIControlStateNormal];
    [self.presentBtn setImage:imageName(imageName) forState:UIControlStateNormal];
    [self.presentBtn setImage:imageName(imageName) forState:UIControlStateHighlighted];
    
    [self.presentBtn setBackgroundImage:imageName(bgImageName) forState:UIControlStateNormal];
    [self.presentBtn setBackgroundImage:imageName(bgImageName) forState:UIControlStateHighlighted];
}




#pragma mark - 签到的状态 发生改变
- (void)signStatusChange:(NSNotification *)notification{
    //    sign_type：1-当天已签到 0-未签
    NSDictionary *dic = notification.object;
    NSString *sign_status = dic[@"sign_type"];
    NSString *sign_continue_num = dic[@"sign_continue_num"];
    if ([self.sign_type isEqualToString:sign_status] && [self.sign_continue_num isEqualToString:sign_continue_num]) {
        return;
    }
    self.sign_type = sign_status;
    self.sign_continue_num = sign_continue_num;
    
    [self setPresentTitle:self.sign_type signNum:self.sign_continue_num];
}



- (void)setIconImageByUrl:(NSString*)url {
    
    if (![self.iconUrl isEqualToString:url] || isEmpty(url)) {
        [_iconIV sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:url]) placeholderImage:imageName(HUKE_ICON) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                _iconImage = image;
                self.iconUrl = url;
            }
        }];
    }
}



/**
VIP view 背景图片
 
 @param type 5-分类限五vip 4-套餐vip  3-终身全站通  2-全站通VIP  1-分类无限VIP  0-非VIP
 @return
 */
- (UIImage*)vipViewBgImageWithType:(NSString *)type {
        UIImage *bgImage = nil;
        switch ([type intValue]) {
                
            case HKVipType_Expire:
                bgImage = [UIImage resizableImageWithName:@"bg_vip_delay_v2_18"];//imageName(@"bg_vip_delay_v2_18");
                self.nickNameVipIV.hidden = YES;
                break;
                
            case HKVipType_No:
                bgImage = [UIImage resizableImageWithName:@"bg_signup_not_v2_18"];//imageName(@"bg_signup_not_v2_18");
                self.nickNameVipIV.hidden = YES;
                break;
                                
            case HKVipType_OneYear:
                
                //bgImage = imageName(@"bg_vip_quanzhantong_v2_18");
                bgImage = [UIImage resizableImageWithName:@"bg_vip_quanzhantong_v2_18"];
                self.nickNameVipIV.hidden = NO;
                break;
                
            case HKVipType_WholeLife:
                bgImage = [UIImage resizableImageWithName:@"bg_vip_zhongshen_v2_18"];//imageName(@"bg_vip_zhongshen_v2_18");
                self.nickNameVipIV.hidden = NO;
                break;
                
            case HKVipType_Group: case HKVipType_Separator5Days: case HKVipType_Separator:
                bgImage = [UIImage resizableImageWithName:@"bg_vip_fenlei_v2_18"];//imageName(@"bg_vip_fenlei_v2_18");
                self.nickNameVipIV.hidden = NO;
                break;
        }
    
        //[self showOrHiddenNickNameImageWithVip:type];
        //bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(bgImage.size.height*0.5, bgImage.size.width*0.5, bgImage.size.height*0.5, bgImage.size.width*0.5)];
    
        return  bgImage;
}





/// 昵称view 上的VIP icon的显示
/// @param vipType
- (void)showOrHiddenNickNameImageWithVip:(NSString *)vipType {
    
    UIImage *image = nil;
    switch ([vipType intValue]) {
        case HKVipType_Expire:
        case HKVipType_No:
            self.nickNameVipIV.hidden = YES;
            break;
            
        case HKVipType_Group:
        case HKVipType_Separator5Days:
        case HKVipType_Separator:
            self.nickNameVipIV.image = imageName(@"ic_classification_v2_18");
            self.nickNameVipIV.hidden = NO;
            break;
            
        case HKVipType_OneYear:
            image =
            self.nickNameVipIV.image = imageName(@"ic_quanzhantong_v2_18");;
            self.nickNameVipIV.hidden = NO;
            break;
            
        case HKVipType_WholeLife:
            self.nickNameVipIV.image = imageName(@"ic_bestvip_v2_18");
            self.nickNameVipIV.hidden = NO;
            break;
    }
}



@end

