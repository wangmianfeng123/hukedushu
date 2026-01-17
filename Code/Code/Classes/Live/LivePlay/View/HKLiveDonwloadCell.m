//
//  HKLiveDonwloadCell.m
//  Code
//
//  Created by eon Z on 2021/12/23.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKLiveDonwloadCell.h"
#import "UIView+HKLayer.h"

@interface HKLiveDonwloadCell ()
@property (weak, nonatomic) IBOutlet UIImageView *selectedImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *localLabel;

@property (weak, nonatomic) IBOutlet UIView *seprarator;
@property (nonatomic, strong)HKCourseModel *model;

@property (nonatomic, strong)UIColor *normalColor;
@property (nonatomic, strong)UIColor *selectedColor;

@end

@implementation HKLiveDonwloadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.normalColor = COLOR_27323F_EFEFF6;
    self.selectedColor = HKColorFromHex(0xff7c00, 1.0);
    self.localLabel.backgroundColor = COLOR_F8F9FA;
    self.localLabel.textColor = COLOR_7B8196;
    self.seprarator.backgroundColor = COLOR_F8F9FA_333D48;
    [self.localLabel addCornerRadius:8];
}

- (void)setLiveModel:(HKCourseModel *)model hiddenSpeparator:(BOOL)hidden{
    _model = model;
    // 设置颜色
    self.titleLabel.textColor = self.normalColor;
    self.selectedImg.image = model.isSelectedForDownload? imageName(@"right_green") : imageName(@"cirlce_gray");
    
    if (model.isSelectedForDownload || model.currentWatching) {
        self.titleLabel.textColor = self.selectedColor;
    }else{
        self.titleLabel.textColor = self.normalColor;
    }
    
    
    self.localLabel.hidden = model.islocalCache ? NO :YES;
    
    if ([model.can_download intValue] == 1) {
        if ([model.video_size floatValue] >= 1024) {
            self.videoSizeLabel.text = [NSString stringWithFormat:@"%0.1fG", [model.video_size floatValue]/1024.0];
        }else{
            self.videoSizeLabel.text = [NSString stringWithFormat:@"%0.2fM",[model.video_size floatValue]];
        }
    }else{
        self.videoSizeLabel.text = @"暂无视频";
    }

    self.videoSizeLabel.textColor = COLOR_A8ABBE_7B8196;
    if (model.islocalCache || [model.can_download intValue] == 0) {
        self.titleLabel.textColor = COLOR_A8ABBE_7B8196;
        self.selectedImg.image = [UIImage hkdm_imageWithNameLight:@"ic_no_select_v2.1" darkImageName:@"cirlce_gray"]; //imageName(@"ic_no_select_v2.1");
    }
    
    
    
    if (model.currentWatching) {// 当前正在观看的视频
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    }else{
        self.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    // 软件入门
    self.titleLabel.text = model.title;
    self.seprarator.hidden = hidden;
    

}

@end
