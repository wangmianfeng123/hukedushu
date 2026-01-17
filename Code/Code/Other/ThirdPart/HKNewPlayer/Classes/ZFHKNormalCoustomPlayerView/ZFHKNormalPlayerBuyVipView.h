//
//  ZFHKNormalPlayerBuyVipView.h
//  Code
//
//  Created by Ivan li on 2019/3/12.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKZFNormalPlayerShareBtn,HKPermissionVideoModel;


@protocol ZFHKNormalPlayerBuyVipViewDelegate <NSObject>

@optional
/** 点击分享 */
- (void)zfHKNormalPlayerBuyVipView:(nullable UIView*)view shareAction:(UIButton*)sender;
/** 点击购买VIP */
- (void)zfHKNormalPlayerBuyVipView:(nullable UIView*)view buyVipAction:(UIButton*)sender;
/** 收藏视频 */
//- (void)zfHKNormalPlayerBuyVipView:(nullable UIView*)view collectVideoAction:(UIButton*)sender;

@end


@interface ZFHKNormalPlayerBuyVipView : UIView

@property (nonatomic, strong) UIButton             *bottomVipBtn;

@property (nonatomic, strong) UIButton             *buyVipBtn;

@property (nonatomic, strong) UIButton             *collectBtn;

@property (nonatomic, strong) UILabel              *buyVipTipLabel; //提示无会员，不能继续观看视频

@property (nonatomic, strong)HKZFNormalPlayerShareBtn     *playerShareBtn;

@property (nonatomic, strong)HKPermissionVideoModel *permissionVideoModel;

@property (nonatomic, strong)DetailModel    *detailModel;

@property (nonatomic,weak)id <ZFHKNormalPlayerBuyVipViewDelegate>  delegate;

- (instancetype)initWithModel:(HKPermissionVideoModel*)permissionModel  detailModel:(DetailModel*)detailModel;

@end



@interface ZFHKNormalPlayerJobPathVipBtn : UIButton

@end



NS_ASSUME_NONNULL_END



//
////
////  ZFHKNormalPlayerBuyVipView.m
////  Code
////
////  Created by Ivan li on 2019/3/12.
////  Copyright © 2019年 pg. All rights reserved.
////
//
//#import "ZFHKNormalPlayerBuyVipView.h"
//#import "HKZFNormalPlayerShareBtn.h"
//#import "HKPermissionVideoModel.h"
//
//#import "UIView+SNFoundation.h"
//
//@interface ZFHKNormalPlayerBuyVipView() <HKZFNormalPlayerShareBtnDelegate>
//
//@property (nonatomic,strong) ZFHKNormalPlayerJobPathVipBtn *jobPathVipBtn;
//
//@property (nonatomic,strong) UILabel *tagLB;
//
//@end
//
//
//
//@implementation ZFHKNormalPlayerBuyVipView
//
//
//- (void)dealloc {
//    HK_NOTIFICATION_REMOVE();
//}
//
//
//- (instancetype)initWithModel:(HKPermissionVideoModel*)permissionModel  detailModel:(DetailModel*)detailModel {
//    if (self = [super init]) {
//        self.permissionVideoModel = permissionModel;
//        self.detailModel = detailModel;
//        [self createUI];
//    }
//    return self;
//}
//
//
//- (UILabel*)tagLB {
//    if (!_tagLB) {
//        _tagLB = [UILabel labelWithTitle:CGRectZero title:@"特惠" titleColor:[UIColor whiteColor] titleFont:@"11" titleAligment:NSTextAlignmentCenter];
//        HK_FONT_SYSTEM_WEIGHT(11, UIFontWeightMedium);
//        _tagLB.backgroundColor = COLOR_FF3221;
//    }
//    return _tagLB;
//}
//
//
//
//- (void)createUI {
//
//    self.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.8];
//    if (HKVideoType_JobPath ==  [self.detailModel.video_type integerValue]) {
//
//        //职业路径
//        [self addSubview:self.buyVipTipLabel];
//        [self addSubview:self.jobPathVipBtn];
//        [self addSubview:self.tagLB];
//
//        self.buyVipTipLabel.text = @"您今天的免费学习次数已经用完啦~";
//
//        [self.buyVipTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self).offset(IS_IPHONE_X ?KNavBarHeight64-15 :KNavBarHeight64);
//            make.centerX.equalTo(self);
//        }];
//
//        [self.jobPathVipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.buyVipTipLabel.mas_bottom).offset(27);
//            make.centerX.equalTo(self);
//        }];
//
//        [self.tagLB mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.jobPathVipBtn);
//            make.top.equalTo(self.jobPathVipBtn).offset(-10);
//            make.size.mas_equalTo(CGSizeMake(42, 18));
//        }];
//        [self.tagLB layoutIfNeeded];
//        [self.tagLB setRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomRight radius:9];
//
//    }else{
//        [self addSubview:self.buyVipTipLabel];
//        [self addSubview:self.buyVipBtn];
//        [self addSubview:self.playerShareBtn];
//        [self addSubview:self.collectBtn];
//        [self makeConstraints];
//        HK_NOTIFICATION_ADD(HKCollectVideoNotification, collectVideoNotification:);
//    }
//}
//
//
//- (void)collectVideoNotification:(NSNotification*)noti {
//
//    NSDictionary *dict = noti.userInfo;
//    NSString *videoId = [dict objectForKey:@"video_id"];
//    if (isEmpty(videoId)) {
//        return;
//    }
//    if (![videoId isEqualToString:self.detailModel.video_id]) {
//        return;
//    }
//
//    NSInteger isShare = 0;
//    if (self.permissionVideoModel.is_video_share_over_num) {
//        isShare = self.permissionVideoModel.is_video_share_over_num ?0 :1;
//    }else{
//        isShare = [self.permissionVideoModel.is_share integerValue];
//    }
//
//
//    NSString *state = [dict objectForKey:@"isCollect"];
//
//    if (isShare) {
//        // 可以分享
//    }else{
//        if ([state isEqualToString:@"1"]) {
//            // 收藏成功
//            self.collectBtn.hidden = YES;
//            [self updateBuyVipBtnConstraints];
//        }else {
//            // 取消收藏
//            self.collectBtn.hidden = NO;
//            [self updateMakeConstraints:self.collectBtn sender2:self.buyVipBtn];
//        }
//        self.detailModel.is_collect = !self.detailModel.is_collect;
//    }
//}
//
//
//
//
//- (void)makeConstraints {
//
//    NSString  *tag = nil;
//    NSString *title = nil;
//    NSString *vip = self.permissionVideoModel.is_vip;
//    if ([vip isEqualToString:@"0"]) {
//        // 普通用户
//        title = @"成为VIP无限学";
//        tag = @"特惠";
//    }else if ([vip isEqualToString:@"1"]) {
//        // 0 - 限5分类VIP 显示受限开通VIP   1- 显示升级VIP
//        NSString *buyVip = self.permissionVideoModel.is_buyvip;
//        if ([buyVip isEqualToString:@"0"]) {
//            title = @"成为VIP无限学";
//        }else if ([buyVip isEqualToString:@"1"]) {
//            title = @"升级成为VIP无限学";
//        }
//        tag = @"特惠";
//    }
//    [self.buyVipBtn setTitle:title forState:UIControlStateNormal];
//
//    [self.buyVipTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(IS_IPHONE6PLUS ?85 :65);
//        make.centerX.equalTo(self.mas_centerX);
//    }];
//
//    BOOL isCollect = self.detailModel.is_collect;
//    NSInteger isShare = 0;
//    if (self.permissionVideoModel.is_video_share_over_num) {
//        isShare = self.permissionVideoModel.is_video_share_over_num ?0 :1;
//    }else{
//        isShare = [self.permissionVideoModel.is_share integerValue];
//    }
//
//    if ([vip isEqualToString:@"0"]) {
//        // 普通用户
//        if (isShare) {
//            [self setMakeConstraints:self.playerShareBtn sender2:self.buyVipBtn];
//        }else{
//            if (isCollect) {
//                [self.buyVipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.top.equalTo(self.buyVipTipLabel.mas_bottom).offset(23);
//                    make.centerX.equalTo(self.buyVipTipLabel);
//                    make.size.mas_equalTo(CGSizeMake(PADDING_25*2, PADDING_25*2));
//                }];
//                [self.buyVipBtn setTitleEdgeInsets:UIEdgeInsetsMake(_buyVipBtn.imageView.height+28, -2*_buyVipBtn.imageView.width, 0, -_buyVipBtn.imageView.width)];
//            }else{
//                [self setMakeConstraints:self.collectBtn sender2:self.buyVipBtn];
//            }
//        }
//    }else if ([vip isEqualToString:@"1"]) {
//        //限5
//        if (isCollect) {
//            [self.buyVipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.buyVipTipLabel.mas_bottom).offset(23);
//                make.centerX.equalTo(self.buyVipTipLabel);
//                make.size.mas_equalTo(CGSizeMake(PADDING_25*2, PADDING_25*2));
//            }];
//            [self.buyVipBtn setTitleEdgeInsets:UIEdgeInsetsMake(_buyVipBtn.imageView.height+28, -2*_buyVipBtn.imageView.width, 0, -_buyVipBtn.imageView.width)];
//        }else{
//            [self setMakeConstraints:self.collectBtn sender2:self.buyVipBtn];
//        }
//    }
//
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
//
//    if (!isEmpty(tag)) {
//        self.buyVipBtn.badgeValue = tag;
//        self.buyVipBtn.badgeBGColor = COLOR_FF3221;
//        self.buyVipBtn.badgeFont = HK_FONT_SYSTEM_WEIGHT(10, UIFontWeightMedium);
//        self.buyVipBtn.badgeOriginX = 30;
//    }
//}
//
//
//- (void)updateBuyVipBtnConstraints {
//    [self.buyVipBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.buyVipTipLabel.mas_bottom).offset(23);
//        make.centerX.equalTo(self.buyVipTipLabel);
//        make.size.mas_equalTo(CGSizeMake(PADDING_25*2, PADDING_25*2));
//    }];
//}
//
//
//#pragma mark -
//- (void)setMakeConstraints:(UIButton*)sender sender2:(UIButton*)sender2 {
//
//        [sender mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.buyVipTipLabel.mas_bottom).offset(23);
//            make.size.mas_equalTo(CGSizeMake(PADDING_25*2, PADDING_25*2));
//            make.right.equalTo(self.mas_centerX).offset(-25);
//        }];
//
//        [sender2 mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.buyVipTipLabel.mas_bottom).offset(23);
//            make.size.mas_equalTo(CGSizeMake(PADDING_25*2, PADDING_25*2));
//            make.left.equalTo(self.mas_centerX).offset(25);
//        }];
//
//        if (104 == sender.tag) {
//            [sender setTitleEdgeInsets:UIEdgeInsetsMake(sender.imageView.height+38, -2*sender.imageView.width, 0, -sender.imageView.width)];
//        }else{
//            [sender setTitleEdgeInsets:UIEdgeInsetsMake(sender.imageView.height+28, -2*sender.imageView.width, 0, -sender.imageView.width)];
//        }
//        [sender2 setTitleEdgeInsets:UIEdgeInsetsMake(sender2.imageView.height+28, -2*sender2.imageView.width, 0, -sender2.imageView.width)];
//
//}
//
//
//
//#pragma mark -
//- (void)updateMakeConstraints:(UIButton*)sender sender2:(UIButton*)sender2 {
//
//        [sender mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.buyVipTipLabel.mas_bottom).offset(23);
//            make.size.mas_equalTo(CGSizeMake(PADDING_25*2, PADDING_25*2));
//            make.right.equalTo(self.mas_centerX).offset(-25);
//        }];
//
//        [sender2 mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.buyVipTipLabel.mas_bottom).offset(23);
//            make.size.mas_equalTo(CGSizeMake(PADDING_25*2, PADDING_25*2));
//            make.left.equalTo(self.mas_centerX).offset(25);
//        }];
//
//        if (104 == sender.tag) {
//            [sender setTitleEdgeInsets:UIEdgeInsetsMake(sender.imageView.height+38, -2*sender.imageView.width, 0, -sender.imageView.width)];
//        }else{
//            [sender setTitleEdgeInsets:UIEdgeInsetsMake(sender.imageView.height+28, -2*sender.imageView.width, 0, -sender.imageView.width)];
//        }
//        [sender2 setTitleEdgeInsets:UIEdgeInsetsMake(sender2.imageView.height+28, -2*sender2.imageView.width, 0, -sender2.imageView.width)];
//}
//
//
//
//- (UILabel*)buyVipTipLabel {
//
//    if (!_buyVipTipLabel) {
//        _buyVipTipLabel            = [[UILabel alloc] init];
//        _buyVipTipLabel.textColor    = [UIColor whiteColor];
//        _buyVipTipLabel.textAlignment = NSTextAlignmentLeft;
//        _buyVipTipLabel.font        = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 15.0 :14.0];
//        NSString *title = nil;
//        if (self.permissionVideoModel.is_video_share_over_num) {
//            title = @"您的分享解锁观看视频次数已经用完啦~";
//        }else{
//            title = [self.permissionVideoModel.is_vip isEqualToString:@"0"] ?@"您今天的免费学习次数已经用完啦~" :@"您今天已经学习5个教程啦~";
//        }
//        _buyVipTipLabel.text = title;
//    }
//    return _buyVipTipLabel;
//}
//
//
//- (UIButton*)buyVipBtn {
//
//    if (!_buyVipBtn) {
//        _buyVipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _buyVipBtn.titleLabel.font = HK_FONT_SYSTEM(13);
//        [_buyVipBtn setTitleColor:COLOR_ffffff forState:UIControlStateNormal];
//        [_buyVipBtn setTitleColor:[COLOR_ffffff colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
//
//        [_buyVipBtn setImage:imageName(@"hkplayer_vip") forState:UIControlStateNormal];
//        [_buyVipBtn setImage:imageName(@"hkplayer_vip") forState:UIControlStateSelected];
//        [_buyVipBtn addTarget:self action:@selector(buyVipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_buyVipBtn setHKEnlargeEdge:70];
//        _buyVipBtn.tag = 100;
//    }
//    return _buyVipBtn;
//}
//
//
//- (HKZFNormalPlayerShareBtn*)playerShareBtn {
//    if (!_playerShareBtn) {
//        _playerShareBtn = [[HKZFNormalPlayerShareBtn alloc]initWithFrame:CGRectZero];
//        _playerShareBtn.delegate = self;
//
//        if (self.permissionVideoModel.is_video_share_over_num) {
//            _playerShareBtn.hidden = YES;
//        }else {
//            _playerShareBtn.hidden = [self.permissionVideoModel.is_share isEqualToString:@"0"];
//        }
//        [_playerShareBtn setHKEnlargeEdge:70];
//        _playerShareBtn.tag = 102;
//    }
//    return _playerShareBtn;
//}
//
//
//- (UIButton*)collectBtn {
//
//    if (!_collectBtn) {
//        _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//
//        [_collectBtn setTitleColor:COLOR_ffffff forState:UIControlStateNormal];
//        [_collectBtn setTitleColor:[COLOR_ffffff colorWithAlphaComponent:0.7] forState:UIControlStateHighlighted];
//
//        [_collectBtn setImage:imageName(@"hkplayer_collect") forState:UIControlStateNormal];
//        [_collectBtn setImage:imageName(@"hkplayer_collect") forState:UIControlStateSelected];
//        [_collectBtn addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_collectBtn setHKEnlargeEdge:70];
//        _collectBtn.tag = 104;
//
//        _collectBtn.titleLabel.font = HK_FONT_SYSTEM(13);
//        [_collectBtn.titleLabel setNumberOfLines:0];
//        [_collectBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
//
//        NSString *title = @"收藏视频\n不丢失学习记录";
//        NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:title];
//        [attrS addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, title.length)];
//        [attrS addAttribute:NSFontAttributeName value:HK_FONT_SYSTEM(13) range:NSMakeRange(0, title.length)];
//
//        [attrS addAttribute:NSForegroundColorAttributeName value:[[UIColor whiteColor]colorWithAlphaComponent:0.7] range:NSMakeRange(5, 7)];
//        [attrS addAttribute:NSFontAttributeName value:HK_FONT_SYSTEM(10) range:NSMakeRange(5, 7)];
//        [_collectBtn setAttributedTitle:attrS forState:UIControlStateNormal];
//    }
//    return _collectBtn;
//}
//
//
//
//- (ZFHKNormalPlayerJobPathVipBtn*)jobPathVipBtn {
//    if (!_jobPathVipBtn) {
//        _jobPathVipBtn = [[ZFHKNormalPlayerJobPathVipBtn alloc]init];
//        [_jobPathVipBtn addTarget:self action:@selector(buyVipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _jobPathVipBtn;
//}
//
//
//
//- (void)buyVipBtnClick:(UIButton*)sender {
//
//    if (self.delegate && [self.delegate respondsToSelector:@selector(zfHKNormalPlayerBuyVipView:buyVipAction:)]) {
//        [self.delegate zfHKNormalPlayerBuyVipView:nil buyVipAction:sender];
//        [MobClick event:UM_RECORD_LIMIT_BUTTON];
//    }
//}
//
//
//- (void)collectBtnClick:(UIButton*)sender {
//    if (self.delegate) {
//        //[self.delegate zfHKNormalPlayerBuyVipView:nil collectVideoAction:sender];
//        [self collectOrQuitVideo];
//        [MobClick event:UM_RECORD_DETAIL_PAGE_WINDOW_COLLECT];
//    }
//
//}
//
//
//- (void)hKZFNormalPlayerShareAction:(id)sender {
//
//    if (self.delegate && [self.delegate respondsToSelector:@selector(zfHKNormalPlayerBuyVipView:shareAction:)]) {
//        [self.delegate zfHKNormalPlayerBuyVipView:nil shareAction:sender];
//        [MobClick event:UM_RECORD_DETAIL_PAGE_SHARE_TO_WATCH];
//    }
//}
//
//
//
//#pragma mark - 收藏  或 取消收藏
//- (void)collectOrQuitVideo {
//    WeakSelf;
//    BOOL isCollect = self.detailModel.is_collect;
//    NSString *type = isCollect ?@"2" :@"1"; //收藏的状态
//    [[FWNetWorkServiceMediator sharedInstance] collectOrQuitVideoWithToken:nil videoId:_detailModel.video_id type:type videoType:[_detailModel.video_type integerValue] postNotification:NO completion:^(FWServiceResponse *response) {
//
//        StrongSelf;
//        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
//            NSDictionary *dict = nil;
//            if ([type isEqualToString:@"1"]) {
//                dict = @{@"isCollect": @"1",@"video_id": strongSelf.detailModel.video_id};
//            }else{
//                dict = @{@"isCollect": @"0",@"video_id": strongSelf.detailModel.video_id};
//            }
//            HK_NOTIFICATION_POST_DICT(HKCollectVideoNotification, nil, dict);
//        }
//    } failBlock:^(NSError *error) {
//
//    }];
//}
//
//
//
//
//@end
//
//
//
//
//
//
//@interface ZFHKNormalPlayerJobPathVipBtn()
//
//@property (nonatomic,strong) UIImageView *icIV;
//
//@property (nonatomic,strong) UILabel *themeLB;
///** 描述 */
//@property (nonatomic,strong) UILabel *descrLB;
//
//@property (nonatomic,strong) UILabel *tagLB;
//
//@end
//
//
//@implementation ZFHKNormalPlayerJobPathVipBtn
//
//
//- (instancetype)init {
//    if (self = [super init]) {
//        [self createUI];
//    }
//    return self;
//}
//
//
//- (void)createUI {
//
//    [self setBackgroundImage:imageName(@"btn_startvip_v2_13") forState:UIControlStateNormal];
//    [self setBackgroundImage:imageName(@"btn_startvip_v2_13") forState:UIControlStateHighlighted];
//}
//
//
//- (UIImageView*)icIV {
//    if (!_icIV) {
//        _icIV = [UIImageView new];
//        _icIV.image = imageName(@"hkplayer_jobPath_vip");
//    }
//    return _icIV;
//}
//
//
//- (UILabel*)themeLB {
//    if (!_themeLB) {
//        _themeLB = [UILabel labelWithTitle:CGRectZero title:@"开通VIP" titleColor:[UIColor whiteColor] titleFont:@"19" titleAligment:NSTextAlignmentLeft];
//        _themeLB.font = HK_FONT_SYSTEM_BOLD(19);
//        _themeLB.backgroundColor = [UIColor clearColor];
//    }
//    return _themeLB;
//}
//
//
//
//- (UILabel*)descrLB {
//    if (!_descrLB) {
//        _descrLB = [UILabel labelWithTitle:CGRectZero title:@"解锁全部职业路径课程！" titleColor:[UIColor whiteColor] titleFont:@"12" titleAligment:NSTextAlignmentCenter];
//        _descrLB.backgroundColor = [UIColor clearColor];
//    }
//    return _descrLB;
//}
//
//
//@end
//
