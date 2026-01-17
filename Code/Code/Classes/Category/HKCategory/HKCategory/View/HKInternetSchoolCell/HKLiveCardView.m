//
//  HKLiveCardView.m
//  Code
//
//  Created by eon Z on 2021/12/17.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKLiveCardView.h"
#import "UIView+HKLayer.h"
#import "UIView+Banner.h"
#import "HKImageTextIV.h"
#import "HKLiveListModel.h"

@interface HKLiveCardView ()
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UIButton *flagBtn;
@property (weak, nonatomic) IBOutlet UIImageView *avatorImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeftMargin;
@property (nonatomic, strong)HKImageTextIV *animationIV; // 正在播放的动画

@end

@implementation HKLiveCardView

- (HKImageTextIV*)animationIV {
    if (!_animationIV) {
        _animationIV = [[HKImageTextIV alloc]init];
        _animationIV.isRemoveRoundedCorner = YES;
        _animationIV.liveAnimationType = HKCategaryAnimationType_liveList;
        _animationIV.textColor = [UIColor whiteColor];
        _animationIV.font = [UIFont systemFontOfSize:11];
        _animationIV.isCategoryLeftCell = YES;
    }
    return _animationIV;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.coverView addCornerRadius:5];
    [self.avatorImgV addCornerRadius:10];
    
    [self.flagBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:2];
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    self.nameLabel.textColor = COLOR_7B8196_A8ABBE;
    [self insertSubview:self.animationIV belowSubview:self.flagBtn];
    
    self.animationIV.isAnimation = YES;
    [self.animationIV text:@"直播中" hiddenIfTextEmpty:NO];
    

    self.animationIV.hidden = NO;
    self.animationIV.backgroundColor= [UIColor brownColor];
    self.flagBtn.hidden = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.flagBtn addVerticalGradientLayerColors:@[(id)[UIColor colorWithHexString:@"#FFD305"].CGColor,(id)[UIColor colorWithHexString:@"#FF9A00"].CGColor]];
        [self.flagBtn addRoundedCornersWithRadius:5 byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight];
    });
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.animationIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.left.equalTo(self).offset(10);
        make.height.mas_equalTo(@20);
        make.width.mas_equalTo(@60);
    }];
    
    [self.animationIV addRoundedCornersWithRadius:5 byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight];
}

-(void)setLiveModel:(HKLiveListModel *)liveModel{
    _liveModel= liveModel;
    //_liveModel.tag_left_up = @"还有一天";
    
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:liveModel.surface_url]] placeholderImage:[UIImage imageNamed:HK_Placeholder]];
    self.titleLabel.text = liveModel.name;
    [self.flagBtn setTitle:liveModel.tag_left_up forState:UIControlStateNormal];
    [self.flagBtn setImage:[UIImage imageNamed:@"ic_notice_live_2_36"] forState:UIControlStateNormal];
    if (liveModel.is_in_live_time) {
        self.flagBtn.hidden = YES;
        self.animationIV.hidden = NO;
        self.animationIV.isAnimation = YES;
        self.nameLeftMargin.constant = 30.0;
        self.avatorImgV.hidden = NO;
        [self.avatorImgV sd_setImageWithURL:[NSURL URLWithString:liveModel.teacher_avator] placeholderImage:[UIImage imageNamed:HK_Placeholder]];
        self.nameLabel.text = liveModel.teacher_name;
    }else{
        self.flagBtn.hidden = self.liveModel.tag_left_up.length ? NO : YES;
        self.animationIV.hidden = YES;
        self.animationIV.isAnimation = NO;
        self.nameLeftMargin.constant = 5.0;
        self.avatorImgV.hidden = YES;
        self.nameLabel.text = liveModel.start_live_at_str;
    }
}
@end
