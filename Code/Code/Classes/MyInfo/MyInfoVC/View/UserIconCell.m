//
//  UserIconTableViewCell.m
//  Code
//
//  Created by pg on 2017/2/13.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "UserIconCell.h"
#import "UIButton+WebCache.h"
#import "HKLeftRightBtn.h"
#import "MyInfoViewController.h"


#define HUKE_ICON  @"huke_login_bg"

@interface UserIconCell()

@property (nonatomic, strong)UIButton *samllEditBtn;


@end


@implementation UserIconCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        [self makeConstraints];
        [self userInfoObserver];
    }
    return self;
}


-(void)dealloc{
    HK_NOTIFICATION_REMOVE();
}


#pragma mark - 观察用户VIP 登录状态变化
- (void)userInfoObserver {
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signStatusChange:) name:@"HKSignStatusChange" object:nil];
}



- (void)createUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundView = [[UIImageView alloc]initWithImage:imageName(@"my_info_head_bg")];
    
    [self.contentView addSubview:self.iconBtn];
    [self.contentView addSubview:self.nickNameLabel];
    [self.contentView addSubview:self.carIdLabel];
    
    [self.contentView addSubview:self.allVipImageView];
    // 签到按钮
    [self.contentView addSubview:self.presentBtn];
}


- (void)makeConstraints {
    

    [self.iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(PADDING_15);
        make.centerY.equalTo(self.mas_centerY).offset(PADDING_10);
        make.size.mas_equalTo(IS_IPHONE6PLUS ?CGSizeMake(80, 80): CGSizeMake(70, 70));
    }];
    
    [self.contentView bringSubviewToFront:self.samllEditBtn];
    [self.samllEditBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(IS_IPHONE6PLUS ?CGSizeMake(18, 18): CGSizeMake(17, 17));
        make.right.mas_equalTo(self.iconBtn).offset(-5);
        make.bottom.mas_equalTo(self.iconBtn);
    }];
    
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconBtn.mas_top).offset(PADDING_15);
        make.left.equalTo(self.iconBtn.mas_right).offset(PADDING_15);
    }];
    
    [_carIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nickNameLabel.mas_bottom).offset(PADDING_10);
        make.left.equalTo(self.nickNameLabel.mas_left);
    }];
    
    // 签到按钮
    [self.presentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.presentBtn.superview).offset(-PADDING_5);
        make.bottom.equalTo(self).offset(-18);
        //[_presentBtn setImageEdgeInsets:UIEdgeInsetsMake(0,  _presentBtn.titleLabel.width + 2, 0, -_presentBtn.titleLabel.width - 2)];
        //[_presentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_presentBtn.imageView.width, 0, +_presentBtn.imageView.width)];
    }];
    
    [_allVipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.nickNameLabel);
        make.left.equalTo(self.nickNameLabel.mas_right).offset(7);
        make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-PADDING_5);
    }];
    
}





- (UIButton*)iconBtn {
    
    if (!_iconBtn) {
        _iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconBtn.tag = 10;
        _iconBtn.layer.masksToBounds = YES;
        [_iconBtn.layer setCornerRadius:IS_IPHONE6PLUS ? 40: 35];
        [_iconBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_iconBtn setImage:imageName(HUKE_ICON) forState:UIControlStateNormal];
        [_iconBtn setImage:imageName(HUKE_ICON) forState:UIControlStateSelected];
        [_iconBtn setImage:imageName(HUKE_ICON) forState:UIControlStateHighlighted];
        _iconBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        // 编辑按钮
        UIButton *samlleEditBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        samlleEditBtn.userInteractionEnabled = NO;
        self.samllEditBtn = samlleEditBtn;
        samlleEditBtn.hidden = YES;
        [samlleEditBtn setImage:imageName(@"icon_edit") forState:UIControlStateNormal];
        [self.contentView addSubview:samlleEditBtn];
    }
    return _iconBtn;
}

- (UIButton *)presentBtn {
    if (_presentBtn == nil) {
        //_presentBtn = [HKLeftRightBtn buttonWithType:UIButtonTypeCustom];
        _presentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_presentBtn setImage:imageName(@"my_sign") forState:UIControlStateNormal];
        [_presentBtn setImage:imageName(@"my_sign") forState:UIControlStateHighlighted];
        //[_presentBtn setImage:imageName(@"present_my_info_arrow") forState:UIControlStateNormal];
        [_presentBtn setBackgroundImage:imageName(@"present_my_info_bg") forState:UIControlStateNormal];
        [_presentBtn setBackgroundImage:imageName(@"present_my_info_bg") forState:UIControlStateHighlighted];
        [_presentBtn addTarget:self action:@selector(presentEntranceBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _presentBtn.titleLabel.font = [UIFont systemFontOfSize:11.0];
        [_presentBtn setTitleColor:HKColorFromHex(0xFF3221, 1.0) forState:UIControlStateNormal];
        [_presentBtn setTitle:@"签到有奖" forState:UIControlStateNormal];
        [_presentBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -7, 0, 0)];
        _presentBtn.contentMode = UIViewContentModeScaleToFill;
    }
    return _presentBtn;
}

- (void)presentEntranceBtnClick {
    [MobClick event:UM_RECORD_PERSON_CENTER_SIGNIN];
    !self.presentEntranceBlock? : self.presentEntranceBlock();
}



- (UILabel*)nickNameLabel {
    
    if (!_nickNameLabel) {
        _nickNameLabel = [UILabel labelWithTitle:CGRectZero title:nil
                                      titleColor:nil
                                       titleFont:nil titleAligment:NSTextAlignmentLeft];
        
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
        [_nickNameLabel addGestureRecognizer:labelTapGestureRecognizer];
        _nickNameLabel.textColor = COLOR_27323F;
        _nickNameLabel.userInteractionEnabled = YES;
        _nickNameLabel.font = HK_FONT_SYSTEM_BOLD(IS_IPHONE6PLUS ?17 :16);
    }
    return _nickNameLabel;
}



- (void)labelClick:(id)sender {
    
    if([self.delegate respondsToSelector:@selector(nameLabelAction:)]){
        [self.delegate nameLabelAction:sender];
    }
}



- (UILabel*)carIdLabel {
    
    if (!_carIdLabel) {
        _carIdLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:[UIColor whiteColor]
                                    titleFont:nil titleAligment:NSTextAlignmentLeft];
        _carIdLabel.textColor = COLOR_9B8200;
        [_carIdLabel setFont:[UIFont systemFontOfSize:IS_IPHONE6PLUS ?12 :11]];
    }
    return _carIdLabel;
}


- (UIImageView*)allVipImageView {
    
    if (!_allVipImageView) {
        _allVipImageView = [UIImageView new];
        _allVipImageView.contentMode = UIViewContentModeScaleAspectFit;
        // 当没有VIP 时 可以点击 跳转到VIP购买
        UITapGestureRecognizer *openVipTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openVipImageAction:)];
        [_allVipImageView addGestureRecognizer:openVipTapGestureRecognizer];
    }
    return  _allVipImageView;
}



- (void)openVipImageAction:(id)sender {
    
    if([self.delegate respondsToSelector:@selector(openVipAction:)]){
        [self.delegate openVipAction:sender];
    }
}



- (void)clickAction:(id)sender {
    [MobClick event:UM_RECORD_PERSONALCENTER_PORTRAIT];
    [self.delegate userIconCellAction:sender image:self.iconImage model:self.userInfoModel];
}



- (void)setUserInfoModel:(HKUserModel *)userInfoModel {
    
    _userInfoModel = userInfoModel;
    [self setIconBtnBgImageByUrl:userInfoModel.avator];
    
    if (isLogin()) {
        _nickNameLabel.text = userInfoModel.username;
        _carIdLabel.text = [NSString stringWithFormat:@"学号：%@",userInfoModel.ID];
    }else{
        _nickNameLabel.text = @"登录/注册";
        _carIdLabel.text = @"1秒登录，免费学习";
        self.sign_type = @"0";
    }
    
    [self vipImageWithModel:userInfoModel];
    // 签到的状态
    self.sign_type = userInfoModel.sign_type;
    self.sign_continue_num = userInfoModel.sign_continue_num;
    
    NSString *imageName = nil;
    if ([self.sign_type isEqualToString:@"1"] && self.sign_continue_num && isLogin()){
        //[self.presentBtn setTitle:[NSString stringWithFormat:@"连续签到%@天", self.sign_continue_num] forState:UIControlStateNormal];
        [_presentBtn setTitle:@"赚虎课币 >" forState:UIControlStateNormal];
        imageName = @"my_have_sign";
    }else{
        [_presentBtn setTitle:@"签到有奖" forState:UIControlStateNormal];
        imageName = @"my_sign";
    }
    [_presentBtn setImage:imageName(imageName) forState:UIControlStateNormal];
    [_presentBtn setImage:imageName(imageName) forState:UIControlStateHighlighted];
}



//vip_type:0-非VIP 1-分类VIP 2-全站通VIP 3-终身全站通VIP
- (void)vipImageWithModel:(HKUserModel *)userInfoModel {
    
    NSString *vip_class = userInfoModel.vip_class;
    _allVipImageView.image = [HKvipImage user_vipImageWithType:vip_class];
    _allVipImageView.userInteractionEnabled = NO;
    NSInteger vip = [vip_class intValue];
    switch (vip) {
        case 0:
        {
            if (isLogin()) {
                //无vip 
                _allVipImageView.image = imageName(@"open_vip_gray");
                _allVipImageView.userInteractionEnabled = YES;
            }else{
                _allVipImageView.image = nil;
            }
        }
            break;
        case 1:
            break;
    }
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
    
    NSString *imageName = nil;
    if ([sign_status isEqualToString:@"1"] && isLogin() && sign_continue_num){
        //[self.presentBtn setTitle:[NSString stringWithFormat:@"连续签到%@天", sign_continue_num] forState:UIControlStateNormal];
        [self.presentBtn setTitle:@"赚虎课币 >" forState:UIControlStateNormal];
        imageName = @"my_have_sign";
    }else {
        imageName = @"my_sign";
        [self.presentBtn setTitle:@"签到有奖" forState:UIControlStateNormal];
    }
    [_presentBtn setImage:imageName(imageName) forState:UIControlStateNormal];
    [_presentBtn setImage:imageName(imageName) forState:UIControlStateHighlighted];
    // 签到按钮
    [self.presentBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.presentBtn.superview).offset(-PADDING_5);
        make.bottom.equalTo(self).offset(-18);
        
        //make.centerY.equalTo(self.iconBtn);
        //        [_presentBtn setImageEdgeInsets:UIEdgeInsetsMake(0,  _presentBtn.titleLabel.width + 2, 0, -_presentBtn.titleLabel.width - 2)];
        //        [_presentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_presentBtn.imageView.width, 0, +_presentBtn.imageView.width)];
    }];
    
}



- (void)setIconBtnBgImageByUrl:(NSString*)url  {
    
    NSURL *tempUrl = nil;
    if (isEmpty(url)) {
        self.samllEditBtn.hidden = YES;
        tempUrl = [NSURL URLWithString:url];
        [_iconBtn setImage:imageName(HUKE_ICON) forState:UIControlStateNormal];
        [_iconBtn setImage:imageName(HUKE_ICON) forState:UIControlStateSelected];
        [_iconBtn setImage:imageName(HUKE_ICON) forState:UIControlStateHighlighted];
    }else{
        self.samllEditBtn.hidden = NO;
        tempUrl = [NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:url]];
        
        [_iconBtn sd_setImageWithURL:tempUrl forState:UIControlStateNormal placeholderImage:imageName(HUKE_ICON) options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            _iconImage = image;
        }];
        
        [_iconBtn sd_setImageWithURL:tempUrl forState:UIControlStateHighlighted placeholderImage:imageName(HUKE_ICON) options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            _iconImage = image;
        }];
        
        [_iconBtn sd_setImageWithURL:tempUrl forState:UIControlStateSelected placeholderImage:imageName(HUKE_ICON) options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            _iconImage = image;
        }];
    }
}




@end


















////
////  UserIconTableViewCell.m
////  Code
////
////  Created by pg on 2017/2/13.
////  Copyright © 2017年 pg. All rights reserved.
////
//
//#import "UserIconCell.h"
//#import "UIButton+WebCache.h"
//#import "HKLeftRightBtn.h"
//#import "MyInfoViewController.h"
//
//
//#define HUKE_ICON  @"huke_login_bg"
//
//@interface UserIconCell()
//
//@property (nonatomic, strong)UIButton *samllEditBtn;
//
//
//@end
//
//
//@implementation UserIconCell
//
//- (void)awakeFromNib {
//    [super awakeFromNib];
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//}
//
//
//-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        [self createUI];
//        [self makeConstraints];
//        [self userInfoObserver];
//    }
//    return self;
//}
//
//
//-(void)dealloc{
//    HK_NOTIFICATION_REMOVE();
//}
//
//
//#pragma mark - 观察用户VIP 登录状态变化
//- (void)userInfoObserver {
//    // 注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signStatusChange:) name:@"HKSignStatusChange" object:nil];
//}
//
//
//
//- (void)createUI {
//
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.backgroundView = [[UIImageView alloc]initWithImage:imageName(@"my_info_head_bg")];
//
//    [self.contentView addSubview:self.iconBtn];
//    [self.contentView addSubview:self.nickNameLabel];
//    [self.contentView addSubview:self.carIdLabel];
//
//    [self.contentView addSubview:self.allVipImageView];
//    [self.contentView addSubview:self.partVipImageView];
//    [self.contentView addSubview:self.openVipImageView];
//    // 签到按钮
//    [self.contentView addSubview:self.presentBtn];
//}
//
//
//- (void)makeConstraints {
//
//    __weak typeof (self) weakSelf = self;
//    [self.iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.contentView.mas_left).offset(PADDING_15);
//        make.centerY.equalTo(weakSelf.mas_centerY).offset(PADDING_10);
//        make.size.mas_equalTo(IS_IPHONE6PLUS ?CGSizeMake(80, 80): CGSizeMake(70, 70));
//    }];
//
//    [self.contentView bringSubviewToFront:self.samllEditBtn];
//    [self.samllEditBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(IS_IPHONE6PLUS ?CGSizeMake(18, 18): CGSizeMake(17, 17));
//        make.right.mas_equalTo(self.iconBtn).offset(-5);
//        make.bottom.mas_equalTo(self.iconBtn);
//    }];
//
//    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.iconBtn.mas_top).offset(PADDING_15);
//        make.left.equalTo(weakSelf.iconBtn.mas_right).offset(PADDING_15);
//    }];
//
//    [_carIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.nickNameLabel.mas_bottom).offset(PADDING_10);
//        make.left.equalTo(weakSelf.nickNameLabel.mas_left);
//    }];
//
//    // 签到按钮
//    [self.presentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(weakSelf.presentBtn.superview).offset(-PADDING_5);
//        make.bottom.equalTo(weakSelf).offset(-18);
//        //[_presentBtn setImageEdgeInsets:UIEdgeInsetsMake(0,  _presentBtn.titleLabel.width + 2, 0, -_presentBtn.titleLabel.width - 2)];
//        //[_presentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_presentBtn.imageView.width, 0, +_presentBtn.imageView.width)];
//    }];
//
//    [_allVipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.centerY.equalTo(weakSelf.nickNameLabel.mas_centerY);
//        make.size.mas_equalTo(IS_IPHONE6PLUS ? CGSizeMake(75, 19): CGSizeMake(75, 19));
//        make.left.equalTo(weakSelf.nickNameLabel.mas_right).offset(7);
//        make.right.lessThanOrEqualTo(weakSelf.contentView.mas_right).offset(-PADDING_5);
//    }];
//
//    [_partVipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.height.top.equalTo(weakSelf.allVipImageView);
//        make.left.equalTo(weakSelf.allVipImageView.mas_right).offset(PADDING_5);
//        //make.right.greaterThanOrEqualTo(weakSelf.contentView.mas_right).offset(-PADDING_5);
//    }];
//
//    [_openVipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(weakSelf.nickNameLabel.mas_centerY);
//        make.left.equalTo(weakSelf.nickNameLabel.mas_right).offset(7);
//    }];
//
//    /*
//     [_allVipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//     make.height.top.equalTo(weakSelf.nickNameLabel);
//     make.left.equalTo(weakSelf.nickNameLabel.mas_right).offset(7);
//     }];
//
//     [_partVipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//     make.height.top.equalTo(weakSelf.allVipImageView);
//     make.left.equalTo(weakSelf.allVipImageView.mas_right).offset(PADDING_5);
//     //make.right.greaterThanOrEqualTo(weakSelf.contentView.mas_right).offset(-PADDING_5);
//     }];*/
//}
//
//
//
//- (void)chagePartVipConstraints {
//
//    WeakSelf;
//    [_partVipImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//
//        make.centerY.equalTo(weakSelf.nickNameLabel.mas_centerY);
//        //make.size.mas_equalTo(IS_IPHONE6PLUS ? CGSizeMake(75, 19): CGSizeMake(75, 19));
//        make.height.top.equalTo(weakSelf.allVipImageView);
//        make.left.equalTo(weakSelf.nickNameLabel.mas_right).offset(7);
//    }];
//}
//
//
//- (UIButton*)iconBtn {
//
//    if (!_iconBtn) {
//        _iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _iconBtn.tag = 10;
//        _iconBtn.layer.masksToBounds = YES;
//        [_iconBtn.layer setCornerRadius:IS_IPHONE6PLUS ? 40: 35];
//        [_iconBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
//
//        [_iconBtn setImage:imageName(HUKE_ICON) forState:UIControlStateNormal];
//        //[_iconBtn setImage:imageName(HK_Placeholder) forState:UIControlStateNormal];
//        [_iconBtn setImage:imageName(HUKE_ICON) forState:UIControlStateSelected];
//        [_iconBtn setImage:imageName(HUKE_ICON) forState:UIControlStateHighlighted];
//        _iconBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
//
//        // 编辑按钮
//        UIButton *samlleEditBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        samlleEditBtn.userInteractionEnabled = NO;
//        self.samllEditBtn = samlleEditBtn;
//        samlleEditBtn.hidden = YES;
//        [samlleEditBtn setImage:imageName(@"icon_edit") forState:UIControlStateNormal];
//        [self.contentView addSubview:samlleEditBtn];
//    }
//    return _iconBtn;
//}
//
//- (UIButton *)presentBtn {
//    if (_presentBtn == nil) {
//        //_presentBtn = [HKLeftRightBtn buttonWithType:UIButtonTypeCustom];
//        _presentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_presentBtn setImage:imageName(@"my_sign") forState:UIControlStateNormal];
//        [_presentBtn setImage:imageName(@"my_sign") forState:UIControlStateHighlighted];
//        //[_presentBtn setImage:imageName(@"present_my_info_arrow") forState:UIControlStateNormal];
//        [_presentBtn setBackgroundImage:imageName(@"present_my_info_bg") forState:UIControlStateNormal];
//        [_presentBtn setBackgroundImage:imageName(@"present_my_info_bg") forState:UIControlStateHighlighted];
//        [_presentBtn addTarget:self action:@selector(presentEntranceBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        _presentBtn.titleLabel.font = [UIFont systemFontOfSize:11.0];
//        [_presentBtn setTitleColor:HKColorFromHex(0xFF3221, 1.0) forState:UIControlStateNormal];
//        [_presentBtn setTitle:@"签到有奖" forState:UIControlStateNormal];
//        [_presentBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -7, 0, 0)];
//        _presentBtn.contentMode = UIViewContentModeScaleToFill;
//    }
//    return _presentBtn;
//}
//
//- (void)presentEntranceBtnClick {
//    [MobClick event:UM_RECORD_PERSON_CENTER_SIGNIN];
//    !self.presentEntranceBlock? : self.presentEntranceBlock();
//}
//
//
//
//- (UILabel*)nickNameLabel {
//
//    if (!_nickNameLabel) {
//        _nickNameLabel = [UILabel labelWithTitle:CGRectZero title:nil
//                                      titleColor:nil
//                                       titleFont:nil titleAligment:NSTextAlignmentLeft];
//
//        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
//        [_nickNameLabel addGestureRecognizer:labelTapGestureRecognizer];
//        _nickNameLabel.textColor = COLOR_27323F;
//        _nickNameLabel.userInteractionEnabled = YES;
//        _nickNameLabel.font = HK_FONT_SYSTEM_BOLD(IS_IPHONE6PLUS ?17 :16);
//    }
//    return _nickNameLabel;
//}
//
//
//
//- (void)labelClick:(id)sender {
//
//    if([self.delegate respondsToSelector:@selector(nameLabelAction:)]){
//        [self.delegate nameLabelAction:sender];
//    }
//}
//
//
//
//- (UILabel*)carIdLabel {
//
//    if (!_carIdLabel) {
//        _carIdLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:[UIColor whiteColor]
//                                    titleFont:nil titleAligment:NSTextAlignmentLeft];
//        _carIdLabel.textColor = COLOR_9B8200;
//        [_carIdLabel setFont:[UIFont systemFontOfSize:IS_IPHONE6PLUS ?12 :11]];
//    }
//    return _carIdLabel;
//}
//
//
//- (UIImageView*)allVipImageView {
//
//    if (!_allVipImageView) {
//        _allVipImageView = [UIImageView new];
//        _allVipImageView.contentMode = UIViewContentModeLeft;
//        _allVipImageView.image = imageName(@"vip_all");
//        _allVipImageView.hidden = YES;
//    }
//    return  _allVipImageView;
//}
//
//- (UIImageView*)partVipImageView {
//
//    if (!_partVipImageView) {
//        _partVipImageView = [UIImageView new];
//        _partVipImageView.contentMode = UIViewContentModeLeft;
//        _partVipImageView.image = imageName(@"vip_part");
//        _partVipImageView.hidden = YES;
//    }
//    return  _partVipImageView;
//}
//
//
//- (UIImageView*)openVipImageView {
//
//    if (!_openVipImageView) {
//        _openVipImageView = [UIImageView new];
//        _openVipImageView.contentMode = UIViewContentModeCenter;
//
//        UITapGestureRecognizer *openVipTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openVipImageAction:)];
//        [_openVipImageView addGestureRecognizer:openVipTapGestureRecognizer];
//        _openVipImageView.userInteractionEnabled = YES;
//        _openVipImageView.hidden = YES;
//    }
//    return  _openVipImageView;
//}
//
//
//- (void)openVipImageAction:(id)sender {
//
//    if([self.delegate respondsToSelector:@selector(openVipAction:)]){
//        [self.delegate openVipAction:sender];
//    }
//}
//
//
//
//
//
//
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    //[self makeConstraints];
//}
//
//
//
//- (void)clickAction:(id)sender {
//    [MobClick event:UM_RECORD_PERSONALCENTER_PORTRAIT];
//    [self.delegate userIconCellAction:sender image:self.iconImage model:self.userInfoModel];
//}
//
//
//- (void)setUserInfoModel:(HKUserModel *)userInfoModel {
//
//    _userInfoModel = userInfoModel;
//    [self setIconBtnBgImageByUrl:userInfoModel.avator];
//
//    if (isLogin()) {
//        _nickNameLabel.text = userInfoModel.username;
//    }else{
//        _nickNameLabel.text = @"登录/注册";
//    }
//
//    if (!isEmpty(userInfoModel.ID)) {
//        _carIdLabel.text = [NSString stringWithFormat:@"ID：%@",userInfoModel.ID];
//    }else{
//        _carIdLabel.text = @"1秒登录，免费学习";
//    }
//
//    [self vipChangeWithModel:userInfoModel];
//
//    if (!isLogin()) {
//        self.sign_type = @"0";
//    }
//    // 签到的状态
//    self.sign_type = userInfoModel.sign_type;
//    self.sign_continue_num = userInfoModel.sign_continue_num;
//
//    NSString *imageName = nil;
//    if ([self.sign_type isEqualToString:@"1"] && self.sign_continue_num && isLogin()){
//        //[self.presentBtn setTitle:[NSString stringWithFormat:@"连续签到%@天", self.sign_continue_num] forState:UIControlStateNormal];
//        [_presentBtn setTitle:@"赚虎课币 >" forState:UIControlStateNormal];
//        imageName = @"my_have_sign";
//    }else{
//        [_presentBtn setTitle:@"签到有奖" forState:UIControlStateNormal];
//        imageName = @"my_sign";
//    }
//    [_presentBtn setImage:imageName(imageName) forState:UIControlStateNormal];
//    [_presentBtn setImage:imageName(imageName) forState:UIControlStateHighlighted];
//}
//
//
//
//- (void)vipChangeWithModel:(HKUserModel *)userInfoModel  {
//    //vip_type:0-非VIP 1-分类VIP 2-全站通VIP 3-终身全站通VIP
//    if ([userInfoModel.vip_type isEqualToString:@"0"]) {
//        if (isLogin()) {
//            _openVipImageView.hidden = NO;
//            _openVipImageView.image = imageName(@"open_vip_gray");
//        }else{
//            _openVipImageView.hidden = YES;
//        }
//        _allVipImageView.hidden = YES;
//        _partVipImageView.hidden = YES;
//    }else if ([userInfoModel.vip_type isEqualToString:@"1"]){
//        _partVipImageView.hidden = NO;
//        _openVipImageView.hidden = YES;
//        [self chagePartVipConstraints];
//
//    }else if ([userInfoModel.vip_type isEqualToString:@"2"]){
//        _allVipImageView.hidden = NO;
//        _openVipImageView.hidden = YES;
//
//    }else if ([userInfoModel.vip_type isEqualToString:@"3"]){
//        _allVipImageView.hidden = NO;
//        _partVipImageView.hidden = YES;
//        _openVipImageView.hidden = YES;
//        _allVipImageView.image = imageName(@"vip_all_whole_life");
//
//    } else {
//        //特殊状态 隐藏VIP
//        _openVipImageView.hidden = YES;
//        _allVipImageView.hidden = YES;
//        _partVipImageView.hidden = YES;
//        if (!isLogin()) {
//            _openVipImageView.image = nil;
//        }
//    }
//}
//
//
//
//
//#pragma mark - 签到的状态 发生改变
//
//- (void)signStatusChange:(NSNotification *)notification{
//    //    sign_type：1-当天已签到 0-未签
//    NSDictionary *dic = notification.object;
//    NSString *sign_status = dic[@"sign_type"];
//    NSString *sign_continue_num = dic[@"sign_continue_num"];
//    if ([self.sign_type isEqualToString:sign_status] && [self.sign_continue_num isEqualToString:sign_continue_num]) {
//        return;
//    }
//    self.sign_type = sign_status;
//    self.sign_continue_num = sign_continue_num;
//
//    NSString *imageName = nil;
//    if ([sign_status isEqualToString:@"1"] && isLogin() && sign_continue_num){
//        //[self.presentBtn setTitle:[NSString stringWithFormat:@"连续签到%@天", sign_continue_num] forState:UIControlStateNormal];
//        [self.presentBtn setTitle:@"赚虎课币 >" forState:UIControlStateNormal];
//        imageName = @"my_have_sign";
//    }else {
//        imageName = @"my_sign";
//        [self.presentBtn setTitle:@"签到有奖" forState:UIControlStateNormal];
//    }
//    [_presentBtn setImage:imageName(imageName) forState:UIControlStateNormal];
//    [_presentBtn setImage:imageName(imageName) forState:UIControlStateHighlighted];
//    // 签到按钮
//    [self.presentBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.presentBtn.superview).offset(-PADDING_5);
//        make.bottom.equalTo(self).offset(-18);
//
//        //make.centerY.equalTo(self.iconBtn);
//        //        [_presentBtn setImageEdgeInsets:UIEdgeInsetsMake(0,  _presentBtn.titleLabel.width + 2, 0, -_presentBtn.titleLabel.width - 2)];
//        //        [_presentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_presentBtn.imageView.width, 0, +_presentBtn.imageView.width)];
//    }];
//
//}
//
//
//
//- (void)setIconBtnBgImageByUrl:(NSString*)url  {
//
//    NSURL *tempUrl = nil;
//    if (isEmpty(url)) {
//        self.samllEditBtn.hidden = YES;
//        tempUrl = [NSURL URLWithString:url];
//        [_iconBtn setImage:imageName(HUKE_ICON) forState:UIControlStateNormal];
//        [_iconBtn setImage:imageName(HUKE_ICON) forState:UIControlStateSelected];
//        [_iconBtn setImage:imageName(HUKE_ICON) forState:UIControlStateHighlighted];
//    }else{
//        self.samllEditBtn.hidden = NO;
//        tempUrl = [NSURL URLWithString:url];
//
//        [_iconBtn sd_setImageWithURL:tempUrl forState:UIControlStateNormal placeholderImage:imageName(HUKE_ICON) options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            _iconImage = image;
//        }];
//
//        [_iconBtn sd_setImageWithURL:tempUrl forState:UIControlStateHighlighted placeholderImage:imageName(HUKE_ICON) options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            _iconImage = image;
//        }];
//
//        [_iconBtn sd_setImageWithURL:tempUrl forState:UIControlStateSelected placeholderImage:imageName(HUKE_ICON) options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            _iconImage = image;
//        }];
//    }
//}
//
//
//
//
//@end
//
