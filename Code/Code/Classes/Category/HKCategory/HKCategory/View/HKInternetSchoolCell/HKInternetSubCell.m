//
//  HKInternetSubCell.m
//  Code
//
//  Created by Ivan li on 2021/7/12.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKInternetSubCell.h"
#import "UIView+HKLayer.h"
#import "UIView+Banner.h"
#import "HKImageTextIV.h"
#import "HKLiveListModel.h"

@interface HKInternetSubCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatorImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, strong)HKImageTextIV *animationIV; // 正在播放的动画
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeftMargin;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signBtnWidth;
@property (weak, nonatomic) IBOutlet UIButton *flagBtn;

@end

@implementation HKInternetSubCell

- (HKImageTextIV*)animationIV {
    if (!_animationIV) {
        _animationIV = [[HKImageTextIV alloc]init];
        _animationIV.isRemoveRoundedCorner = YES;
        _animationIV.liveAnimationType = HKCategaryAnimationType_liveList;
        _animationIV.textColor = [UIColor whiteColor];
    }
    return _animationIV;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgView.backgroundColor = COLOR_FFFFFF_3D4752;
    [self.bgView addCornerRadius:5];
    [self.bgView addShadowWithColor:[UIColor blackColor] alpha:0.1 radius:2 offset:CGSizeMake(0, 0)];
    [self.coverView addCornerRadius:5];
    [self.avatorImgV addCornerRadius:10];
    
    [self.signBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:2];
    [self.flagBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:2];
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    self.nameLabel.textColor = COLOR_7B8196_A8ABBE;
    [self.contentView insertSubview:self.animationIV belowSubview:self.signBtn];
    
    self.animationIV.isAnimation = YES;
    [self.animationIV text:@"直播中" hiddenIfTextEmpty:NO];
    

    self.animationIV.hidden = NO;
    self.animationIV.backgroundColor= [UIColor brownColor];
    self.signBtn.hidden = YES;
    self.flagBtn.hidden = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.signBtn addVerticalGradientLayerColors:@[(id)[UIColor colorWithHexString:@"#FFD305"].CGColor,(id)[UIColor colorWithHexString:@"#FF9A00"].CGColor]];
        [self.signBtn addRoundedCornersWithRadius:5 byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight];
        [self.flagBtn addVerticalGradientLayerColors:@[(id)[UIColor colorWithHexString:@"#FFD305"].CGColor,(id)[UIColor colorWithHexString:@"#FF9A00"].CGColor]];
        [self.flagBtn addRoundedCornersWithRadius:5 byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight];
    });
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.animationIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.bgView);
        make.height.mas_equalTo(@20);
    }];
    
    [self.animationIV addRoundedCornersWithRadius:5 byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight];
}


-(void)setLiveModel:(HKLiveListModel *)liveModel{
    _liveModel= liveModel;
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:liveModel.surface_url]] placeholderImage:[UIImage imageNamed:HK_Placeholder]];
    self.titleLabel.text = liveModel.name;
    [self.signBtn setTitle:liveModel.tag_left_up forState:UIControlStateNormal];
    [self.flagBtn setTitle:liveModel.tag_left_up forState:UIControlStateNormal];
    if (self.isTrain == -1) {//训练营
        self.signBtn.hidden = self.liveModel.tag_left_up.length ? NO : YES;
        self.flagBtn.hidden = YES;
        self.animationIV.hidden = YES;
        self.avatorImgV.hidden = YES;
        self.nameLeftMargin.constant = 5.0;
        self.nameLabel.text = liveModel.start_live_at_str;
    }else{//直播课
        [self.flagBtn setImage:[UIImage imageNamed:@"ic_notice_live_2_36"] forState:UIControlStateNormal];
        self.signBtn.hidden = YES;
        if (liveModel.is_in_live_time) {
            self.flagBtn.hidden = YES;
            self.animationIV.hidden = NO;
            self.nameLeftMargin.constant = 30.0;
            self.avatorImgV.hidden = NO;
            [self.avatorImgV sd_setImageWithURL:[NSURL URLWithString:liveModel.teacher_avator] placeholderImage:[UIImage imageNamed:HK_Placeholder]];
            self.nameLabel.text = liveModel.teacher_name;
        }else{
            self.flagBtn.hidden = self.liveModel.tag_left_up.length ? NO : YES;
            self.animationIV.hidden = YES;
            self.nameLeftMargin.constant = 5.0;
            self.avatorImgV.hidden = YES;
            self.nameLabel.text = liveModel.start_live_at_str;
        }
    }
}

@end
