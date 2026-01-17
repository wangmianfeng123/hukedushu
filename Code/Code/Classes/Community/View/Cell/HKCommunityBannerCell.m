//
//  HKCommunityBannerCell.m
//  Code
//
//  Created by Ivan li on 2021/6/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKCommunityBannerCell.h"
#import "UIView+HKLayer.h"
#import "HKMonmentTypeModel.h"


@interface HKCommunityBannerCell ()
@property (weak, nonatomic) IBOutlet UIView *leftBgView;
@property (weak, nonatomic) IBOutlet UIView *rightBgView;
@property (weak, nonatomic) IBOutlet UIImageView *leftBannerImg;
@property (weak, nonatomic) IBOutlet UIImageView *rightBannerImg;

@end

@implementation HKCommunityBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    [self.leftBgView addShadowCornerRadius:5 shadowOffset:CGSizeMake(0, 0) shadowRadius:3];
    [self.rightBgView addShadowCornerRadius:5 shadowOffset:CGSizeMake(0, 0) shadowRadius:3];
    [self.leftBannerImg addCornerRadius:5];
    [self.rightBannerImg addCornerRadius:5];
    
    UITapGestureRecognizer * leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftTapClick)];
    self.leftBannerImg.userInteractionEnabled = YES;
    [self.leftBannerImg addGestureRecognizer:leftTap];
    
    
    UITapGestureRecognizer * rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightTapClick)];
    self.rightBannerImg.userInteractionEnabled = YES;
    [self.rightBannerImg addGestureRecognizer:rightTap];
}


-(void)setAd_data:(NSMutableArray *)ad_data{
    _ad_data = ad_data;
    if (ad_data.count >= 1) {
        HKADdataModel * bannerModel = self.ad_data[0];
        [self.leftBannerImg sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:bannerModel.img_url]] placeholderImage:[UIImage imageNamed:HK_Placeholder]];
    }
    
    if (ad_data.count >= 2) {
        HKADdataModel * bannerModel = self.ad_data[1];
        [self.rightBannerImg sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:bannerModel.img_url]] placeholderImage:[UIImage imageNamed:HK_Placeholder]];
    }
}

-(void)leftTapClick{
    if (self.ad_data.count >= 1 && self.didImgBlock) {
        HKADdataModel * bannerModel = self.ad_data[0];
        self.didImgBlock(bannerModel);
        [MobClick event: community_ad1];
    }
}

- (void)rightTapClick{
    if (self.ad_data.count >= 2 && self.didImgBlock) {
        HKADdataModel * bannerModel = self.ad_data[1];
        self.didImgBlock(bannerModel);
        [MobClick event: community_ad2];
    }
}
@end
