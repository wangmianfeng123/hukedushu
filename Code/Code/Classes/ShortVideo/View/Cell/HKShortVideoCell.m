//
//  HKShortVideoCell.m
//  Code
//
//  Created by Ivan li on 2019/3/25.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKShortVideoCell.h"
#import "UIView+ZFHKNormalFrame.h"
#import "ZFLoadingView.h"
#import "UIButton+ImageTitleSpace.h"
#import "ZFHKNormalPlayer.h"
#import "UIButton+WebCache.h"
#import "UIImage+Helper.h"
#import "HKShortVideoModel.h"
#import "ZFHKNormalUtilities.h"
#import "NSString+MD5.h"
#import <YYText/NSAttributedString+YYText.h>



@interface HKShortVideoCell ()

@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) UIImageView *userIV;

@property (nonatomic, strong) UIButton *userBtn;

@property (nonatomic, strong) UILabel *userNameLb;


@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UIView *effectView;

@property (nonatomic, strong)LOTAnimationView *praiseAnimationView;

@property (nonatomic, strong)LOTAnimationView *followAnimationView;
/**阴影背景*/
@property (nonatomic, strong) UIImageView *shadowIV;
/** bottom 阴影背景*/
@property (nonatomic, strong) UIView *bottomToolView;
/** top 阴影背景*/
@property (nonatomic, strong) UIView *topToolView;

@property (nonatomic, strong) UIButton *playBtn;
/** 相关视频 */
@property (nonatomic, strong) UIButton *relatedVideoBtn;
/** 分类标签 */
@property (nonatomic, strong) UIImageView *categoryTagIV;
/** 分类Lable */
@property (nonatomic, strong) UILabel *categoryLB;
/** 分类 标签背景 view */
@property (nonatomic, strong) UIView *tagBgView;

@end



@implementation HKShortVideoCell



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
        [self.contentView addSubview:self.bgImgView];
        [self.bgImgView addSubview:self.effectView];
        [self.contentView addSubview:self.coverImageView];
        
        [self.contentView addSubview:self.shadowIV];
        [self.contentView addSubview:self.bottomToolView];
        [self.contentView addSubview:self.topToolView];
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.likeBtn];
        [self.contentView addSubview:self.commentBtn];
        [self.contentView addSubview:self.shareBtn];
        [self.contentView addSubview:self.followBtn];
        
        [self.contentView addSubview:self.userNameLb];
        [self.contentView addSubview:self.userBtn];
        [self.contentView addSubview:self.likeLB];
        [self.contentView addSubview:self.commentLB];
        [self.contentView addSubview:self.shareLB];
        
        [self addSubview:self.playBtn];
        
        [self addSubview:self.tagBgView];
        [self addSubview:self.relatedVideoBtn];
        [self addSubview:self.categoryTagIV];
        [self addSubview:self.categoryLB];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.coverImageView.frame = self.contentView.bounds;
    self.bgImgView.frame = self.contentView.bounds;
    self.effectView.frame = self.bgImgView.bounds;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-68);
        //make.bottom.equalTo(self.contentView).offset(IS_IPHONE_X ?(-(25)) :-(KTabBarHeight49+25));
        make.bottom.equalTo(self.contentView).offset(IS_IPHONE_X ?(-(32)) :-(KTabBarHeight49+32));
    }];
    
    [self.userBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.titleLabel.mas_top).offset(-8);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    
    [self.userNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userBtn);
        make.width.mas_lessThanOrEqualTo(200);
        make.left.equalTo(self.userBtn.mas_right).offset(10);
    }];
    
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userBtn);
        make.left.equalTo(self.userNameLb.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(60, 22));
    }];
    
    // 点赞
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shareBtn);
        make.bottom.equalTo(self.commentBtn.mas_top).offset(-39);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    [self.likeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.likeBtn);
        make.top.equalTo(self.likeBtn.mas_bottom).offset(3);
        make.right.mas_lessThanOrEqualTo(self.contentView);
    }];
    
    // 评论
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shareBtn);
        make.bottom.equalTo(self.shareBtn.mas_top).offset(-39);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    [self.commentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.commentBtn);
        make.top.equalTo(self.commentBtn.mas_bottom).offset(3);
        make.right.mas_lessThanOrEqualTo(self.contentView);
    }];
    
    // 分享
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.userBtn.mas_top).offset(-3);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    [self.shareLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.shareBtn);
        make.top.equalTo(self.shareBtn.mas_bottom).offset(3);
        make.right.mas_lessThanOrEqualTo(self.contentView);
    }];

    [self.shadowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
    }];
    
    [self.bottomToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.mas_equalTo(538/2);
        //make.top.equalTo(self.likeBtn);
    }];
    
    [self.topToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(KNavBarHeight64);
        //make.height.mas_equalTo(IS_IPHONE_X ?KNavBarHeight64);
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
        
    [self.tagBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.top.equalTo(self.categoryLB);
        make.right.equalTo(self.categoryLB);
        make.left.equalTo(self.categoryTagIV);
    }];
    
    [self.relatedVideoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userBtn);
        make.bottom.equalTo(self.userBtn.mas_top).offset(-16);
        make.size.mas_equalTo(CGSizeMake(156, 35));
    }];
    
    [self.categoryTagIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.categoryLB);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    [self.categoryLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.categoryTagIV.mas_right).offset(8);
        make.right.mas_lessThanOrEqualTo(self.contentView).offset(-68);
        make.bottom.equalTo(self.contentView).offset(IS_IPHONE_X ?(-(8)) :-(KTabBarHeight49+8));
    }];
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}


- (UILabel *)userNameLb {
    if (!_userNameLb) {
        _userNameLb = [UILabel new];
        _userNameLb.textColor = [UIColor whiteColor];
        _userNameLb.font = HK_FONT_SYSTEM_WEIGHT(16, UIFontWeightSemibold);
    }
    return _userNameLb;
}


- (YYLabel *)likeLB {
    if (!_likeLB) {
        _likeLB = [YYLabel new];
        _likeLB.textColor = [UIColor whiteColor];
        _likeLB.font = HK_FONT_SYSTEM_WEIGHT(12, UIFontWeightMedium);
        _likeLB.textAlignment = NSTextAlignmentCenter;
        
        // 阴影
//        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"99"];
//        one.yy_font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium];
//        one.yy_color = [UIColor whiteColor];
//        YYTextShadow *shadow = [YYTextShadow new];
//        shadow.color = [UIColor colorWithWhite:0.000 alpha:0.20];
//        shadow.offset = CGSizeMake(0.5, 0.5);
//        shadow.radius = 1;
//        one.yy_textInnerShadow = shadow;
//        _likeLB.attributedText = one;
//        [text appendAttributedString:one];
//        [text appendAttributedString:[self padding]];
    }
    return _likeLB;
}

- (UIButton *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBtn setImage:[UIImage imageNamed:@"ic_good_normal_v2_10"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"ic_good_checked_v2_10"] forState:UIControlStateSelected];
        [_likeBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _likeBtn.tag = 20;
        [_likeBtn setHKEnlargeEdge:20];
    }
    return _likeBtn;
}


- (UIButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn setImage:[UIImage imageNamed:@"short_video_comment"] forState:UIControlStateNormal];
        [_commentBtn setImage:[UIImage imageNamed:@"short_video_comment"] forState:UIControlStateSelected];
        [_commentBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _commentBtn.tag = 220;
        [_commentBtn setHKEnlargeEdge:20];
    }
    return _commentBtn;
}

- (UILabel *)commentLB {
    if (!_commentLB) {
        _commentLB = [UILabel new];
        _commentLB.textColor = [UIColor whiteColor];
        _commentLB.text = @"评论";
        _commentLB.font = HK_FONT_SYSTEM_WEIGHT(12, UIFontWeightMedium);
        _commentLB.textAlignment = NSTextAlignmentCenter;
        
        // 阴影
//        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"Inner Shadow"];
//        one.yy_font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium];
//        one.yy_color = [UIColor whiteColor];
//        YYTextShadow *shadow = [YYTextShadow new];
//        shadow.color = [UIColor colorWithWhite:0.000 alpha:0.40];
//        shadow.offset = CGSizeMake(0, 1);
//        shadow.radius = 1;
//        one.yy_textInnerShadow = shadow;
//        _commentLB.attributedText = one;
        
    }
    return _commentLB;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"short_video_share"] forState:UIControlStateNormal];
        [_shareBtn setImage:[UIImage imageNamed:@"short_video_share"] forState:UIControlStateSelected];
        [_shareBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _shareBtn.tag = 2220;
        [_shareBtn setHKEnlargeEdge:20];
    }
    return _shareBtn;
}

- (UILabel *)shareLB {
    if (!_shareLB) {
        _shareLB = [UILabel new];
        _shareLB.textColor = [UIColor whiteColor];
        _shareLB.text = @"分享";
        _shareLB.font = HK_FONT_SYSTEM_WEIGHT(12, UIFontWeightMedium);
        _shareLB.textAlignment = NSTextAlignmentCenter;
        
        // 阴影
//        _shareLB.layer.shadowColor = [UIColor blackColor].CGColor;
//        _shareLB.layer.shadowOffset = CGSizeMake(0, 1);
//        _shareLB.layer.shadowOpacity = 0.5;
    }
    return _shareLB;
}



- (UIButton *)followBtn {
    if (!_followBtn) {
        _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_followBtn setBackgroundImage:[UIImage imageNamed:@"ic_follow_normal_v2_10"] forState:UIControlStateNormal];
        [_followBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_followBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _followBtn.tag = 30;
        [_followBtn setHKEnlargeEdge:15];
        [_followBtn.titleLabel setFont:HK_FONT_SYSTEM_WEIGHT(13, UIFontWeightSemibold)];
    }
    return _followBtn;
}



- (void)buttonClick:(UIButton*)btn {
    
    switch (btn.tag) {
        case 20:
        {// 点赞
            if (self.delegate && [self.delegate respondsToSelector:@selector(hkShortVideoCell:likeBtn:model:)]) {
                [self.delegate hkShortVideoCell:self likeBtn:btn model:self.videoModel];
                if (isLogin()) {
                    if (!self.videoModel.like) {
                        [self showPraiseAnimation:btn];
                    }
                }
            }
        }
            break;
    
        case 220:
        {// 评论
            if (self.delegate && [self.delegate respondsToSelector:@selector(hkShortVideoCell:commentBtn:model:)]) {
                [self.delegate hkShortVideoCell:self commentBtn:btn model:self.videoModel];
            }
        }
            break;
            
        case 2220:
        {// 分享
            if (self.delegate && [self.delegate respondsToSelector:@selector(hkShortVideoCell:shareBtn:model:)]) {
                [self.delegate hkShortVideoCell:self shareBtn:btn model:self.videoModel];
            }
        }
            break;
            
            
            
        case 30:
        {// 关注
            if (self.delegate && [self.delegate respondsToSelector:@selector(hkShortVideoCell:followBtn:model:)]) {
                [self.delegate hkShortVideoCell:self followBtn:btn model:self.videoModel];
                if (isLogin()) {
                    [self showfollowAnimation:btn];
                }
            }
        }
            break;
        case 40:
        {// 头像
            if (self.delegate && [self.delegate respondsToSelector:@selector(hkShortVideoCell:userBtn:model:)]) {
                [self.delegate hkShortVideoCell:self userBtn:btn model:self.videoModel];
            }
        }
            break;
    }
}



/** 自动点击 点赞 */
- (void)autoLikeBtnClick {
    
    if (self.videoModel.like) {
        [self showPraiseAnimation:self.likeBtn];
    }else{
        [self buttonClick:self.likeBtn];
    }
}


- (LOTAnimationView*)praiseAnimationView {
    if (!_praiseAnimationView) {
        _praiseAnimationView = [LOTAnimationView animationNamed:@"hk_click_praise.json"];
        _praiseAnimationView.loopAnimation = NO;
    }
    return _praiseAnimationView;
}



- (LOTAnimationView*)followAnimationView {
    if (!_followAnimationView) {
        _followAnimationView = [LOTAnimationView animationNamed:@"hk_focuse.json"];
        _followAnimationView.loopAnimation = NO;
    }
    return _followAnimationView;
}


// 点赞动画
- (void)showPraiseAnimation:(UIButton*)btn {
    
    btn.enabled = NO;
    btn.hidden = YES;
    @weakify(self);
    [self.praiseAnimationView playWithCompletion:^(BOOL animationFinished) {
        @strongify(self);
        btn.enabled = YES;
        btn.hidden = NO;
        TTVIEW_RELEASE_SAFELY(self.praiseAnimationView);
    }];
    self.praiseAnimationView.frame = btn.frame;
    [self.contentView addSubview:self.praiseAnimationView];
}


// 关注动画
- (void)showfollowAnimation:(UIButton*)btn {
    @weakify(self);
    btn.hidden = YES;
    [self.followAnimationView playWithCompletion:^(BOOL animationFinished) {
        @strongify(self);
        TTVIEW_RELEASE_SAFELY(self.followAnimationView);
    }];
    self.followAnimationView.frame = btn.frame;
    [self.contentView addSubview:self.followAnimationView];
}





- (void)setVideoModel:(HKShortVideoModel *)videoModel {
    
    _videoModel = videoModel;
    
    [self.coverImageView sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:videoModel.cover_url]) placeholderImage:imageName(@"bg_video_v2_10")];
    [self.bgImgView sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:videoModel.cover_url]) placeholderImage:imageName(@"bg_video_v2_10")];
    
    [self.userBtn sd_setImageWithURL:HKURL(videoModel.teacher.avator) forState:UIControlStateNormal placeholderImage:HK_PlaceholderImage];
    [self.userBtn sd_setImageWithURL:HKURL(videoModel.teacher.avator) forState:UIControlStateHighlighted placeholderImage:HK_PlaceholderImage];
    
    
    self.titleLabel.text = isEmpty(videoModel.desc)?@" "  :videoModel.desc;
    
    self.followBtn.hidden = videoModel.teacher.flower;
    
    self.likeBtn.selected = videoModel.like;
    
    self.userNameLb.text = isEmpty(videoModel.teacher.name)?@" "  :videoModel.teacher.name;
    
    self.likeLB.text = [NSString shortVideoFormatCount:videoModel.likeCount];
    self.commentLB.text = [NSString shortVideoCommentCount:videoModel.commentCount.intValue];
    self.bottomToolView.hidden = videoModel.isHiddenBottomView;
    
    self.categoryLB.text = videoModel.video_tag.tag;
    self.categoryTagIV.hidden = isEmpty(videoModel.video_tag.tag);
    
    if (isEmpty(videoModel.relation_video_id) || ([videoModel.relation_video_id integerValue] == 0)) {
        self.relatedVideoBtn.hidden = YES;
    }else{
        self.relatedVideoBtn.hidden = NO;
        //0:不关联 1:来源视频 2:推荐视频
        NSString *title = ([videoModel.relation_type isEqualToString:@"1"]) ?@"观看完整视频" : @"观看相关视频";
        [self.relatedVideoBtn setTitle:title forState:UIControlStateNormal];
        [self.relatedVideoBtn setTitle:title forState:UIControlStateHighlighted];
    }
}



- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.tag = 100;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImageView;
}



- (UIImageView *)userIV {
    if (!_userIV) {
        _userIV = [[UIImageView alloc] init];
        _userIV.userInteractionEnabled = YES;
        _userIV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _userIV;
}


- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.userInteractionEnabled = YES;
    }
    return _bgImgView;
}


- (UIImageView *)shadowIV {
    if (!_shadowIV) {
        _shadowIV = [[UIImageView alloc] init];
        _shadowIV.userInteractionEnabled = YES;
        _shadowIV.hidden = YES;
        
//        NSArray *colorArr = @[
//                              (id)[COLOR_000000 colorWithAlphaComponent:0],
//                              (id)[COLOR_000000 colorWithAlphaComponent:0.1],
//                              (id)[COLOR_000000 colorWithAlphaComponent:0.2],
//                              (id)[COLOR_000000 colorWithAlphaComponent:0.3],
//                              (id)[COLOR_000000 colorWithAlphaComponent:0.4]];
//
////        NSArray *colorArr = @[RGB(0, 0, 0, 30),
////                              RGB(0, 0, 0, 22),
////                              RGB(0, 0, 0, 14),
////                              RGB(0, 0, 0, 7),
////                              RGB(0, 0, 0, 1)];
//
//        _shadowIV.image = [[UIImage alloc]createImageWithSize:CGSizeMake(self.contentView.width, 200) gradientColors:colorArr percentage:@[@(0.1),@(0.3),@(0.5),@(0.7),@(1)] gradientType:GradientFromTopToBottom];
        
//        CGFloat w = self.contentView.width;
//        UIColor *color = [COLOR_000000 colorWithAlphaComponent:0];
//        UIColor *color1 = [[UIColor redColor] colorWithAlphaComponent:0.2];
//        UIColor *color2 = [[UIColor blueColor] colorWithAlphaComponent:0.3];
//        _shadowIV.image = [[UIImage alloc]createImageWithSize:CGSizeMake(300, 200) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.3),@(1)] gradientType:GradientFromTopToBottom];
    }
    return _shadowIV;
}




- (UIButton *)userBtn {
    if (!_userBtn) {
        _userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_userBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_userBtn setHKEnlargeEdge:10];
        [_userBtn setEnlargeEdgeWithTop:15 right:40 bottom:15 left:15];
        _userBtn.clipsToBounds = YES;
        _userBtn.layer.cornerRadius = 20;
        _userBtn.tag = 40;
        _userBtn.layer.borderWidth = 1;
        _userBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _userBtn;
}



- (UIView *)effectView {
    if (!_effectView) {
        /**  高斯模糊
        if (@available(iOS 8.0, *)) {
            UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        } else {
            UIToolbar *effectView = [[UIToolbar alloc] init];
            effectView.barStyle = UIBarStyleBlackTranslucent;
            _effectView = effectView;
        }
            **/
        _effectView = [UIView new];
        _effectView.backgroundColor = [UIColor blackColor];
    }
    return _effectView;
}



- (UIView *)bottomToolView {
    if (!_bottomToolView) {
        _bottomToolView = [[UIView alloc] init];
        UIImage *image = imageName(@"bg_videogradual_v2_10");
        _bottomToolView.layer.contents = (id)image.CGImage;
        //_bottomToolView.hidden = YES;
       //_bottomToolView =  [[UIImageView alloc]initWithImage:imageName(@"bg_videogradual_v2_10")];
    }
    return _bottomToolView;
}


- (void)hiddenBottomToolView {
    self.bottomToolView.hidden = YES;
}


- (UIView *)topToolView {
    if (!_topToolView) {
        _topToolView = [[UIView alloc] init];
        UIImage *image = ZFHKNormalPlayer_Image(@"ZFPlayer_top_shadow");
        _topToolView.layer.contents = (id)image.CGImage;
        _topToolView.hidden = YES;
    }
    return _topToolView;
}


- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:imageName(@"hkplayer_center_play") forState:UIControlStateNormal];
        [_playBtn setImage:imageName(@"hkplayer_center_play") forState:UIControlStateHighlighted];
        [_playBtn sizeToFit];
        _playBtn.hidden = YES;
        _playBtn.userInteractionEnabled = NO;
    }
    return _playBtn;
}


- (void)hiddenPlayBtn {
    self.playBtn.hidden = YES;
}


- (void)setShowTopTool:(BOOL)showTopTool {
    _showTopTool = showTopTool;
    _topToolView.hidden = !showTopTool;
}



- (UIButton *)relatedVideoBtn {
    if (!_relatedVideoBtn) {
        _relatedVideoBtn = [UIButton buttonWithTitle:@"观看相关视频" titleColor:COLOR_ffffff titleFont:@"13" imageName:@"ic_short_start_v2.15"];
        [_relatedVideoBtn .titleLabel setFont:HK_FONT_SYSTEM_WEIGHT(13, UIFontWeightSemibold)];
        [_relatedVideoBtn addTarget:self action:@selector(relatedVideoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_relatedVideoBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        _relatedVideoBtn.clipsToBounds = YES;
        _relatedVideoBtn.layer.cornerRadius = 5;
        [_relatedVideoBtn setBackgroundColor:[COLOR_000000 colorWithAlphaComponent:0.3] forState:UIControlStateNormal];
        [_relatedVideoBtn setBackgroundColor:[COLOR_000000 colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
        _relatedVideoBtn.hidden = YES;
    }
    return _relatedVideoBtn;
}


- (void)relatedVideoBtnClick:(UIButton*)btn {
    
    if (!isEmpty(self.videoModel.relation_video_id) || ([self.videoModel.relation_video_id integerValue] != 0)) {
        //1:来源视频按钮点击  2:相关视频按钮点击
        NSString *flag = ([self.videoModel.relation_type isEqualToString:@"1"]) ?@"1" : @"2";
        [[HKALIYunLogManage sharedInstance] hkShortVideoClickLogWithFlag:flag];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(hkShortVideoCell:relatedVideoBtn:model:)]) {
        [self.delegate hkShortVideoCell:self relatedVideoBtn:btn model:self.videoModel];
    }
}



- (UIImageView*)categoryTagIV {
    if (!_categoryTagIV) {
        _categoryTagIV = [[UIImageView alloc]initWithImage:imageName(@"ic_tag_v2.15")];
        _categoryTagIV.userInteractionEnabled = YES;
        _categoryTagIV.hidden = YES;
    }
    return _categoryTagIV;
}



- (UILabel *)categoryLB {
    if (!_categoryLB) {
        _categoryLB = [UILabel new];
        _categoryLB.textColor = [UIColor whiteColor];
        _categoryLB.font = HK_FONT_SYSTEM_WEIGHT(13, UIFontWeightSemibold);
        _categoryLB.textAlignment = NSTextAlignmentLeft;
    }
    return _categoryLB;
}


- (UIView*)tagBgView {
    if (!_tagBgView) {
        _tagBgView = [UIView new];
        _tagBgView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tagClick:)];
        [_tagBgView addGestureRecognizer:tap];
    }
    return _tagBgView;
}



- (void)tagClick:(UITapGestureRecognizer*)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hkShortVideoCell:tagView:model:)]) {
        [self.delegate hkShortVideoCell:self tagView:self.tagBgView model:self.videoModel];
    }
}



@end



