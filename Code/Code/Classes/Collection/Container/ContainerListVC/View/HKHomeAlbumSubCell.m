//
//  HKHomeAlbumSubCell.m
//  Code
//
//  Created by yxma on 2020/11/11.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKHomeAlbumSubCell.h"
#import "HKContainerModel.h"
#import "UIView+HKLayer.h"
//#import "UILabel+Helper.h"

@interface HKHomeAlbumSubCell ()
@property (weak, nonatomic) IBOutlet UILabel *hasTextLabel;

@end

@implementation HKHomeAlbumSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.imgV addCornerRadius:6 addBoderWithColor:[UIColor clearColor] BoderWithWidth:1.5];
    [self.moreLabel addCornerRadius:6];
    self.titleLabel.textColor = COLOR_27323F_FFFFFF;
    self.hasTextLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    self.hasTextLabel.textColor = COLOR_FFFFFF_38434E;
    [self.hasTextLabel addCornerRadius:3];
    [UILabel changeLineSpaceForLabel:self.titleLabel WithSpace:2];

    self.numberLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    self.numberLabel.textColor = COLOR_FFFFFF_38434E;
    [self.numberLabel addCornerRadius:3];

    self.imgV.userInteractionEnabled = YES;
}


-(void)setVideoModel:(VideoModel *)videoModel{
    _videoModel = videoModel;
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:videoModel.img_cover_url]] placeholderImage:imageName(HK_Placeholder)];
    self.titleLabel.text = videoModel.video_titel;
    self.moreLabel.hidden = YES;
    self.titleLabel.hidden = NO;
    self.imgV.hidden = NO;
    self.hasTextLabel.hidden = videoModel.has_pictext ? NO : YES;
    
}

-(void)setAlbumModel:(HKAlbumModel *)albumModel{
    _albumModel = albumModel;
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:albumModel.cover]] placeholderImage:imageName(HK_Placeholder)];
    self.titleLabel.text = albumModel.name;
    self.moreLabel.hidden = YES;
    self.titleLabel.hidden = NO;
    self.imgV.hidden = NO;
}

- (void)setModel:(HKCourseModel *)model videoType:(HKVideoType)videoType{
    
    if (self.isVideoDetail) {
        // 设置文字
        if (videoType == HKVideoType_Series || videoType == HKVideoType_UpDownCourse) {
            // 系列课
            self.titleLabel.text = model.title;
        }else if (videoType == HKVideoType_LearnPath || videoType == HKVideoType_Practice || videoType == HKVideoType_Ordinary) {
            // 软件入门
            self.titleLabel.text = model.title;
        }else if (videoType == HKVideoType_PGC) {
            // pgc
            self.titleLabel.text = model.video_title;
        }else if (videoType == HKVideoType_JobPath) {
            // pgc
            self.titleLabel.text = model.video_title;
        }else if (videoType == HKVideoType_JobPath_Practice) {
            // pgc
            self.titleLabel.text =  model.video_title;
        }
    }else{
        // 设置文字
        if (videoType == HKVideoType_Series || videoType == HKVideoType_UpDownCourse) {
            // 系列课
            self.titleLabel.text = [NSString stringWithFormat:@"%@ %@", model.praticeNO, model.title];
        }else if (videoType == HKVideoType_LearnPath || videoType == HKVideoType_Practice || videoType == HKVideoType_Ordinary) {
            // 软件入门
            self.titleLabel.text = [NSString stringWithFormat:@"%@ %@", model.praticeNO, model.title];
        }else if (videoType == HKVideoType_PGC) {
            // pgc
            self.titleLabel.text = [NSString stringWithFormat:@"%@ %@", model.praticeNO, model.video_title];
        }else if (videoType == HKVideoType_JobPath) {
            // pgc
            self.titleLabel.text = [NSString stringWithFormat:@"%@ %@", model.praticeNO, model.video_title];
        }else if (videoType == HKVideoType_JobPath_Practice) {
            // pgc
            self.titleLabel.text = [NSString stringWithFormat:@"%@ %@", model.praticeNO, model.video_title];
        }
    }
    
    
    
    
    
    
    
    
    if (self.isVideoDetail) {
        [self.imgV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.cover]] placeholderImage:imageName(HK_Placeholder)];
        self.imgV.layer.borderColor = model.currentWatching ? [UIColor redColor].CGColor : [UIColor clearColor].CGColor;        
        
    }else{
        [self.imgV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.image_url]] placeholderImage:imageName(HK_Placeholder)];
    }
    self.titleLabel.textColor = model.currentWatching ? [UIColor redColor] : COLOR_27323F_FFFFFF;
    
    
}

@end
