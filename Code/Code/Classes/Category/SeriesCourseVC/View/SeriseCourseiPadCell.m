//
//  SeriseCourseiPadCell.m
//  Code
//
//  Created by eon Z on 2022/3/14.
//  Copyright © 2022 pg. All rights reserved.
//

#import "SeriseCourseiPadCell.h"
#import "UIView+HKLayer.h"

@interface SeriseCourseiPadCell ()
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UIView *videoCountView;
@property (weak, nonatomic) IBOutlet UILabel *videoCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *fatherView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMargin;

@end

@implementation SeriseCourseiPadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_titleLabel setTextColor:COLOR_27323F_EFEFF6];
    _titleLabel.font = HK_FONT_SYSTEM(15);
    self.videoCountLabel.font = HK_FONT_SYSTEM(14);
    self.videoCountLabel.textColor = [UIColor whiteColor];
    self.videoCountView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    
    self.totalTimeLabel.font = HK_FONT_SYSTEM(13);
    self.totalTimeLabel.textColor = COLOR_A8ABBE_7B8196;

    [self setShadowColor];
    [self.fatherView addCornerRadius:5];
    self.fatherView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.shadowView.backgroundColor = COLOR_FFFFFF_3D4752;

}

- (void)setShadowColor {
    self.shadowView.layer.cornerRadius = 5;
    if (@available(iOS 13.0, *)) {
        UIColor *shadowColor = [UIColor hkdm_colorWithColorLight:[COLOR_E1E7EB colorWithAlphaComponent:0.5] dark:[UIColor clearColor]];
        ;
        [self.shadowView addShadowWithColor:COLOR_D2D6E4_27323F alpha:1 radius:3 offset:CGSizeMake(0, 0)];
    }else{
        [self.shadowView addShadowWithColor:[COLOR_E1E7EB colorWithAlphaComponent:0.5]  alpha:1 radius:3 offset:CGSizeMake(0, 0)];
    }
}

- (void)setVideoModel:(VideoModel *)videoModel {
    _videoModel = videoModel;
    [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:videoModel.cover_image_url]] placeholderImage:imageName(HK_Placeholder)];
    _titleLabel.text = [NSString stringWithFormat:@"%@",videoModel.title];
    self.videoCountLabel.text = [NSString stringWithFormat:@"共%@节",videoModel.video_total];
    self.totalTimeLabel.hidden = YES;
}


- (void)setModel:(VideoModel *)model {
    
    _model = model;
    NSString *url = model.cover_image_url;
    
    _titleLabel.text = [NSString stringWithFormat:@"%@",model.title];
    [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:url]] placeholderImage:imageName(HK_Placeholder)];
    self.totalTimeLabel.text = [NSString stringWithFormat:@"视频时长：%@",model.time];
    self.videoCountView.hidden = YES;
    self.totalTimeLabel.hidden = NO;
    /// v2.17 隐藏
    //_watchLabel.text = isEmpty(model.video_view)? nil :[NSString stringWithFormat:@"%@人观看",model.video_view];
    //_categoryLabel.text = [NSString stringWithFormat:@"软件：%@",model.video_application];
}

- (void)dmTraitCollectionDidChange:(DMTraitCollection *)previousTraitCollection {
    if (@available(iOS 13.0, *)) {
        [self setShadowColor];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    BOOL isLeftCell = self.index.row % 2 == 0;
    if (self.model) {
        if (isLeftCell) {
            self.leftMargin.constant = 15;
            self.rightMargin.constant = 5;
        }else{
            self.leftMargin.constant = 5;
            self.rightMargin.constant = 15;
        }
    }

}

@end
